# frozen_string_literal: true

# Records test-suite timings and compares them with the budgets in
# docs/performance-contract.adoc. It never changes how the suite runs.
#
# Usage:
#   ruby scripts/check_suite_budget.rb ci [--repo OWNER/NAME]
#     (--run-id ID | --workflow FILE [--branch NAME]) [--jobs-json FILE]
#     [--test-step TEXT] [--budget-seconds N] [--output FILE] [--enforce]
#
#   ruby scripts/check_suite_budget.rb suite [--rspec-json FILE]
#     [--budget-seconds N] [--output FILE] [--enforce] -- COMMAND...
#
# ci     Reads one GitHub Actions run of the rake workflow through `gh api`
#        and reports, per matrix leg, the job's wall time and the time of the
#        step that runs the suite (the step whose name contains --test-step,
#        default "bundle exec rake"). Jobs without that step (prepare,
#        tests-passed) are listed separately and are not legs. With
#        --workflow, the newest completed run on --branch (default main)
#        that was not cancelled or skipped is used. --jobs-json reads a saved
#        `jobs` API response instead of calling GitHub. Default budget: 1800 s.
#
# suite  Runs COMMAND once, measures its wall time with a monotonic clock and,
#        when --rspec-json names the file written by RSpec's JSON formatter,
#        adds example counts and the summed example time per spec area.
#        Default budget: 600 s. The command's exit status is recorded; the
#        wrapper's own exit status follows the rules below.
#
# Output is JSON with sorted keys. When GITHUB_STEP_SUMMARY is set, a short
# Markdown table is appended to it as well.
#
# Exit status: 0 when the report was written (over-budget results included);
# 1 with --enforce when a leg or the suite is over budget, or when a `suite`
# COMMAND failed; 2 on a usage error or when the data cannot be read.

require "json"
require "open3"
require "optparse"
require "time"

