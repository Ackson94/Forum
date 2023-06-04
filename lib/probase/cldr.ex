defmodule Probase.Cldr do
  use Cldr,
    locales: ["en", "fr", "zh", "th", "ja"],
    default_locale: "en",
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
