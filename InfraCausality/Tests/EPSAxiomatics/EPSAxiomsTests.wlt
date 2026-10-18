BeginTestSection["EPSAxioms"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$two = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$lattice = n |-> Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= n & ],
  { i, 0, n }, { j, 0, n } ] ];

$g = $lattice[ 9 ];

$diamond = $lattice[ 3 ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$diagonal = Table[ { m, m }, { m, 0, 9 } ];

$parallel = Table[ { m, m + 2 }, { m, 0, 7 } ];

$staircase = Append[ Catenate @ Table[ { { i, i }, { i + 1, i } }, { i, 0, 8 } ], { 9, 9 } ];

$staircaseShifted = Select[ ( # + { 0, 2 } ) & /@ $staircase, Max @ # <= 9 & ];

$moving = p |-> Table[ { ( p + 1 ) m, p m }, { m, 1, Floor[ 9 / ( p + 1 ) ] } ];

$pairs = Join[
  { { $diagonal, $parallel }, { $parallel, $diagonal }, { $staircase, $staircaseShifted }, { $staircaseShifted, $staircase }, { Take[ $diagonal, -5 ], Take[ $diagonal, 5 ] } },
  Table[ { $diagonal, $moving @ p }, { p, 3 } ], Table[ { $moving @ p, $diagonal }, { p, 3 } ] ];

$heads = Catenate[ Apply[ { a, b } |-> { InfraMessageFunction[ a, b ], InfraEchoFunction[ a, b ] } ] /@ $pairs ];

$defects = { "DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect" };

$diagonal4 = Table[ { m, m }, { m, 0, 3 } ];

$stair = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }, { 2, 2 }, { 3, 2 }, { 3, 3 } };

$shifted = Table[ { m, m + 1 }, { m, 0, 2 } ];

$column = Table[ { 0, t }, { t, 0, 3 } ];

$spiral = { { 0, 0 }, { 1, 1 }, { 2, 2 }, { 0, 3 } };

$charts = {
  { $two, InfraRadarCoordinates[ { 1, 3, 5 } ] },
  { $two, InfraRadarCoordinates[ { 1, 3, 4, 5 } ] },
  { $diamond, InfraRadarCoordinates[ $diagonal4 ] },
  { $diamond, InfraRadarCoordinates[ $stair ] },
  { $diamond, InfraRadarCoordinates[ $column ] },
  { $diamond, InfraRadarCoordinates[ { $diagonal4, $shifted } ] },
  { $cylinder, InfraRadarCoordinates[ $column ] },
  { $cylinder, InfraRadarCoordinates[ $spiral ] } };

VerificationTest[
  EPSMessageAxiomQ[ $g, #, "Margin" -> 2 ] & /@
    { InfraMessageFunction[ $diagonal, $parallel ], InfraMessageFunction[ $parallel, $diagonal ], InfraEchoFunction[ $diagonal, $parallel ], InfraEchoFunction[ $parallel, $diagonal ] },
  { True, True, True, True },
  TestID -> "EPSMessageAxiomQ-diagonal-chains-satisfy-D1-on-the-interior-window"
]

VerificationTest[
  EPSMessageAxiomQ[ $g, # ] & /@
    { InfraMessageFunction[ $diagonal, $parallel ], InfraMessageFunction[ $parallel, $diagonal ], InfraEchoFunction[ $diagonal, $parallel ], InfraEchoFunction[ $parallel, $diagonal ] },
  { False, True, False, False },
  TestID -> "EPSMessageAxiomQ-diagonal-chains-fail-without-margin-where-the-end-ticks-have-no-image"
]

VerificationTest[
  { EPSMessageAxiomQ[ $g, InfraMessageFunction[ $staircase, $staircaseShifted ], "Margin" -> 4 ],
    EPSMessageAxiomQ[ $g, InfraEchoFunction[ $staircase, $staircaseShifted ], "Margin" -> 4 ],
    InfraMeasurement[ $g, InfraMessageFunction[ $staircase, $staircaseShifted ], "FunctionDefect", "Margin" -> 4 ] },
  { False, False, 1 / 2 },
  TestID -> "EPSMessageAxiomQ-staircases-with-two-images-per-tick-fail-D1"
]

VerificationTest[
  EPSMessageAxiomQ[ $g, # ] & /@ { InfraMessageFunction[ Take[ $diagonal, -5 ], Take[ $diagonal, 5 ] ], InfraEchoFunction[ Take[ $diagonal, -5 ], Take[ $diagonal, 5 ] ] },
  { False, False },
  TestID -> "EPSMessageAxiomQ-chain-against-a-chain-in-its-past-fails-D1"
]

VerificationTest[
  AllTrue[ $heads, head |-> With[ { a = First @ head },
    AllTrue[ Select[ Range[ 0, 4 ], k |-> 2 k < Length @ a ], k |->
      EPSMessageAxiomQ[ $g, head, "Margin" -> k ] === AllTrue[ $defects, d |-> InfraMeasurement[ $g, head, d, "Margin" -> k ] == 0 ] ] ] ],
  True,
  TestID -> "EPSMessageAxiomQ-equals-the-vanishing-of-the-four-defects-on-every-fixture-and-margin"
]

VerificationTest[
  AllTrue[ $pairs, Apply[ { a, b } |->
    EPSMessageAxiomQ[ $g, InfraMessageFunction[ a, b ], "Margin" -> 1 ] === EPSMessageAxiomQ[ $g, InfraMessageFunction[ a[[ 2 ;; -2 ]], b ] ] ] ],
  True,
  TestID -> "EPSMessageAxiomQ-margin-is-the-axiom-on-the-shortened-first-observer"
]

VerificationTest[
  Table[
    { EPSMessageAxiomQ[ $g, InfraMessageFunction[ $moving @ p, $diagonal ] ],
      EPSMessageAxiomQ[ $g, InfraMessageFunction[ $diagonal, $moving @ p ], "Margin" -> 1 ],
      EPSMessageAxiomQ[ $g, InfraEchoFunction[ $moving @ p, $diagonal ] ] },
    { p, 2 } ],
  { { True, False, False }, { True, False, False } },
  TestID -> "EPSMessageAxiomQ-moving-chain-signals-the-resting-chain-tick-for-tick-but-not-conversely"
]

VerificationTest[
  EPSRadarAxiomQ[ $diamond, InfraRadarCoordinates[ $diagonal4 ] ],
  False,
  TestID -> "EPSRadarAxiomQ-diagonal-chain-folds-the-lattice"
]

VerificationTest[
  { EPSRadarAxiomQ[ $diamond, InfraRadarCoordinates[ $stair ] ], EPSRadarAxiomQ[ $diamond, InfraRadarCoordinates[ { $diagonal4, $shifted } ] ] },
  { True, True },
  TestID -> "EPSRadarAxiomQ-staircase-worldline-and-two-observers-chart-injectively"
]

VerificationTest[
  AllTrue[ $charts, Apply[ { g, chart } |->
    EPSRadarAxiomQ[ g, chart ] === AllTrue[ InfraFibers @ InfraMeasurement[ g, chart, "Fibration" ], VertexCount @ # == 1 & ] ] ],
  True,
  TestID -> "EPSRadarAxiomQ-equals-singleton-fibers-of-the-observer-space"
]

VerificationTest[
  AllTrue[ $charts, Apply[ { g, chart } |->
    EPSRadarAxiomQ[ g, chart ] === ( Length @ InfraMeasurement[ g, chart, "Domain" ] == VertexCount @ InfraMeasurement[ g, chart, "BaseGraph" ] ) ] ],
  True,
  TestID -> "EPSRadarAxiomQ-equals-one-coordinate-cell-per-event-of-the-domain"
]

VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; RandomCausalGraph[ 60, Method -> { "Sprinkling", 2 } ] ) },
    { a = ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ g ] ) },
    { b = ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ VertexDelete[ g, a ] ] ) },
    { Implies[ EPSRadarAxiomQ[ g, InfraRadarCoordinates[ a ] ], EPSRadarAxiomQ[ g, InfraRadarCoordinates[ { a, b } ] ] ],
      EPSRadarAxiomQ[ g, InfraRadarCoordinates[ { a, b } ] ] === EPSRadarAxiomQ[ g, InfraRadarCoordinates[ { b, a } ] ] } ],
  { True, True },
  TestID -> "EPSRadarAxiomQ-joining-an-observer-keeps-injectivity-and-ignores-the-order-of-observers"
]

EndTestSection[]
