Package["WolframInstitute`InfraCausality`"]

BondiExplorer::usage =
  "BondiExplorer[] returns an interactive Manipulate with sliders for \
velocity, light angle, and bounces, selecting among seven Bondi \
constructions (Clock, Doppler, Time Dilation, Simultaneity, Length \
Contraction, Velocity Addition, Light Clock).";

BondiExplorer[] :=
  Manipulate[
    Switch[ construction,
      "Clock",
        BondiClock[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Doppler",
        DopplerConstruction[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Time Dilation",
        TimeDilationConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Simultaneity",
        SimultaneityConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Length Contraction",
        LengthContractionConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Velocity Addition",
        VelocityAdditionConstruction[ velocity, v2, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Light Clock",
        LightClockConstruction[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ]
    ],
    { { construction, "Clock", "Construction" },
      { "Clock", "Doppler", "Time Dilation", "Simultaneity",
        "Length Contraction", "Velocity Addition", "Light Clock" } },
    Delimiter,
    { { velocity, 0.4, "\[Beta]" }, 0.05, 0.9 },
    { { lightAngle, Pi/4, "\[Phi] (light angle)" }, 0.15, Pi/2 - 0.05 },
    { { bounces, 8, "Bounces / Pulses" }, 3, 15, 1 },
    Delimiter,
    { { v2, 0.3, Subscript[ "\[Beta]", "2" ] }, 0.05, 0.85 },
    ControlType -> { SetterBar, Delimiter, Slider, Slider, Slider, Delimiter, Slider },
    TrackedSymbols :> { construction, velocity, lightAngle, bounces, v2 }
  ]
