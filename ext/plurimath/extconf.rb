# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

ENV["RC_ARCHS"] = "" if RUBY_PLATFORM.match?(/darwin|mac os/)

require "mkmf"
require "rbconfig"

OS = case RbConfig::CONFIG["host_os"]
when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  :windows
when /darwin|mac os/
  :macos
when /linux/
  :linux
when /solaris|bsd/
  :unix
else
  raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
end

LIBDIR     = RbConfig::CONFIG["libdir"]
INCLUDEDIR = RbConfig::CONFIG["includedir"]
SHARED_EXT = OS == :macos ? "dylib" : "so"
# Starting in Catalina, libxml2 was moved elsewhere
SDKROOT = OS == :macos ? %x(/usr/bin/xcrun --show-sdk-path).chomp : ""
RPATH = OS == :macos ? "-rpath @loader_path/../../ext/plurimath/lib".chomp : ""

unless find_executable("cmake")
  $stderr.puts "\n\n\n[ERROR]: cmake is required and not installed. Get it here: http://www.cmake.org/\n\n"
  exit 1
end

LASEM_DIR = File.expand_path(File.join(File.dirname(__FILE__), "lasem"))
LASEM_BUILD_DIR = File.join(LASEM_DIR, "build")
LASEM_SRC_DIR = File.expand_path(File.join(LASEM_DIR, "src"))
LASEM_LIB_DIR = File.expand_path(File.join(File.dirname(__FILE__), "lib"))

if OS == :macos
  ENV["PKG_CONFIG_PATH"] = "/opt/X11/lib/pkgconfig:#{ENV["PKG_CONFIG_PATH"]}"
end

# pre-compile checks
have_library("xml2")
have_library("pangocairo-1.0")
find_header("libxml/tree.h", "/include/libxml2", "/usr/include/libxml2", "/usr/local/include/libxml2", "#{SDKROOT}/usr/include/libxml2")
find_header("libxml/parser.h", "/include/libxml2", "/usr/include/libxml2", "/usr/local/include/libxml2", "#{SDKROOT}/usr/include/libxml2")
find_header("libxml/xpath.h", "/include/libxml2", "/usr/include/libxml2", "/usr/local/include/libxml2", "#{SDKROOT}/usr/include/libxml2")
find_header("libxml/xpathInternals.h", "/include/libxml2", "/usr/include/libxml2", "/usr/local/include/libxml2", "#{SDKROOT}/usr/include/libxml2")

def clean_dir(dir)
  if File.directory?(dir)
    FileUtils.rm_rf(dir)
  end
  FileUtils.mkdir_p(dir)
end

clean_dir(LASEM_BUILD_DIR)

# build Lasem library
# SHOULD BE DYNAMICALLY LINKED for potential LGPL copyright issues
Dir.chdir(LASEM_BUILD_DIR) do
  system "cmake ../.."
  system "make"
end
FileUtils.mkdir_p(LASEM_LIB_DIR)
FileUtils.cp_r(File.join(LASEM_BUILD_DIR, "liblasem.#{SHARED_EXT}"), LASEM_LIB_DIR)
$LIBS << if OS == :linux
  " -Wl,-rpath,#{LASEM_LIB_DIR} -llasem"
else
  " -llasem"
end

puts "*** Library work completed ***"

LIB_DIRS = [LASEM_LIB_DIR]
HEADER_DIRS = [LASEM_SRC_DIR]

dir_config("plurimath", HEADER_DIRS, LIB_DIRS)

flag = ENV["TRAVIS"] ? "-O0" : "-O2"
$LDFLAGS << " #{%x(pkg-config --static --libs glib-2.0 gdk-pixbuf-2.0 cairo pango).chomp} #{RPATH}"
$CFLAGS << " #{flag} #{%x(pkg-config --cflags glib-2.0 gdk-pixbuf-2.0 cairo pango).chomp}"

create_makefile("render/render")

# rubocop:enable Style/GlobalVars