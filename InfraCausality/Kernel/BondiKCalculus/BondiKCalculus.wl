Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: BondiKCalculus :: BondiKCalculus *)

KFactor[ velocity_ ] :=
  Sqrt[ ( 1 + velocity ) / ( 1 - velocity ) ]

KFactor[ velocity_, lightAngle_ ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sqrt[ Sin[ lightAngle + alpha ] / Sin[ lightAngle - alpha ] ]
  ]

WorldlineAngle[ velocity_, lightAngle_ : Pi/4 ] :=
  ArcTan[ velocity Tan[ lightAngle ] ]

Rapidity[ velocity_ ] :=
  ArcTanh[ velocity ]

LorentzGamma[ velocity_ ] :=
  With[ { k = KFactor[ velocity ] },
    ( k + 1/k ) / 2
  ]

OutgoingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle ] / Sin[ lightAngle - alpha ]
  ]

IncomingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle + alpha ] / Sin[ lightAngle ]
  ]

ProperTimeScale[ velocity_, lightAngle_ : Pi/4 ] :=
  KFactor[ velocity, lightAngle ] / OutgoingRatio[ velocity, lightAngle ]

LightZigzag[ velocity_, emitArcLength_, nBounces_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ],
          kOut = OutgoingRatio[ velocity, lightAngle ],
          kIn = IncomingRatio[ velocity, lightAngle ] },
    NestList[
      event |-> If[ event[ "Observer" ] === "Alice",
        With[ { arc = event[ "ArcLength" ] kOut },
          <| "Observer" -> "Bob", "ArcLength" -> arc, "Point" -> arc { Sin[ alpha ], Cos[ alpha ] } |> ],
        With[ { arc = event[ "ArcLength" ] kIn },
          <| "Observer" -> "Alice", "ArcLength" -> arc, "Point" -> { 0, arc } |> ] ],
      <| "Observer" -> "Alice", "ArcLength" -> emitArcLength, "Point" -> { 0, emitArcLength } |>,
      nBounces
    ]
  ]

BondiRadarCoordinates[ { x_, y_ }, lightAngle_ : Pi/4 ] :=
  With[ { emit = y - x / Tan[ lightAngle ],
          receive = y + x / Tan[ lightAngle ] },
    <|
      "RadarTime" -> ( emit + receive ) / 2,
      "RadarDistance" -> ( receive - emit ) / 2,
      "EmitArcLength" -> emit,
      "ReturnArcLength" -> receive
    |>
  ]
