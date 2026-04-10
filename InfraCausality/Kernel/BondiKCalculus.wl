(* === Algebraic Primitives === *)

KFactor[ velocity_ ] :=
  Sqrt[ (1 + velocity) / (1 - velocity) ]

KFactor[ velocity_, lightAngle_ ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sqrt[ Sin[ lightAngle + alpha ] / Sin[ lightAngle - alpha ] ]
  ]

VelocityFromK[ k_ ] :=
  (k^2 - 1) / (k^2 + 1)

WorldlineAngle[ velocity_, lightAngle_ : Pi/4 ] :=
  ArcTan[ velocity Tan[ lightAngle ] ]

Rapidity[ velocity_ ] :=
  ArcTanh[ velocity ]

RapidityFromK[ k_ ] :=
  Log[ k ]

LorentzGamma[ velocity_ ] :=
  With[ { k = KFactor[ velocity ] }, (k + 1/k) / 2 ]

OutgoingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle ] / Sin[ lightAngle - alpha ]
  ]

IncomingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle + alpha ] / Sin[ lightAngle ]
  ]


(* === Worldline Geometry === *)

WorldlineDirection[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Sin[ alpha ], Cos[ alpha ] }
  ]

WorldlinePoint[ velocity_, arcLength_, lightAngle_ : Pi/4 ] :=
  arcLength WorldlineDirection[ velocity, lightAngle ]

WorldlineNormal[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Cos[ alpha ], -Sin[ alpha ] }
  ]

ProperTimeScale[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { k = KFactor[ velocity, lightAngle ],
           kOut = OutgoingRatio[ velocity, lightAngle ] },
    k / kOut
  ]

WorldlinePointAtProperTime[ velocity_, properTime_, lightAngle_ : Pi/4 ] :=
  WorldlinePoint[ velocity, properTime / ProperTimeScale[ velocity, lightAngle ], lightAngle ]


(* === Light Ray Geometry === *)

LightDirection[ lightAngle_, rightgoing_ : True ] :=
  If[ rightgoing,
    { Sin[ lightAngle ], Cos[ lightAngle ] },
    { -Sin[ lightAngle ], Cos[ lightAngle ] }
  ]

LightZigzag[ velocity_, emitArcLength_, nBounces_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ],
           kOut = OutgoingRatio[ velocity, lightAngle ],
           kIn = IncomingRatio[ velocity, lightAngle ] },
    NestList[
      If[ #Observer === "Alice",
        With[ { newArc = #ArcLength kOut },
          <| "Observer" -> "Bob", "ArcLength" -> newArc,
             "Point" -> newArc { Sin[ alpha ], Cos[ alpha ] } |>
        ],
        With[ { newArc = #ArcLength kIn },
          <| "Observer" -> "Alice", "ArcLength" -> newArc,
             "Point" -> { 0, newArc } |>
        ]
      ] &,
      <| "Observer" -> "Alice", "ArcLength" -> emitArcLength,
         "Point" -> { 0, emitArcLength } |>,
      nBounces
    ]
  ]


(* === Radar Coordinates === *)

RadarCoordinatesFromAlice[ event_List, lightAngle_ : Pi/4 ] :=
  Module[ { emitY, returnY },
    emitY = event[[ 2 ]] - event[[ 1 ]] / Tan[ lightAngle ];
    returnY = event[[ 2 ]] + event[[ 1 ]] / Tan[ lightAngle ];
    <| "RadarTime" -> (emitY + returnY) / 2,
       "RadarDistance" -> (returnY - emitY) / 2,
       "EmitArcLength" -> emitY,
       "ReturnArcLength" -> returnY |>
  ]

SimultaneityLine[ velocity_, radarArcLength_, lightAngle_ : Pi/4, extent_ : 1 ] :=
  With[ { dir = WorldlineDirection[ velocity, lightAngle ],
           lightOut = LightDirection[ lightAngle, True ],
           lightIn = LightDirection[ lightAngle, False ] },
    With[ { basePoint = radarArcLength dir },
      { basePoint + extent lightIn, basePoint, basePoint + extent lightOut }
    ]
  ]
