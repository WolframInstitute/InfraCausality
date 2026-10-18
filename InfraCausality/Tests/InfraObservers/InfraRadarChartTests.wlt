BeginTestSection["InfraRadarChart"]

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

$coordinates = { g, a } |-> InfraMeasurement[ g, InfraRadarChart[ a ], "Coordinates" ];

$fibration = { g, a } |-> InfraMeasurement[ g, InfraRadarChart[ a ], "Fibration" ];

$edgeSet = g |-> Sort[ Sort /@ List @@@ EdgeList @ g ];

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { coords = $coordinates[ g, a ] },
    MapIndexed[ { v, m } |-> coords[ v ] === { First @ m, 0 }, a ] === ConstantArray[ True, Length @ a ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-tick-is-own-emission-and-reception"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> Normal @ $coordinates[ g, a ] === Normal @ $chart[ g, a ] ] ],
  True,
  TestID -> "InfraRadarChart-all-coordinates-from-emission-and-reception-ticks"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    InfraMeasurement[ g, InfraRadarChart[ a ], "Domain" ] === Keys @ InfraMeasurement[ g, InfraCausalDiamond[ First @ a, Last @ a ], "VertexDensity" ] ] ],
  True,
  TestID -> "InfraRadarChart-all-domain-is-the-diamond-of-first-and-last-tick"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { time = InfraMeasurement[ g, InfraRadarChart[ a ], "Time" ] },
    AllTrue[ EdgeList @ InfraMeasurement[ g, InfraRadarChart[ a ], "Subgraph" ], e |-> time[ First @ e ] <= time[ Last @ e ] ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-time-weakly-monotone-along-domain-edges"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> AllTrue[ InfraMeasurement[ g, InfraRadarChart[ a ], "Distance" ], GreaterEqualThan[ 0 ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-distance-nonnegative"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { coords = $coordinates[ g, a ] },
    InfraMeasurement[ g, InfraRadarChart[ a ], { "Time", "Distance" } ] === <| "Time" -> First /@ coords, "Distance" -> Last /@ coords |> ] ] ],
  True,
  TestID -> "InfraRadarChart-all-time-and-distance-are-the-marginals"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { sub = InfraMeasurement[ g, InfraRadarChart[ a ], "Subgraph" ], domain = $domain[ g, a ] },
    DirectedGraphQ @ sub && Sort @ VertexList @ sub === domain && $edgeSet @ sub === $edgeSet @ Subgraph[ g, domain ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-subgraph-is-the-directed-domain"
]

