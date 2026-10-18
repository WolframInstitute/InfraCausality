Package[ "WolframInstitute`InfraCausality`" ]

(* WolframInstitute`InfraCausality` :: CausalSubstrates :: CausalStyle *)

PackageScope[ $causalColors ]

$causalColors = <|
  "Event" -> Hue[ 0.11, 1, 0.97 ],
  "Edge" -> Hue[ 0, 1, 0.56 ],
  "Light" -> Red,
  "Future" -> Lighter[ Red, 0.6 ],
  "PastLight" -> RGBColor[ 0.259, 0.576, 1 ],
  "Past" -> Lighter[ RGBColor[ 0.259, 0.576, 1 ], 0.6 ],
  "Slice" -> Red,
  "Earlier" -> Lighter[ RGBColor[ 0.259, 0.576, 1 ], 0.5 ],
  "Worldline" -> StandardBlue,
  "Observer" -> StandardGreen,
  "Image" -> StandardPurple,
  "Marker" -> StandardMagenta,
  "Bondi" -> <|
    "Alice" -> StandardBlue,
    "Bob" -> StandardRed,
    "Carol" -> StandardGreen,
    "Light" -> StandardYellow,
    "LightFaded" -> Lighter[ StandardYellow, 0.5 ],
    "Event" -> StandardMagenta,
    "Simultaneity" -> StandardOrange,
    "SimAlice" -> Lighter[ StandardBlue, 0.3 ],
    "SimBob" -> Lighter[ StandardRed, 0.3 ],
    "Tick" -> Darker[ StandardGray, 0.3 ],
    "Label" -> Darker[ StandardGray, 0.6 ],
    "Background" -> Lighter[ StandardGray, 0.95 ] |> |>
