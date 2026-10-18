BeginTestSection[ "BondiKCalculus" ]

$velocity = 0 < v < 1

$angles = 0 < v < 1 && 0 < phi < Pi/2

VerificationTest[
  Simplify[ TrigExpand[ KFactor[ v, phi ]^2 ] == KFactor[ v ]^2, $angles ],
  True,
  TestID -> "KFactor-Symbolic-angular-radicand-independent-of-light-angle"
]

VerificationTest[
  Table[ KFactor[ v, phi ] - KFactor[ v ], { v, { 1/5, 3/5 } }, { phi, { Pi/6, Pi/4, Pi/3 } } ] // FullSimplify,
  ConstantArray[ 0, { 2, 3 } ],
  TestID -> "KFactor-Exact-angular-form-equals-KFactor"
]

VerificationTest[
  FullSimplify[ OutgoingRatio[ v ] IncomingRatio[ v ] == KFactor[ v ]^2, $velocity ],
  True,
  TestID -> "OutgoingRatio-Symbolic-product-with-incoming-is-k-squared"
]

VerificationTest[
  Simplify[ TrigExpand[ OutgoingRatio[ v, phi ] IncomingRatio[ v, phi ] ] == KFactor[ v ]^2, $angles ],
  True,
  TestID -> "IncomingRatio-Symbolic-product-is-k-squared-at-every-light-angle"
]

VerificationTest[
  FullSimplify[ LorentzGamma[ v ] == 1 / Sqrt[ 1 - v^2 ], $velocity ],
  True,
  TestID -> "LorentzGamma-Symbolic-equals-inverse-root"
]

VerificationTest[
  FullSimplify[ ( KFactor[ v ]^2 - 1 ) / ( KFactor[ v ]^2 + 1 ) == v && KFactor[ ( k^2 - 1 ) / ( k^2 + 1 ) ] == k, $velocity && k > 0 ],
  True,
  TestID -> "KFactor-Symbolic-inverts-the-velocity-of-k"
]

VerificationTest[
  FullSimplify[ Log @ KFactor @ v == Rapidity[ v ], $velocity ],
  True,
  TestID -> "KFactor-Symbolic-log-k-is-rapidity"
]

VerificationTest[
  FullSimplify[ KFactor[ v1 ] KFactor[ v2 ] == KFactor[ ( v1 + v2 ) / ( 1 + v1 v2 ) ], 0 < v1 < 1 && 0 < v2 < 1 ],
  True,
  TestID -> "KFactor-Symbolic-velocity-addition-multiplies-k"
]

VerificationTest[
  FullSimplify[ Tan @ WorldlineAngle[ v, phi ] == v Tan[ phi ], $angles ] && WorldlineAngle[ v ] == ArcTan[ v ],
  True,
  TestID -> "WorldlineAngle-Symbolic-tangent-scales-by-velocity"
]

VerificationTest[
  Table[ BondiRadarCoordinates[ { 0, y }, phi ][ "RadarDistance" ], { y, { 0, 1, 7/2 } }, { phi, { Pi/6, Pi/4, Pi/3 } } ],
  ConstantArray[ 0, { 3, 3 } ],
  TestID -> "BondiRadarCoordinates-Rest-worldline-at-distance-zero"
]

VerificationTest[
  Table[ BondiRadarCoordinates[ { 0, y }, phi ][ "RadarTime" ] == y, { y, { 0, 1, 7/2 } }, { phi, { Pi/6, Pi/4, Pi/3 } } ],
  ConstantArray[ True, { 3, 3 } ],
  TestID -> "BondiRadarCoordinates-Rest-worldline-radar-time-is-arc-length"
]

VerificationTest[
  FullSimplify[ With[ { r = BondiRadarCoordinates[ s { Sin @ WorldlineAngle[ v, phi ], Cos @ WorldlineAngle[ v, phi ] }, phi ] },
    r[ "RadarDistance" ] == v r[ "RadarTime" ] ], $angles && s > 0 ],
  True,
  TestID -> "BondiRadarCoordinates-Symbolic-moving-worldline-has-radar-velocity-v"
]