VerificationTest[
  $coordinates[ $diamond, $diagonal ],
  AssociationMap[ Apply[ { i, j } |-> { ( i + j ) / 2 + 1, Abs[ j - i ] / 2 } ], Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarChart-diamond-diagonal-exact-map"
]

VerificationTest[
  InfraMeasurement[ $diamond, InfraRadarChart[ $diagonal ], "Domain" ],
  Tuples[ Range[ 0, 3 ], 2 ],
  TestID -> "InfraRadarChart-diamond-diagonal-domain-is-the-whole-lattice"
]

VerificationTest[
  With[ { coords = $coordinates[ $diamond, $diagonal ] },
    { DuplicateFreeQ @ Values @ KeySelect[ coords, Apply[ LessEqual ] ], DuplicateFreeQ @ Values @ KeySelect[ coords, Apply[ GreaterEqual ] ],
      DuplicateFreeQ @ Values @ coords } ],
  { True, True, False },
  TestID -> "InfraRadarChart-diamond-diagonal-injective-on-each-side-only"
]

VerificationTest[
  Sort[ Sort /@ Values[ VertexList /@ InfraFibers @ $fibration[ $diamond, $diagonal ] ] ],
  Sort @ DeleteDuplicates[ Sort @ DeleteDuplicates @ { #, Reverse @ # } & /@ Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarChart-diamond-diagonal-fibers-are-mirror-pairs"
]

VerificationTest[
  With[ { time = InfraMeasurement[ $diamond, InfraRadarChart[ $diagonal ], "Time" ] },
    Sort /@ Values @ KeySort @ GroupBy[ Normal @ time, Last -> First ] ],
  UniversalFoliation @ $diamond,
  TestID -> "InfraRadarChart-diamond-diagonal-time-level-sets-are-universal-slices"
]

VerificationTest[
  $coordinates[ $diamond, $stair ],
  AssociationMap[ Apply[ { i, j } |-> { i + j + 1, Abs[ i - j ] - Boole[ i > j ] } ], Tuples[ Range[ 0, 3 ], 2 ] ],
  TestID -> "InfraRadarChart-diamond-staircase-exact-map"
]

VerificationTest[
  With[ { fib = $fibration[ $diamond, $stair ] },
    { InfraWorldlineQ[ $diamond, $stair ], DuplicateFreeQ @ Values @ $coordinates[ $diamond, $stair ],
      Union[ VertexCount /@ Values @ InfraFibers @ fib ], InfraFibrationQ @ fib, InfraFiberBundleQ @ fib } ],
  { True, True, { 1 }, True, True },
  TestID -> "InfraRadarChart-diamond-staircase-worldline-chart-is-a-bijection"
]

VerificationTest[
  $coordinates[ $diamond, $column ],
  AssociationThread[ $column, Table[ { m, 0 }, { m, 4 } ] ],
  TestID -> "InfraRadarChart-diamond-null-column-sees-only-itself"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { fib = $fibration[ g, a ], coords = $coordinates[ g, a ] },
    { fibers = InfraFibers @ fib },
    Sort @ Keys @ fibers === Sort @ DeleteDuplicates @ Values @ coords &&
      Sort @ Catenate[ VertexList /@ Values @ fibers ] === Keys @ coords &&
      AllTrue[ Normal @ fibers, Apply[ { c, fiber } |-> AllTrue[ VertexList @ fiber, coords[ # ] === c & ] ] ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-fibers-indexed-by-cells-partition-the-domain"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { fib = $fibration[ g, a ] },
    UndirectedGraphQ @ InfraTotalGraph @ fib && Sort @ VertexList @ InfraTotalGraph @ fib === $domain[ g, a ] &&
      InfraSectionQ[ fib, RandomInfraSection @ fib ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-random-section-of-the-undirected-domain-passes-InfraSectionQ"
]

VerificationTest[
  InfraFibrationQ /@ { $fibration[ $two, { 1, 3, 5 } ], $fibration[ $diamond, $diagonal ], $fibration[ $diamond, $stair ] },
  { True, True, True },
  TestID -> "InfraRadarChart-two-diamond-fibration-passes-InfraFibrationQ"
]

VerificationTest[
  InfraFiberBundleQ /@ { $fibration[ $two, { 1, 3, 5 } ], $fibration[ $diamond, $diagonal ] },
  { True, False },
  TestID -> "InfraRadarChart-diamond-diagonal-fibers-of-two-sizes-are-no-bundle"
]

VerificationTest[
  With[ { fib = $fibration[ $cylinder, $column ], coords = $coordinates[ $cylinder, $column ] },
    { Sort[ Sort /@ Values[ VertexList /@ InfraFibers @ fib ] ], coords[ { 1, 1 } ], InfraFibrationQ @ fib,
      MemberQ[ EdgeList @ InfraBaseGraph @ fib, UndirectedEdge[ { 5 / 2, 3 / 2 }, { 4, 0 } ] ],
      EdgeQ[ InfraTotalGraph @ fib, UndirectedEdge[ { 1, 1 }, { 0, 3 } ] ] } ],
  { { { { 0, 0 } }, { { 0, 1 } }, { { 0, 2 } }, { { 0, 3 } }, { { 1, 1 }, { 2, 2 } } }, { 5 / 2, 3 / 2 }, False, True, False },
  TestID -> "InfraRadarChart-cylinder-column-base-edge-does-not-lift-at-every-fiber-point"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |-> With[ { base = InfraMeasurement[ g, InfraRadarChart[ a ], "BaseGraph" ], coords = $coordinates[ g, a ] },
    AcyclicGraphQ @ base && Sort @ VertexList @ base === Sort @ DeleteDuplicates @ Values @ coords &&
      Sort @ EdgeList @ base === Sort @ DeleteDuplicates @ Select[
        DirectedEdge[ coords[ First @ # ], coords[ Last @ # ] ] & /@ EdgeList @ Subgraph[ g, Keys @ coords ], Apply[ UnsameQ ] ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-base-graph-is-the-acyclic-order-on-cells"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    $edgeSet @ InfraMeasurement[ g, InfraRadarChart[ a ], "BaseGraph" ] === $edgeSet @ InfraBaseGraph @ $fibration[ g, a ] ] ],
  True,
  TestID -> "InfraRadarChart-all-base-graph-forgets-direction-to-InfraBaseGraph"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a } |->
    With[ { base = InfraMeasurement[ g, InfraRadarChart[ a ], "BaseGraph" ], coords = $coordinates[ g, a ] },
      { cells = DeleteDuplicates @ Values @ coords },
      { plain = Graph[ cells, DeleteDuplicates @ Select[ DirectedEdge[ coords[ First @ # ], coords[ Last @ # ] ] & /@ EdgeList @ Subgraph[ g, Keys @ coords ], Apply[ UnsameQ ] ] ] },
      VertexList @ base === VertexList @ plain && EdgeList @ base === EdgeList @ plain &&
        GraphEmbedding @ base == N[ Reverse /@ VertexList @ base ] ] ] ],
  True,
  TestID -> "InfraRadarChart-all-styled-base-graph-keeps-cells-order-and-xt-positions"
]

VerificationTest[
  With[ { joined = $coordinates[ $diamond, { $diagonal, $shifted } ], ca = $coordinates[ $diamond, $diagonal ], cb = $coordinates[ $diamond, $shifted ] },
    { Keys @ joined === Intersection[ Keys @ ca, Keys @ cb ], Union[ Length /@ Values @ joined ],
      joined === AssociationMap[ e |-> Join[ ca[ e ], cb[ e ] ], Keys @ joined ],
      InfraMeasurement[ $diamond, InfraRadarChart[ { $diagonal, $shifted } ], { "Time", "Distance", "Domain" } ] ===
        <| "Time" -> AssociationMap[ { ca[ # ][[ 1 ]], cb[ # ][[ 1 ]] } &, Keys @ joined ],
           "Distance" -> AssociationMap[ { ca[ # ][[ 2 ]], cb[ # ][[ 2 ]] } &, Keys @ joined ], "Domain" -> Keys @ joined |> } ],
  { True, { 4 }, True, True },
  TestID -> "InfraRadarChart-diamond-two-observers-domain-is-the-intersection-vectors-concatenate"
]

VerificationTest[
  With[ { fib = $fibration[ $diamond, { $diagonal, $shifted } ] },
    { DuplicateFreeQ @ Values @ $coordinates[ $diamond, { $diagonal, $shifted } ], Union[ VertexCount /@ Values @ InfraFibers @ fib ], InfraFibrationQ @ fib } ],
  { True, { 1 }, True },
  TestID -> "InfraRadarChart-diamond-two-observers-resolve-the-fold"
]

VerificationTest[
  Keys @ InfraMeasurement[ $cylinder, InfraRadarChart[ $spiral ], All ],
  { "Coordinates", "Time", "Distance", "Domain", "Subgraph", "BaseGraph", "Fibration", "Faithful" },
  TestID -> "InfraRadarChart-cylinder-All-keys"
]

VerificationTest[
  With[ { g = $diamond },
    { p = First @ Pick[ VertexList @ g, VertexInDegree @ g, 0 ], q = First @ Pick[ VertexList @ g, VertexOutDegree @ g, 0 ] },
    { a = ( SeedRandom[ 1 ]; RandomInfraWorldline[ g, InfraWorldline[ p, q ] ] ) },
    { chart = InfraRadarChart[ a ] },
    { fib = InfraMeasurement[ g, chart, "Fibration" ] },
    { InfraWorldlineQ[ g, a ], AcyclicGraphQ @ InfraMeasurement[ g, chart, "BaseGraph" ], Length @ InfraFibers @ fib,
      InfraFibrationQ @ fib, InfraSectionQ[ fib, RandomInfraSection @ fib ], $MessageList } ],
  { True, True, 16, True, True, { } },
  TestID -> "InfraRadarChart-diamond-pipeline-worldline-chart-fibration-section"
]

EndTestSection[]
