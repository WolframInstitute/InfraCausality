BeginTestSection["InfraMessageFunction"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$eps = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 5 -> 6, 6 -> 7, 7 -> 8, 1 -> 6, 2 -> 7, 3 -> 8, 5 -> 2, 6 -> 3, 7 -> 4 } ];

$lattice = n |-> Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= n & ],
  { i, 0, n }, { j, 0, n } ] ];

$diamond = $lattice[ 3 ];

$diamond6 = $lattice[ 5 ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$stair = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }, { 2, 2 }, { 3, 2 }, { 3, 3 } };

$stairShifted = { { 0, 2 }, { 1, 2 }, { 1, 3 }, { 2, 3 }, { 2, 4 }, { 3, 4 }, { 3, 5 } };

$column = k |-> Table[ { k, j }, { j, 0, 3 } ];

$cases = {
  { $eps, { 1, 2, 3, 4 }, { 5, 6, 7, 8 } },
  { $eps, { 5, 6, 7, 8 }, { 1, 2, 3, 4 } },
  { $diamond, $column[ 0 ], $column[ 2 ] },
  { $diamond6, $stair, $stairShifted },
  { $diamond6, $stairShifted, $stair },
  { $cylinder, $column[ 0 ], $column[ 1 ] },
  { $cylinder, $column[ 1 ], $column[ 0 ] } };

$tau = { g, v, w } |-> Max[ Length /@ If[ v === w, { { v } }, FindPath[ g, v, w, Infinity, All ] ] ] - 1;

$nullQ = { g, v, w } |-> MemberQ[ VertexOutComponent[ g, { v } ], w ] &&
  Length @ Intersection[ VertexOutComponent[ g, { v } ], VertexInComponent[ g, { w } ] ] == $tau[ g, v, w ] + 1;

$domain = { g, a, b } |-> Select[ InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ], # =!= { } & ];

$monotoneSelections = { g, a, b } |-> With[ { relation = $domain[ g, a, b ], position = AssociationThread[ b, Range @ Length @ b ] },
  Select[ AssociationThread[ Keys @ relation, # ] & /@ Tuples @ Values @ relation, f |-> LessEqual @@ Lookup[ position, Key /@ Values @ f ] ] ];

$allSelections = { g, a, b } |-> With[ { relation = $domain[ g, a, b ] },
  AssociationThread[ Keys @ relation, # ] & /@ Tuples @ Values @ relation ];

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { relation = InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ] },
    Keys @ relation === a && AllTrue[ a, v |-> Lookup[ relation, Key @ v ] === Select[ b, w |-> $nullQ[ g, v, w ] ] ] ] ] ],
  True,
  TestID -> "InfraMessageFunction-all-relation-is-null-future-on-b"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { relation = InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ] },
    AllTrue[ a, v |-> SubsetQ[ b, Lookup[ relation, Key @ v ] ] &&
      SubsetQ[ Keys @ InfraMeasurement[ g, InfraFutureLightCone[ v ], "VertexDensity" ], Lookup[ relation, Key @ v ] ] ] ] ] ],
  True,
  TestID -> "InfraMessageFunction-all-relation-in-b-and-light-cone"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Cardinality" ] == Length @ $monotoneSelections[ g, a, b ] ] ],
  True,
  TestID -> "InfraMessageFunction-all-cardinality-counts-monotone-selections"
]

VerificationTest[
  InfraMeasurement[ $diamond6, InfraMessageFunction[ $stair, $stairShifted ], "Cardinality" ],
  27,
  TestID -> "InfraMessageFunction-diamond6-staircase-cardinality"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> InfraMessageFunctionQ[ g, InfraMessageFunction[ a, b ], First /@ $domain[ g, a, b ] ] ] ],
  True,
  TestID -> "InfraMessageFunctionQ-all-earliest-image-selection"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { members = $monotoneSelections[ g, a, b ] },
    AllTrue[ $allSelections[ g, a, b ], f |-> InfraMessageFunctionQ[ g, InfraMessageFunction[ a, b ], f ] === MemberQ[ members, f ] &&
      InfraMemberQ[ g, InfraMessageFunction[ a, b ], f ] === MemberQ[ members, f ] ] ] ] ],
  True,
  TestID -> "InfraMessageFunctionQ-all-exactly-monotone-selections"
]

VerificationTest[
  With[ { a = $stair, b = $stairShifted },
    AllTrue[ $monotoneSelections[ $diamond6, a, b ], f |-> AllTrue[ Partition[ Keys @ f, 2, 1 ], Apply[ { v, w } |->
      f[ v ] === f[ w ] || ! InfraMessageFunctionQ[ $diamond6, InfraMessageFunction[ a, b ], Join[ f, <| v -> f[ w ], w -> f[ v ] |> ] ] ] ] ] ],
  True,
  TestID -> "InfraMessageFunctionQ-diamond6-swapped-pair-fails"
]

VerificationTest[
  With[ { f = <| { 1, 0 } -> { 1, 3 }, { 1, 1 } -> { 1, 2 } |>, relation = InfraMeasurement[ $diamond6, InfraMessageFunction[ $stair, $stairShifted ], "Relation" ] },
    { MemberQ[ relation[ { 1, 0 } ], { 1, 3 } ] && MemberQ[ relation[ { 1, 1 } ], { 1, 2 } ],
      InfraMessageFunctionQ[ $diamond6, InfraMessageFunction[ $stair, $stairShifted ],
        Join[ First /@ $domain[ $diamond6, $stair, $stairShifted ], f ] ] } ],
  { True, False },
  TestID -> "InfraMessageFunctionQ-diamond6-admissible-images-out-of-order"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { f = First /@ $domain[ g, a, b ] },
    ! InfraMessageFunctionQ[ g, InfraMessageFunction[ a, b ], Rest @ f ] &&
      ! InfraMessageFunctionQ[ g, InfraMessageFunction[ a, b ], List /@ f ] ] ] ],
  True,
  TestID -> "InfraMessageFunctionQ-all-partial-or-multivalued-fails"
]

