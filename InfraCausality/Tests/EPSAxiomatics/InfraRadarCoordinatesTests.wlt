BeginTestSection["InfraRadarCoordinates"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$two = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$lattice = n |-> Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= n & ],
  { i, 0, n }, { j, 0, n } ] ];

$diamond = $lattice[ 3 ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$diagonal = Table[ { m, m }, { m, 0, 3 } ];

$stair = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }, { 2, 2 }, { 3, 2 }, { 3, 3 } };

$shifted = Table[ { m, m + 1 }, { m, 0, 2 } ];

$column = Table[ { 0, t }, { t, 0, 3 } ];

$spiral = { { 0, 0 }, { 1, 1 }, { 2, 2 }, { 0, 3 } };

$cases = {
  { $two, { 1, 3, 5 } },
  { $two, { 1, 3, 4, 5 } },
  { $diamond, $diagonal },
  { $diamond, $stair },
  { $diamond, $column },
  { $cylinder, $column },
  { $cylinder, $spiral } };

$leq = { g, u, v } |-> GraphDistance[ g, u, v ] < Infinity;

$domain = { g, a } |-> Sort @ Select[ VertexList @ g, e |-> $leq[ g, First @ a, e ] && $leq[ g, e, Last @ a ] ];

$ticks = { g, a, e } |-> { Max @ Pick[ Range @ Length @ a, $leq[ g, #, e ] & /@ a ], Min @ Pick[ Range @ Length @ a, $leq[ g, e, # ] & /@ a ] };

$chart = { g, a } |-> AssociationMap[ e |-> With[ { ij = $ticks[ g, a, e ] }, { Total[ ij ] / 2, ( Last[ ij ] - First[ ij ] ) / 2 } ], $domain[ g, a ] ];

$coordinates = { g, a } |-> InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Coordinates" ];

$fibration = { g, a } |-> InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Fibration" ];

$edgeSet = g |-> Sort[ Sort /@ List @@@ EdgeList @ g ];

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { coords = $coordinates[ g, a ] },
    MapIndexed[ { v, m } |-> coords[ v ] === { First @ m, 0 }, a ] === ConstantArray[ True, Length @ a ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-tick-is-own-emission-and-reception"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> Normal @ $coordinates[ g, a ] === Normal @ $chart[ g, a ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-coordinates-from-emission-and-reception-ticks"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Domain" ] === Keys @ InfraMeasurement[ g, InfraCausalDiamond[ First @ a, Last @ a ], "VertexDensity" ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-domain-is-the-diamond-of-first-and-last-tick"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { time = InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Time" ] },
    AllTrue[ EdgeList @ InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Subgraph" ], e |-> time[ First @ e ] <= time[ Last @ e ] ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-time-weakly-monotone-along-domain-edges"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> AllTrue[ InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Distance" ], GreaterEqualThan[ 0 ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-distance-nonnegative"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { coords = $coordinates[ g, a ] },
    InfraMeasurement[ g, InfraRadarCoordinates[ a ], { "Time", "Distance" } ] === <| "Time" -> First /@ coords, "Distance" -> Last /@ coords |> ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-time-and-distance-are-the-marginals"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { sub = InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Subgraph" ], domain = $domain[ g, a ] },
    DirectedGraphQ @ sub && Sort @ VertexList @ sub === domain && $edgeSet @ sub === $edgeSet @ Subgraph[ g, domain ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-subgraph-is-the-directed-domain"
]

VerificationTest[
  $coordinates[ $diamond, $diagonal ],
  AssociationMap[ Apply[ { i, j } |-> { ( i + j ) / 2 + 1, Abs[ j - i ] / 2 } ], Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarCoordinates-diamond-diagonal-exact-map"
]

VerificationTest[
  InfraMeasurement[ $diamond, InfraRadarCoordinates[ $diagonal ], "Domain" ],
  Tuples[ Range[ 0, 3 ], 2 ],
  TestID -> "InfraRadarCoordinates-diamond-diagonal-domain-is-the-whole-lattice"
]

VerificationTest[
  With[ { coords = $coordinates[ $diamond, $diagonal ] },
    { DuplicateFreeQ @ Values @ KeySelect[ coords, Apply[ LessEqual ] ], DuplicateFreeQ @ Values @ KeySelect[ coords, Apply[ GreaterEqual ] ],
      DuplicateFreeQ @ Values @ coords } ],
  { True, True, False },
  TestID -> "InfraRadarCoordinates-diamond-diagonal-injective-on-each-side-only"
]

VerificationTest[
  Sort[ Sort /@ Values[ VertexList /@ InfraFibers @ $fibration[ $diamond, $diagonal ] ] ],
  Sort @ DeleteDuplicates[ Sort @ DeleteDuplicates @ { #, Reverse @ # } & /@ Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarCoordinates-diamond-diagonal-fibers-are-mirror-pairs"
]

VerificationTest[
  With[ { time = InfraMeasurement[ $diamond, InfraRadarCoordinates[ $diagonal ], "Time" ] },
    Sort /@ Values @ KeySort @ GroupBy[ Normal @ time, Last -> First ] ],
  CausalHeightFoliation @ $diamond,
  TestID -> "InfraRadarCoordinates-diamond-diagonal-time-level-sets-are-height-slices"
]

VerificationTest[
  $coordinates[ $diamond, $stair ],
  AssociationMap[ Apply[ { i, j } |-> { i + j + 1, Abs[ i - j ] - Boole[ i > j ] } ], Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarCoordinates-diamond-staircase-exact-map"
]

VerificationTest[
  With[ { fib = $fibration[ $diamond, $stair ] },
    { InfraTimelikeGeodesicQ[ $diamond, $stair ], DuplicateFreeQ @ Values @ $coordinates[ $diamond, $stair ],
      Union[ VertexCount /@ Values @ InfraFibers @ fib ], InfraFibrationQ @ fib, InfraFiberBundleQ @ fib } ],
  { True, True, { 1 }, True, True },
  TestID -> "InfraRadarCoordinates-diamond-staircase-worldline-chart-is-a-bijection"
]

VerificationTest[
  $coordinates[ $diamond, $column ],
  AssociationThread[ $column, Table[ { m, 0 }, { m, 4 } ] ],
  TestID -> "InfraRadarCoordinates-diamond-null-column-sees-only-itself"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { fib = $fibration[ g, a ], coords = $coordinates[ g, a ] },
    { fibers = InfraFibers @ fib },
    Sort @ Keys @ fibers === Sort @ DeleteDuplicates @ Values @ coords &&
      Sort @ Catenate[ VertexList /@ Values @ fibers ] === Keys @ coords &&
      AllTrue[ Normal @ fibers, Apply[ { c, fiber } |-> AllTrue[ VertexList @ fiber, coords[ # ] === c & ] ] ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-fibers-indexed-by-cells-partition-the-domain"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { fib = $fibration[ g, a ] },
    UndirectedGraphQ @ InfraTotalSpace @ fib && Sort @ VertexList @ InfraTotalSpace @ fib === $domain[ g, a ] &&
      InfraSectionQ[ fib, RandomInfraSection @ fib ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-random-section-of-the-undirected-domain-passes-InfraSectionQ"
]

VerificationTest[
  InfraFibrationQ /@ { $fibration[ $two, { 1, 3, 5 } ], $fibration[ $diamond, $diagonal ], $fibration[ $diamond, $stair ] },
  { True, True, True },
  TestID -> "InfraRadarCoordinates-two-diamond-fibration-passes-InfraFibrationQ"
]

VerificationTest[
  InfraFiberBundleQ /@ { $fibration[ $two, { 1, 3, 5 } ], $fibration[ $diamond, $diagonal ] },
  { True, False },
  TestID -> "InfraRadarCoordinates-diamond-diagonal-fibers-of-two-sizes-are-no-bundle"
]

VerificationTest[
  With[ { fib = $fibration[ $cylinder, $column ], coords = $coordinates[ $cylinder, $column ] },
    { Sort[ Sort /@ Values[ VertexList /@ InfraFibers @ fib ] ], coords[ { 1, 1 } ], InfraFibrationQ @ fib,
      MemberQ[ EdgeList @ InfraBaseSpace @ fib, UndirectedEdge[ { 5 / 2, 3 / 2 }, { 4, 0 } ] ],
      EdgeQ[ InfraTotalSpace @ fib, UndirectedEdge[ { 1, 1 }, { 0, 3 } ] ] } ],
  { { { { 0, 0 } }, { { 0, 1 } }, { { 0, 2 } }, { { 0, 3 } }, { { 1, 1 }, { 2, 2 } } }, { 5 / 2, 3 / 2 }, False, True, False },
  TestID -> "InfraRadarCoordinates-cylinder-column-base-edge-does-not-lift-at-every-fiber-point"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { base = InfraMeasurement[ g, InfraRadarCoordinates[ a ], "BaseGraph" ], coords = $coordinates[ g, a ] },
    AcyclicGraphQ @ base && Sort @ VertexList @ base === Sort @ DeleteDuplicates @ Values @ coords &&
      Sort @ EdgeList @ base === Sort @ DeleteDuplicates @ Select[
        DirectedEdge[ coords[ First @ # ], coords[ Last @ # ] ] & /@ EdgeList @ Subgraph[ g, Keys @ coords ], Apply[ UnsameQ ] ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-base-graph-is-the-acyclic-order-on-cells"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    $edgeSet @ InfraMeasurement[ g, InfraRadarCoordinates[ a ], "BaseGraph" ] === $edgeSet @ InfraBaseSpace @ $fibration[ g, a ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-base-graph-forgets-direction-to-InfraBaseSpace"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    With[ { base = InfraMeasurement[ g, InfraRadarCoordinates[ a ], "BaseGraph" ], coords = $coordinates[ g, a ] },
      { cells = DeleteDuplicates @ Values @ coords },
      { plain = Graph[ cells, DeleteDuplicates @ Select[ DirectedEdge[ coords[ First @ # ], coords[ Last @ # ] ] & /@ EdgeList @ Subgraph[ g, Keys @ coords ], Apply[ UnsameQ ] ] ] },
      VertexList @ base === VertexList @ plain && EdgeList @ base === EdgeList @ plain &&
        GraphEmbedding @ base == N[ Reverse /@ VertexList @ base ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-styled-base-graph-keeps-cells-order-and-xt-positions"
]

VerificationTest[
  With[ { joined = $coordinates[ $diamond, { $diagonal, $shifted } ], ca = $coordinates[ $diamond, $diagonal ], cb = $coordinates[ $diamond, $shifted ] },
    { Keys @ joined === Intersection[ Keys @ ca, Keys @ cb ], Union[ Length /@ Values @ joined ],
      joined === AssociationMap[ e |-> Join[ ca[ e ], cb[ e ] ], Keys @ joined ],
      InfraMeasurement[ $diamond, InfraRadarCoordinates[ { $diagonal, $shifted } ], { "Time", "Distance", "Domain" } ] ===
        <| "Time" -> AssociationMap[ { ca[ # ][[ 1 ]], cb[ # ][[ 1 ]] } &, Keys @ joined ],
           "Distance" -> AssociationMap[ { ca[ # ][[ 2 ]], cb[ # ][[ 2 ]] } &, Keys @ joined ], "Domain" -> Keys @ joined |> } ],
  { True, { 4 }, True, True },
  TestID -> "InfraRadarCoordinates-diamond-two-observers-domain-is-the-intersection-vectors-concatenate"
]

VerificationTest[
  With[ { fib = $fibration[ $diamond, { $diagonal, $shifted } ] },
    { DuplicateFreeQ @ Values @ $coordinates[ $diamond, { $diagonal, $shifted } ], Union[ VertexCount /@ Values @ InfraFibers @ fib ], InfraFibrationQ @ fib } ],
  { True, { 1 }, True },
  TestID -> "InfraRadarCoordinates-diamond-two-observers-resolve-the-fold"
]

VerificationTest[
  Keys @ InfraMeasurement[ $cylinder, InfraRadarCoordinates[ $spiral ], All ],
  { "Coordinates", "Time", "Distance", "Domain", "VertexDensity", "EdgeDensity", "Subgraph", "BaseGraph", "Fibration", "Faithful" },
  TestID -> "InfraRadarCoordinates-cylinder-All-keys"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { domain = $domain[ g, a ], chart = InfraRadarCoordinates[ a ] },
    Keys @ InfraMeasurement[ g, chart, "VertexDensity" ] === domain && Union @ Values @ InfraMeasurement[ g, chart, "VertexDensity" ] === { 1 } &&
      Sort @ Keys @ InfraMeasurement[ g, chart, "EdgeDensity" ] === Sort @ EdgeList @ Subgraph[ g, domain ] &&
      Sort @ VertexList @ InfraMeasurement[ g, chart, "Subgraph" ] === domain ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-densities-and-subgraph-are-the-domain"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { domain = $domain[ g, a ] },
    AllTrue[ VertexList @ g, e |-> InfraMemberQ[ g, InfraRadarCoordinates[ a ], e ] === MemberQ[ domain, e ] ] ] ] ],
  True,
  TestID -> "InfraRadarCoordinates-all-member-exactly-on-the-domain"
]

VerificationTest[
  With[ { g = $diamond },
    { p = First @ Pick[ VertexList @ g, VertexInDegree @ g, 0 ], q = First @ Pick[ VertexList @ g, VertexOutDegree @ g, 0 ] },
    { a = ( SeedRandom[ 1 ]; RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic[ p, q ] ] ) },
    { chart = InfraRadarCoordinates[ a ] },
    { fib = InfraMeasurement[ g, chart, "Fibration" ] },
    { InfraTimelikeGeodesicQ[ g, a ], AcyclicGraphQ @ InfraMeasurement[ g, chart, "BaseGraph" ], Length @ InfraFibers @ fib,
      InfraFibrationQ @ fib, InfraSectionQ[ fib, RandomInfraSection @ fib ], $MessageList } ],
  { True, True, 16, True, True, { } },
  TestID -> "InfraRadarCoordinates-diamond-pipeline-worldline-chart-fibration-section"
]

EndTestSection[]
