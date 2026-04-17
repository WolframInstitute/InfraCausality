Package["WolframInstitute`InfraCausality`"]

(* ========================= Algebraic Primitives ========================= *)

KFactor::usage =
  "KFactor[v] returns the Bondi k-factor Sqrt[(1+v)/(1-v)]. \
KFactor[v, phi] returns the angular form Sqrt[Sin[phi+alpha]/Sin[phi-alpha]] \
with alpha = ArcTan[v Tan[phi]], which is independent of phi.";

KFactor[ velocity_ ] :=
  Sqrt[ (1 + velocity) / (1 - velocity) ]

KFactor[ velocity_, lightAngle_ ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sqrt[ Sin[ lightAngle + alpha ] / Sin[ lightAngle - alpha ] ]
  ]


VelocityFromK::usage = "VelocityFromK[k] returns (k^2 - 1)/(k^2 + 1).";
VelocityFromK[ k_ ] :=
  (k^2 - 1) / (k^2 + 1)


WorldlineAngle::usage =
  "WorldlineAngle[v, phi] returns the Euclidean angle ArcTan[v Tan[phi]] \
that Bob's worldline makes with Alice's.";

WorldlineAngle[ velocity_, lightAngle_ : Pi/4 ] :=
  ArcTan[ velocity Tan[ lightAngle ] ]


Rapidity::usage     = "Rapidity[v] returns ArcTanh[v].";
Rapidity[ velocity_ ] := ArcTanh[ velocity ]

RapidityFromK::usage = "RapidityFromK[k] returns Log[k].";
RapidityFromK[ k_ ] := Log[ k ]

LorentzGamma::usage = "LorentzGamma[v] returns (k + 1/k)/2 with k = KFactor[v].";
LorentzGamma[ velocity_ ] :=
  With[ { k = KFactor[ velocity ] }, (k + 1/k) / 2 ]


OutgoingRatio::usage =
  "OutgoingRatio[v, phi] returns Sin[phi]/Sin[phi - alpha], the arc-length \
ratio from Alice's emission to Bob's reception.";
OutgoingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle ] / Sin[ lightAngle - alpha ]
  ]

IncomingRatio::usage =
  "IncomingRatio[v, phi] returns Sin[phi + alpha]/Sin[phi], the arc-length \
ratio from Bob's emission to Alice's reception.";
IncomingRatio[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    Sin[ lightAngle + alpha ] / Sin[ lightAngle ]
  ]


(* ========================= Worldline Geometry ========================= *)

WorldlineDirection::usage = "WorldlineDirection[v, phi] returns {Sin[alpha], Cos[alpha]}.";
WorldlineDirection[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Sin[ alpha ], Cos[ alpha ] }
  ]

WorldlinePoint::usage =
  "WorldlinePoint[v, s, phi] returns the point on Bob's worldline at \
Euclidean arc-length s from the origin.";
WorldlinePoint[ velocity_, arcLength_, lightAngle_ : Pi/4 ] :=
  arcLength WorldlineDirection[ velocity, lightAngle ]

WorldlineNormal::usage =
  "WorldlineNormal[v, phi] returns the in-plane normal {Cos[alpha], -Sin[alpha]} \
to Bob's worldline.";
WorldlineNormal[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Cos[ alpha ], -Sin[ alpha ] }
  ]

ProperTimeScale::usage =
  "ProperTimeScale[v, phi] returns k/kOut, the ratio of proper time to \
Euclidean arc-length on Bob's worldline.";
ProperTimeScale[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { k = KFactor[ velocity, lightAngle ],
           kOut = OutgoingRatio[ velocity, lightAngle ] },
    k / kOut
  ]

WorldlinePointAtProperTime::usage =
  "WorldlinePointAtProperTime[v, tau, phi] returns the point on Bob's \
worldline at proper time tau.";
WorldlinePointAtProperTime[ velocity_, properTime_, lightAngle_ : Pi/4 ] :=
  WorldlinePoint[ velocity, properTime / ProperTimeScale[ velocity, lightAngle ], lightAngle ]


(* ========================= Light Ray Geometry ========================= *)

LightDirection::usage =
  "LightDirection[phi, rightgoing] returns the unit vector of a light ray \
at angle phi to the vertical; rightgoing True points into the +x half-plane.";
LightDirection[ lightAngle_, rightgoing_ : True ] :=
  If[ rightgoing,
    { Sin[ lightAngle ], Cos[ lightAngle ] },
    { -Sin[ lightAngle ], Cos[ lightAngle ] }
  ]

LightZigzag::usage =
  "LightZigzag[v, s0, n, phi] returns a list of n+1 reflection events of a \
light signal bouncing between Alice (at rest) and Bob (velocity v), starting \
from Alice at arc-length s0. Each event is an Association with keys \
\"Observer\", \"ArcLength\", \"Point\".";

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


(* ========================= Radar Coordinates ========================= *)

RadarCoordinatesFromAlice::usage =
  "RadarCoordinatesFromAlice[event, phi] returns Alice's radar coordinates \
for a point event = {x, y}: an Association with keys \"RadarTime\", \
\"RadarDistance\", \"EmitArcLength\", \"ReturnArcLength\".";

RadarCoordinatesFromAlice[ event_List, lightAngle_ : Pi/4 ] :=
  Module[ { emitY, returnY },
    emitY = event[[ 2 ]] - event[[ 1 ]] / Tan[ lightAngle ];
    returnY = event[[ 2 ]] + event[[ 1 ]] / Tan[ lightAngle ];
    <| "RadarTime" -> (emitY + returnY) / 2,
       "RadarDistance" -> (returnY - emitY) / 2,
       "EmitArcLength" -> emitY,
       "ReturnArcLength" -> returnY |>
  ]


SimultaneityLine::usage =
  "SimultaneityLine[v, s, phi, extent] returns three points describing the \
simultaneity line of Bob's worldline at arc-length s: {leftLightEnd, basePoint, rightLightEnd}.";

SimultaneityLine[ velocity_, radarArcLength_, lightAngle_ : Pi/4, extent_ : 1 ] :=
  With[ { dir = WorldlineDirection[ velocity, lightAngle ],
           lightOut = LightDirection[ lightAngle, True ],
           lightIn = LightDirection[ lightAngle, False ] },
    With[ { basePoint = radarArcLength dir },
      { basePoint + extent lightIn, basePoint, basePoint + extent lightOut }
    ]
  ]