VerificationTest[
  With[ { a = $column[ 0 ], b = $column[ 2 ] },
    { InfraWorldlineQ[ $diamond, { a, b } ],
      InfraMeasurement[ $diamond, InfraMessageFunction[ a, b ], "Cardinality" ],
      $monotoneSelections[ $diamond, a, b ] } ],
  { True, 1, { AssociationThread[ Table[ { 0, j }, { j, 0, 3 } ], Table[ { 2, j }, { j, 0, 3 } ] ] } },
  TestID -> "InfraMessageFunction-diamond-parallel-worldlines-unique"
]

VerificationTest[
  With[ { a = $column[ 0 ], b = $column[ 2 ] },
    With[ { f = First @ $monotoneSelections[ $diamond, a, b ] },
      Less @@ Lookup[ AssociationThread[ b, Range @ 4 ], Key /@ Lookup[ f, Key /@ a ] ] ] ],
  True,
  TestID -> "InfraMessageFunction-diamond-parallel-worldlines-increasing"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    Sort @ EdgeList @ InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Graph" ] ===
      Sort @ Catenate @ KeyValueMap[ { v, ws } |-> ( DirectedEdge[ v, # ] & /@ ws ), InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ] ] ] ],
  True,
  TestID -> "InfraMessageFunction-all-graph-edges-are-relation-pairs"
]

VerificationTest[
  { Keys @ InfraMeasurement[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], All ],
    InfraMeasurement[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], "Faithful" ],
    InfraMeasurement[ $eps, InfraEchoFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], "Faithful" ] },
  { { "Relation", "Graph", "Cardinality", "Faithful" }, True, True },
  TestID -> "InfraMessageFunction-EPS-all-keys"
]

VerificationTest[
  InfraMeasurement[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], "Relation" ],
  <| 1 -> { 6 }, 2 -> { 7 }, 3 -> { 8 }, 4 -> { } |>,
  TestID -> "InfraMessageFunction-EPS-relation"
]

VerificationTest[
  { InfraMessageFunctionQ[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], <| 1 -> 6, 2 -> 7, 3 -> 8 |> ],
    InfraMessageFunctionQ[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], <| 1 -> 8, 2 -> 7, 3 -> 6 |> ] },
  { True, False },
  TestID -> "InfraMessageFunctionQ-EPS-identity-like-accepted-reversal-rejected"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { relation = InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Relation" ] },
    Keys @ relation === a && AllTrue[ Range @ Length @ a, i |-> SubsetQ[ Drop[ a, i ], Lookup[ relation, Key @ a[[ i ]] ] ] ] ] ] ],
  True,
  TestID -> "InfraEchoFunction-all-echo-after-tick"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[
    { ab = InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ], ba = InfraMeasurement[ g, InfraMessageFunction[ b, a ], "Relation" ],
      relation = InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Relation" ] },
    AllTrue[ a, v |-> Sort @ Lookup[ relation, Key @ v ] === Union @@ Prepend[ Lookup[ ba, Key /@ Lookup[ ab, Key @ v ] ], { } ] ] ] ] ],
  True,
  TestID -> "InfraEchoFunction-all-relation-is-composite"
]

VerificationTest[
  InfraMeasurement[ $diamond6, InfraEchoFunction[ $stair, $stairShifted ], "Relation" ],
  <| { 0, 0 } -> { { 2, 2 }, { 3, 2 } }, { 1, 0 } -> { { 2, 2 }, { 3, 2 }, { 3, 3 } }, { 1, 1 } -> { { 2, 2 }, { 3, 2 }, { 3, 3 } },
     { 2, 1 } -> { { 3, 3 } }, { 2, 2 } -> { { 3, 3 } }, { 3, 2 } -> { }, { 3, 3 } -> { } |>,
  TestID -> "InfraEchoFunction-diamond6-staircase-relation"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    Sort @ EdgeList @ InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Graph" ] ===
      Sort @ Catenate @ KeyValueMap[ { v, us } |-> ( DirectedEdge[ v, # ] & /@ us ), InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Relation" ] ] ] ],
  True,
  TestID -> "InfraEchoFunction-all-graph-edges-are-relation-pairs"
]

VerificationTest[
  InfraMeasurement[ $eps, InfraEchoFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], "Relation" ],
  <| 1 -> { 3 }, 2 -> { 4 }, 3 -> { }, 4 -> { } |>,
  TestID -> "InfraEchoFunction-EPS-relation"
]

VerificationTest[
  { InfraEchoFunctionQ[ $eps, InfraEchoFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], <| 1 -> 3, 2 -> 4 |> ],
    InfraEchoFunctionQ[ $eps, InfraEchoFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], <| 1 -> 4 |> ],
    InfraEchoFunctionQ[ $diamond6, InfraEchoFunction[ $stair, $stairShifted ], <| { 0, 0 } -> { 3, 2 }, { 1, 0 } -> { 2, 2 } |> ],
    InfraEchoFunctionQ[ $diamond6, InfraEchoFunction[ $stair, $stairShifted ], <| { 0, 0 } -> { 2, 2 }, { 1, 0 } -> { 3, 2 } |> ] },
  { True, False, False, True },
  TestID -> "InfraEchoFunctionQ-image-membership-and-order"
]

EndTestSection[]
