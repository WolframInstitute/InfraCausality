BeginTestSection["UniversalTime"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$mechGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 } ];

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$random12 = BlockRandom[ SeedRandom[ 1 ]; RandomCausalGraph[ { 12, 20 } ] ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$fixtures = <| "Mech" -> $mechGraph, "TwoSource" -> $twoSource, "Random12" -> $random12, "Diamond" -> $diamond, "Cylinder" -> $cylinder |>;

$monotoneQ = g |-> With[ { t = UniversalTime @ g }, AllTrue[ EdgeList @ g, e |-> t[ e[[ 1 ]] ] < t[ e[[ 2 ]] ] ] ];

$pairwiseIncomparableQ = { g, set } |-> AllTrue[ Subsets[ set, { 2 } ],
  pair |-> ! MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] && ! MemberQ[ VertexOutComponent[ g, { Last @ pair } ], First @ pair ] ];

$antichainSlicesQ = g |-> AllTrue[ UniversalFoliation @ g, slice |-> $pairwiseIncomparableQ[ g, slice ] ];

$partitionQ = g |-> With[ { slices = UniversalFoliation @ g }, Length @ Catenate @ slices == VertexCount @ g && Sort @ Catenate @ slices === Sort @ VertexList @ g ];

$zeroOnSourcesQ = g |-> Sort @ Keys @ Select[ UniversalTime @ g, EqualTo[ 0 ] ] === Sort @ Pick[ VertexList @ g, VertexInDegree @ g, 0 ];

$longestChainQ = g |-> With[ { t = UniversalTime @ g, sources = Pick[ VertexList @ g, VertexInDegree @ g, 0 ] },
  AllTrue[ VertexList @ g, v |-> t[ v ] == Max[ 0, Length /@ Catenate[ FindPath[ g, #, v, Infinity, All ] & /@ sources ] - 1 ] ] ];

VerificationTest[ Sort @ Keys @ UniversalTime @ $mechGraph, Sort @ VertexList @ $mechGraph, TestID -> "UniversalTime-Mech-keys-cover-graph" ]

VerificationTest[ AllTrue[ Values @ UniversalTime @ $mechGraph, IntegerQ ], True, TestID -> "UniversalTime-Mech-values-integer" ]

VerificationTest[ UniversalFoliation[ $twoSource ], { { 1, 2 }, { 3 }, { 4 }, { 5 } }, TestID -> "UniversalFoliation-TwoSource-slices" ]

VerificationTest[ $monotoneQ[ $twoSource ], True, TestID -> "UniversalTime-TwoSource-increases-along-edges" ]

VerificationTest[ $monotoneQ[ $random12 ], True, TestID -> "UniversalTime-Random12-increases-along-edges" ]

VerificationTest[ $antichainSlicesQ[ $twoSource ], True, TestID -> "UniversalFoliation-TwoSource-slices-are-antichains" ]

VerificationTest[ $antichainSlicesQ[ $random12 ], True, TestID -> "UniversalFoliation-Random12-slices-are-antichains" ]

VerificationTest[ $partitionQ[ $twoSource ], True, TestID -> "UniversalFoliation-TwoSource-partition" ]

VerificationTest[ $partitionQ[ $random12 ], True, TestID -> "UniversalFoliation-Random12-partition" ]

VerificationTest[ AllTrue[ $fixtures, $partitionQ ], True, TestID -> "UniversalFoliation-All-partition" ]

VerificationTest[ $zeroOnSourcesQ[ $twoSource ], True, TestID -> "UniversalTime-TwoSource-zero-exactly-on-sources" ]

VerificationTest[ $zeroOnSourcesQ[ $random12 ], True, TestID -> "UniversalTime-Random12-zero-exactly-on-sources" ]

VerificationTest[ AllTrue[ $fixtures, $longestChainQ ], True, TestID -> "UniversalTime-All-longest-chain-from-a-source" ]

VerificationTest[ UniversalTime @ $diamond, AssociationMap[ Total, VertexList @ $diamond ], TestID -> "UniversalTime-Diamond-is-coordinate-sum" ]

VerificationTest[ UniversalTime @ $cylinder, AssociationMap[ Last, VertexList @ $cylinder ], TestID -> "UniversalTime-Cylinder-is-row" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ UniversalFoliation @ g, slice |-> InfraAntichainQ[ g, slice ] ] ],
  True,
  TestID -> "InfraAntichainQ-All-accepts-every-slice"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ EdgeList @ g, e |-> ! InfraAntichainQ[ g, List @@ e ] && ! InfraAntichainQ[ g, Reverse[ List @@ e ] ] ] ],
  True,
  TestID -> "InfraAntichainQ-All-rejects-two-element-chains"
]

VerificationTest[
  AllTrue[ { $twoSource, $mechGraph, $cylinder }, g |-> AllTrue[ Subsets[ VertexList @ g, { 1, 3 } ],
    set |-> InfraAntichainQ[ g, set ] === $pairwiseIncomparableQ[ g, set ] ] ],
  True,
  TestID -> "InfraAntichainQ-All-agrees-with-pairwise-incomparability"
]

VerificationTest[ InfraAntichainQ[ $twoSource, { 1, 2, 1 } ], False, TestID -> "InfraAntichainQ-TwoSource-duplicates-rejected" ]

VerificationTest[ InfraAntichainQ[ $diamond, { { 0, 3 }, { 1, 2 }, { 2, 1 }, { 3, 0 } } ], True, TestID -> "InfraAntichainQ-Diamond-antidiagonal" ]

EndTestSection[]
