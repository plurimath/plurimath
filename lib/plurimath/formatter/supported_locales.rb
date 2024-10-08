# frozen_string_literal: true

module Plurimath
  module Formatter
    class SupportedLocales
      LOCALES = {
        "sr-Cyrl-ME": { decimal: ",", group: "." },
        "sr-Latn-ME": { decimal: ",", group: "." },
        "zh-Hant": { decimal: ".", group: "," },
        "en-001": { decimal: ".", group: "," },
        "en-150": { decimal: ".", group: "," },
        "pt-PT": { decimal: ",", group: " " },
        "nl-BE": { decimal: ",", group: "." },
        "it-CH": { decimal: ".", group: "’" },
        "fr-BE": { decimal: ",", group: " " },
        "fr-CA": { decimal: ",", group: " " },
        "fr-CH": { decimal: ",", group: " " },
        "de-AT": { decimal: ",", group: " " },
        "de-CH": { decimal: ".", group: "’" },
        "en-AU": { decimal: ".", group: "," },
        "en-CA": { decimal: ".", group: "," },
        "en-GB": { decimal: ".", group: "," },
        "en-IE": { decimal: ".", group: "," },
        "en-IN": { decimal: ".", group: "," },
        "en-NZ": { decimal: ".", group: "," },
        "en-SG": { decimal: ".", group: "," },
        "en-US": { decimal: ".", group: "," },
        "en-ZA": { decimal: ".", group: "," },
        "es-419": { decimal: ".", group: "," },
        "es-AR": { decimal: ",", group: "." },
        "es-CO": { decimal: ",", group: "." },
        "es-MX": { decimal: ".", group: "," },
        "es-US": { decimal: ".", group: "," },
        fil: { decimal: ".", group: "," },
        af: { decimal: ",", group: " " },
        ar: { decimal: "٫", group: "٬" },
        az: { decimal: ",", group: "." },
        be: { decimal: ",", group: " " },
        bg: { decimal: ",", group: " " },
        bn: { decimal: ".", group: "," },
        bo: { decimal: ".", group: "," },
        bs: { decimal: ",", group: "." },
        ca: { decimal: ",", group: "." },
        cs: { decimal: ",", group: " " },
        cy: { decimal: ".", group: "," },
        da: { decimal: ",", group: "." },
        de: { decimal: ",", group: "." },
        el: { decimal: ",", group: "." },
        en: { decimal: ".", group: "," },
        eo: { decimal: ",", group: " " },
        es: { decimal: ",", group: "." },
        et: { decimal: ",", group: " " },
        eu: { decimal: ",", group: "." },
        fa: { decimal: "٫", group: "٬" },
        fi: { decimal: ",", group: " " },
        fr: { decimal: ",", group: " " },
        ga: { decimal: ".", group: "," },
        gl: { decimal: ",", group: "." },
        gu: { decimal: ".", group: "," },
        he: { decimal: ".", group: "," },
        hi: { decimal: ".", group: "," },
        hr: { decimal: ",", group: "." },
        hu: { decimal: ",", group: " " },
        hy: { decimal: ",", group: " " },
        id: { decimal: ",", group: "." },
        is: { decimal: ",", group: "." },
        it: { decimal: ",", group: "." },
        ja: { decimal: ".", group: "," },
        ka: { decimal: ",", group: " " },
        kk: { decimal: ",", group: " " },
        km: { decimal: ",", group: "." },
        kn: { decimal: ".", group: "," },
        ko: { decimal: ".", group: "," },
        lo: { decimal: ",", group: "." },
        lt: { decimal: ",", group: " " },
        lv: { decimal: ",", group: " " },
        mk: { decimal: ",", group: "." },
        mr: { decimal: ".", group: "," },
        ms: { decimal: ".", group: "," },
        mt: { decimal: ".", group: "," },
        my: { decimal: ".", group: "," },
        nb: { decimal: ",", group: " " },
        nl: { decimal: ",", group: "." },
        pl: { decimal: ",", group: " " },
        pt: { decimal: ",", group: "." },
        ro: { decimal: ",", group: "." },
        ru: { decimal: ",", group: " " },
        sk: { decimal: ",", group: " " },
        sl: { decimal: ",", group: "." },
        sq: { decimal: ",", group: " " },
        sr: { decimal: ",", group: "." },
        sv: { decimal: ",", group: " " },
        sw: { decimal: ".", group: "," },
        ta: { decimal: ".", group: "," },
        th: { decimal: ".", group: "," },
        tr: { decimal: ",", group: "." },
        uk: { decimal: ",", group: " " },
        ur: { decimal: ".", group: "," },
        vi: { decimal: ",", group: "." },
        xh: { decimal: ".", group: " " },
        zh: { decimal: ".", group: "," },
        zu: { decimal: ".", group: "," },
      }
    end
  end
end