VerificationTest[
  With[ { r = BondiRadarCoordinates[ { x, y }, phi ] },
    FullSimplify[ { r[ "EmitArcLength" ] + r[ "ReturnArcLength" ] == 2 r[ "RadarTime" ],
      r[ "ReturnArcLength" ] - r[ "EmitArcLength" ] == 2 r[ "RadarDistance" ],
      r[ "RadarDistance" ] == x Cot[ phi ] } ] ],
  { True, True, True },
  TestID -> "BondiRadarCoordinates-Symbolic-time-and-distance-from-emission-and-return"
]

VerificationTest[
  Table[
    With[ { arcs = #[ "ArcLength" ] & /@ Select[ LightZigzag[ v, 1, 8, phi ], #[ "Observer" ] === "Alice" & ] },
      FullSimplify[ Ratios @ arcs - KFactor[ v ]^2 ] ],
    { v, { 1/5, 3/5, 4/5 } }, { phi, { Pi/6, Pi/4, Pi/3 } } ],
  ConstantArray[ 0, { 3, 3, 4 } ],
  TestID -> "LightZigzag-Exact-emission-arc-lengths-grow-by-k-squared"
]

VerificationTest[
  With[ { events = LightZigzag[ 3/5, 2, 6, Pi/3 ] },
    FullSimplify @ Table[
      With[ { r = BondiRadarCoordinates[ events[[ i ]][ "Point" ], Pi/3 ] },
        { r[ "EmitArcLength" ] - events[[ i - 1 ]][ "ArcLength" ], r[ "ReturnArcLength" ] - events[[ i + 1 ]][ "ArcLength" ] } ],
      { i, { 2, 4, 6 } } ] ],
  ConstantArray[ 0, { 3, 2 } ],
  TestID -> "LightZigzag-Exact-reflections-on-moving-worldline-are-radar-events-of-the-zigzag"
]

VerificationTest[
  With[ { events = LightZigzag[ 3/5, 1, 5 ] },
    { #[ "Observer" ] & /@ events, FullSimplify[ ( #[ "Point" ] . #[ "Point" ] - #[ "ArcLength" ]^2 ) & /@ events ] } ],
  { { "Alice", "Bob", "Alice", "Bob", "Alice", "Bob" }, ConstantArray[ 0, 6 ] },
  TestID -> "LightZigzag-Exact-alternates-observers-at-their-arc-lengths"
]

$radarInterval = { v, phi, s } |->
  With[ { r = BondiRadarCoordinates[ s Through[ { Sin, Cos }[ WorldlineAngle[ v, phi ] ] ], phi ] },
    r[ "RadarTime" ]^2 - r[ "RadarDistance" ]^2 ]

VerificationTest[
  {
    FullSimplify[ Sqrt[ $radarInterval[ 3/5, Pi/3, s ] ] == ProperTimeScale[ 3/5, Pi/3 ] s, s > 0 ],
    Simplify[ TrigExpand[ $radarInterval[ v, phi, s ] == ProperTimeScale[ v, phi ]^2 s^2 ], $angles ]
  },
  { True, True },
  TestID -> "ProperTimeScale-Symbolic-radar-proper-time-is-scale-times-arc-length"
]

VerificationTest[
  FullSimplify[ ProperTimeScale[ 0, phi ] == 1, 0 < phi < Pi/2 ],
  True,
  TestID -> "ProperTimeScale-Symbolic-rest-worldline-arc-length-is-proper-time"
]

VerificationTest[
  FullSimplify[ TrigExpand[ ProperTimeScale[ v, Pi/4 ] ] == Sqrt[ ( 1 - v^2 ) / ( 1 + v^2 ) ], $velocity ],
  True,
  TestID -> "ProperTimeScale-Symbolic-light-at-forty-five-degrees"
]

EndTestSection[]