module CheckSuiteBudget
  CI_SCHEMA = "plurimath-perf/ci-legs/1"
  SUITE_SCHEMA = "plurimath-perf/suite/1"
  IGNORED_CONCLUSIONS = %w[cancelled skipped].freeze

  class UsageError < StandardError; end

  module_function

  def call(argv)
    mode = argv.shift
    case mode
    when "ci" then ci(argv)
    when "suite" then suite(argv)
    else raise UsageError, "first argument must be `ci` or `suite`"
    end
  rescue UsageError, OptionParser::ParseError => e
    warn "check_suite_budget: #{e.message}"
    2
  end

  # ---- ci ---------------------------------------------------------------

  def ci(argv)
    options = ci_options(argv)
    run = nil
    jobs =
      if options[:jobs_json]
        load_jobs_file(options[:jobs_json])
      else
        run = find_run(options)
        gh_lines("repos/#{options[:repo]}/actions/runs/#{run['id']}/jobs?per_page=100", ".jobs[]")
      end

    legs, other = collect_legs(jobs, options)
    timed = legs.filter_map { |leg| leg[:job_seconds] }
    report = {
      schema: CI_SCHEMA,
      repository: options[:repo],
      run: run && {
        id: run["id"], url: run["html_url"], head_sha: run["head_sha"],
        head_branch: run["head_branch"], event: run["event"], conclusion: run["conclusion"],
        workflow_path: run["path"]
      },
      test_step_match: options[:test_step],
      budget_seconds: options[:budget],
      legs: legs,
      non_leg_jobs: other,
      summary: {
        legs: legs.size,
        legs_over_budget: legs.count { |leg| leg[:over_budget] },
        max_job_seconds: timed.max,
        median_job_seconds: median(timed),
        min_job_seconds: timed.min,
      },
    }
    write(report, options[:output])
    summary_markdown(
      "CI leg timings (budget #{options[:budget]} s)",
      %w[Leg Conclusion Job\ s Suite\ step\ s Over],
      legs.map do |l|
        [l[:name], l[:conclusion], l[:job_seconds], l[:test_step_seconds], l[:over_budget] ? "yes" : "no"]
      end,
    )
    options[:enforce] && report[:summary][:legs_over_budget].positive? ? 1 : 0
  end

  def ci_options(argv)
    options = {
      repo: ENV.fetch("GITHUB_REPOSITORY", "plurimath/plurimath"),
      branch: "main", test_step: "bundle exec rake", budget: 1800, enforce: false
    }
    OptionParser.new do |opts|
      opts.on("--repo NAME") { |v| options[:repo] = v }
      opts.on("--run-id ID", Integer) { |v| options[:run_id] = v }
      opts.on("--workflow FILE") { |v| options[:workflow] = v }
      opts.on("--branch NAME") { |v| options[:branch] = v }
      opts.on("--jobs-json FILE") { |v| options[:jobs_json] = v }
      opts.on("--test-step TEXT") { |v| options[:test_step] = v }
      opts.on("--budget-seconds N", Integer) { |v| options[:budget] = v }
      opts.on("--output FILE") { |v| options[:output] = v }
      opts.on("--enforce") { options[:enforce] = true }
    end.parse!(argv)
    options
  end

  def collect_legs(jobs, options)
    legs = []
    other = []
    jobs.each do |job|
      step = Array(job["steps"]).find { |s| s["name"].to_s.include?(options[:test_step]) }
      if step.nil?
        other << job["name"]
        next
      end
      job_seconds = seconds_between(job["started_at"], job["completed_at"])
      legs << {
        name: job["name"],
        conclusion: job["conclusion"],
        job_seconds: job_seconds,
        test_step_seconds: seconds_between(step["started_at"], step["completed_at"]),
        over_budget: job_seconds.nil? || job_seconds > options[:budget],
        url: job["html_url"],
      }
    end
    raise UsageError, "no job has a step containing #{options[:test_step].inspect}" if legs.empty?

    [legs.sort_by { |leg| leg[:name] }, other.sort]
  end

  def find_run(options)
    if options[:run_id]
      return gh_json("repos/#{options[:repo]}/actions/runs/#{options[:run_id]}")
    end
    raise UsageError, "ci needs --run-id, --workflow or --jobs-json" unless options[:workflow]

    path = "repos/#{options[:repo]}/actions/workflows/#{options[:workflow]}/runs" \
           "?branch=#{options[:branch]}&status=completed&per_page=30"
    run = gh_json(path).fetch("workflow_runs").find do |r|
      !IGNORED_CONCLUSIONS.include?(r["conclusion"])
    end
    raise UsageError, "no completed run of #{options[:workflow]} on #{options[:branch]}" unless run

    run
  end

  def load_jobs_file(path)
    data = JSON.parse(File.read(path))
    data.is_a?(Hash) ? data.fetch("jobs") : data
  rescue SystemCallError, JSON::ParserError, KeyError => e
    raise UsageError, "cannot read #{path}: #{e.message}"
  end

  def gh_json(path)
    out, err, status = Open3.capture3("gh", "api", path)
    raise UsageError, "gh api #{path} failed: #{err.strip}" unless status.success?

    JSON.parse(out)
  rescue SystemCallError => e
    raise UsageError, "cannot run gh: #{e.message}"
  end

  def gh_lines(path, filter)
    out, err, status = Open3.capture3("gh", "api", "--paginate", path, "--jq", filter)
    raise UsageError, "gh api #{path} failed: #{err.strip}" unless status.success?

    out.each_line.map { |line| JSON.parse(line) }
  rescue SystemCallError => e
    raise UsageError, "cannot run gh: #{e.message}"
  end

  def seconds_between(start, finish)
    return nil if start.nil? || finish.nil?

    (Time.iso8601(finish) - Time.iso8601(start)).round
  end

  # ---- suite ------------------------------------------------------------

  def suite(argv)
    options = { budget: 600, enforce: false }
    separator = argv.index("--")
    raise UsageError, "suite needs `-- COMMAND...`" unless separator

    command = argv[(separator + 1)..]
    raise UsageError, "suite needs a command after `--`" if command.empty?

    OptionParser.new do |opts|
      opts.on("--rspec-json FILE") { |v| options[:rspec_json] = v }
      opts.on("--budget-seconds N", Integer) { |v| options[:budget] = v }
      opts.on("--output FILE") { |v| options[:output] = v }
      opts.on("--enforce") { options[:enforce] = true }
    end.parse!(argv[0...separator])

    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    status = system(*command) ? 0 : ($?.exitstatus || 1)
    wall = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(1)

    report = {
      schema: SUITE_SCHEMA,
      command: command,
      command_exit: status,
      budget_seconds: options[:budget],
      wall_seconds: wall,
      over_budget: wall > options[:budget],
      source: { commit: ENV.fetch("GITHUB_SHA", nil), runner_image: runner_image, ruby: RUBY_DESCRIPTION },
      rspec: options[:rspec_json] && rspec_summary(options[:rspec_json]),
    }
    write(report, options[:output])
    areas = report.dig(:rspec, :areas) || {}
    summary_markdown(
      "Suite wall time #{wall} s (budget #{options[:budget]} s, exit #{status})",
      %w[Spec\ area Examples Example\ s],
      areas.sort_by { |_, a| -a[:example_seconds] }.map { |k, a| [k, a[:examples], a[:example_seconds]] },
    )
    return 1 if options[:enforce] && (status != 0 || report[:over_budget])

    0
  end

  def rspec_summary(path)
    data = JSON.parse(File.read(path))
    areas = Hash.new { |h, k| h[k] = { examples: 0, example_seconds: 0.0, failed: 0 } }
    data.fetch("examples").each do |example|
      area = areas[area_for(example["file_path"].to_s)]
      area[:examples] += 1
      area[:example_seconds] += example["run_time"].to_f
      area[:failed] += 1 if example["status"] == "failed"
    end
    areas.each_value { |a| a[:example_seconds] = a[:example_seconds].round(1) }
    summary = data.fetch("summary")
    {
      examples: summary["example_count"],
      failures: summary["failure_count"],
      pending: summary["pending_count"],
      errors_outside_examples: summary["errors_outside_of_examples_count"],
      rspec_duration_seconds: summary["duration"]&.round(1),
      load_seconds: summary["file_load_duration"]&.round(1),
      areas: areas.sort.to_h,
    }
  rescue SystemCallError, JSON::ParserError, KeyError => e
    { error: "cannot read #{path}: #{e.message}" }
  end

  # "./spec/plurimath/math/symbols/alpha_spec.rb" -> "plurimath/math/symbols";
  # "./spec/plurimath/latex_spec.rb" -> "plurimath/latex".
  def area_for(file_path)
    rel = file_path.delete_prefix("./").delete_prefix("spec/").delete_suffix("_spec.rb")
    parts = rel.split("/")
    return rel if parts.size <= 2

    parts[0, [parts.size - 1, 3].min].join("/")
  end

  # ---- shared -----------------------------------------------------------

  def runner_image
    image = [ENV.fetch("ImageOS", nil), ENV.fetch("ImageVersion", nil)].compact.join(" ")
    image.empty? ? nil : image
  end

  def median(values)
    return nil if values.empty?

    sorted = values.sort
    mid = sorted.size / 2
    sorted.size.odd? ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2.0
  end

  def deep_sort(value)
    case value
    when Hash then value.transform_keys(&:to_s).sort.to_h.transform_values { |v| deep_sort(v) }
    when Array then value.map { |v| deep_sort(v) }
    else value
    end
  end

  def write(report, output)
    json = "#{JSON.pretty_generate(deep_sort(report))}\n"
    output ? File.write(output, json) : $stdout.write(json)
  end

  def summary_markdown(title, header, rows)
    path = ENV.fetch("GITHUB_STEP_SUMMARY", nil)
    return unless path

    File.open(path, "a") do |f|
      f.puts "### #{title}", ""
      f.puts "| #{header.join(' | ')} |", "|#{' --- |' * header.size}"
      rows.each { |row| f.puts "| #{row.join(' | ')} |" }
      f.puts
    end
  end
end

exit CheckSuiteBudget.call(ARGV) if $PROGRAM_NAME == __FILE__
