BeginTestSection["RelativisticMechanics"]

(* ========================= Setup ========================= *)

$mechGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

(* ========================= UniversalFoliation / UniversalTime ========================= *)

VerificationTest[
  Head @ UniversalFoliation[ $mechGraph ],
  List,
  TestID -> "UniversalFoliation-returns-list"
]

VerificationTest[
  Sort @ Catenate @ UniversalFoliation[ $mechGraph ],
  Sort @ VertexList[ $mechGraph ],
  TestID -> "UniversalFoliation-partitions-vertices"
]

VerificationTest[
  Head @ UniversalTime[ $mechGraph ],
  Association,
  TestID -> "UniversalTime-returns-association"
]

VerificationTest[
  Sort @ Keys @ UniversalTime[ $mechGraph ],
  Sort @ VertexList[ $mechGraph ],
  TestID -> "UniversalTime-keys-cover-graph"
]

VerificationTest[
  AllTrue[ Values @ UniversalTime[ $mechGraph ], IntegerQ ],
  True,
  TestID -> "UniversalTime-values-integer"
]

(* ========================= Light cones ========================= *)

VerificationTest[
  Head @ ForwardLightCone[ $mechGraph, 1 ],
  Graph,
  TestID -> "ForwardLightCone-returns-graph"
]

VerificationTest[
  Head @ BackwardLightCone[ $mechGraph, 4 ],
  Graph,
  TestID -> "BackwardLightCone-returns-graph"
]

VerificationTest[
  Head @ CausalInterval[ $mechGraph, 1, 4 ],
  Graph,
  TestID -> "CausalInterval-returns-graph"
]

VerificationTest[
  ListQ @ ChainCausalInterval[ $mechGraph, { 1, 2, 3, 4 } ],
  True,
  TestID -> "ChainCausalInterval-returns-list"
]

(* ========================= MaximalAbsorber / MaximalEmitter ========================= *)

VerificationTest[
  Head @ MaximalAbsorber[ $mechGraph ],
  Association,
  TestID -> "MaximalAbsorber-returns-association"
]

VerificationTest[
  AllTrue[ Values @ MaximalAbsorber[ $mechGraph ], InfraEventQ ],
  True,
  TestID -> "MaximalAbsorber-values-are-InfraEvent"
]

VerificationTest[
  Head @ MaximalEmitter[ $mechGraph ],
  Association,
  TestID -> "MaximalEmitter-returns-association"
]

VerificationTest[
  AllTrue[ Values @ MaximalEmitter[ $mechGraph ], InfraEventQ ],
  True,
  TestID -> "MaximalEmitter-values-are-InfraEvent"
]

(* ========================= Light rays ========================= *)

VerificationTest[
  ListQ @ OutgoingLightRays[ $mechGraph, 1 ],
  True,
  TestID -> "OutgoingLightRays-returns-list"
]

VerificationTest[
  SubsetQ[ VertexList @ $mechGraph, OutgoingLightRays[ $mechGraph, 1 ] ],
  True,
  TestID -> "OutgoingLightRays-vertices-in-graph"
]

VerificationTest[
  ListQ @ IncomingLightRays[ $mechGraph, 4 ],
  True,
  TestID -> "IncomingLightRays-returns-list"
]

(* ========================= Universal time and light rays: invariants ========================= *)

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$random12 = BlockRandom[ SeedRandom[ 1 ]; RandomCausalGraph[ { 12, 20 } ] ];

$monotoneQ = g |-> With[ { t = UniversalTime @ g }, AllTrue[ EdgeList @ g, e |-> t[ e[[ 1 ]] ] < t[ e[[ 2 ]] ] ] ];

$antichainSlicesQ = g |-> AllTrue[ UniversalFoliation @ g,
  slice |-> AllTrue[ Subsets[ slice, { 2 } ],
    pair |-> ! MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] && ! MemberQ[ VertexOutComponent[ g, { Last @ pair } ], First @ pair ] ] ];

$partitionQ = g |-> With[ { slices = UniversalFoliation @ g }, Length @ Catenate @ slices == VertexCount @ g && Sort @ Catenate @ slices === Sort @ VertexList @ g ];

$zeroOnSourcesQ = g |-> Sort @ Keys @ Select[ UniversalTime @ g, EqualTo[ 0 ] ] === Sort @ Pick[ VertexList @ g, VertexInDegree @ g, 0 ];

$longestChain = { g, v, e } |-> If[ v === e, 0, Max[ Length /@ FindPath[ g, v, e, Infinity, All ] ] - 1 ];

$raysInFutureQ = g |-> AllTrue[ VertexList @ g, v |-> SubsetQ[ VertexOutComponent[ g, { v } ], OutgoingLightRays[ g, v ] ] ];

$raysNullQ = g |-> AllTrue[ VertexList @ g, v |-> AllTrue[ OutgoingLightRays[ g, v ],
  e |-> Length @ Intersection[ VertexOutComponent[ g, { v } ], VertexInComponent[ g, { e } ] ] == 1 + $longestChain[ g, v, e ] ] ];

$raysTreeQ = g |-> AllTrue[ VertexList @ g, v |-> TreeGraphQ @ TransitiveReductionGraph @ Subgraph[ g, OutgoingLightRays[ g, v ] ] ];

VerificationTest[
  UniversalFoliation[ $twoSource ],
  { { 1, 2 }, { 3 }, { 4 }, { 5 } },
  TestID -> "UniversalFoliation-TwoSource-slices"
]

VerificationTest[ $monotoneQ[ $twoSource ], True, TestID -> "UniversalTime-TwoSource-increases-along-edges" ]

VerificationTest[ $monotoneQ[ $random12 ], True, TestID -> "UniversalTime-Random12-increases-along-edges" ]

VerificationTest[ $antichainSlicesQ[ $twoSource ], True, TestID -> "UniversalFoliation-TwoSource-slices-are-antichains" ]

VerificationTest[ $antichainSlicesQ[ $random12 ], True, TestID -> "UniversalFoliation-Random12-slices-are-antichains" ]

VerificationTest[ $partitionQ[ $twoSource ], True, TestID -> "UniversalFoliation-TwoSource-partition" ]

VerificationTest[ $partitionQ[ $random12 ], True, TestID -> "UniversalFoliation-Random12-partition" ]

VerificationTest[ $zeroOnSourcesQ[ $twoSource ], True, TestID -> "UniversalTime-TwoSource-zero-exactly-on-sources" ]

VerificationTest[ $zeroOnSourcesQ[ $random12 ], True, TestID -> "UniversalTime-Random12-zero-exactly-on-sources" ]

VerificationTest[ $raysInFutureQ[ $twoSource ], True, TestID -> "OutgoingLightRays-TwoSource-in-causal-future" ]

VerificationTest[ $raysInFutureQ[ $random12 ], True, TestID -> "OutgoingLightRays-Random12-in-causal-future" ]

VerificationTest[ $raysNullQ[ $twoSource ], True, TestID -> "OutgoingLightRays-TwoSource-interval-is-chain" ]

VerificationTest[ $raysNullQ[ $random12 ], True, TestID -> "OutgoingLightRays-Random12-interval-is-chain" ]

VerificationTest[ $raysTreeQ[ $twoSource ], True, TestID -> "OutgoingLightRays-TwoSource-Hasse-tree" ]

VerificationTest[ $raysTreeQ[ $random12 ], True, TestID -> "OutgoingLightRays-Random12-Hasse-tree" ]

(* ========================= InfraObjects ========================= *)

VerificationTest[
  InfraChain[ { { 1, 2 }, { 3, 4 } } ][ "Length" ],
  2,
  TestID -> "InfraChain-length"
]

VerificationTest[
  InfraChain[ { InfraChain[ { { 1, 2 } } ], InfraChain[ { { 3, 4 } } ] } ],
  InfraChain[ { { 1, 2 }, { 3, 4 } } ],
  TestID -> "InfraChain-auto-flatten"
]

VerificationTest[
  InfraChain[ { { 1, 2 }, { 3, 4 } } ][[ 1 ]],
  InfraChain[ { { 1, 2 } } ],
  TestID -> "InfraChain-Part-wraps"
]

VerificationTest[
  Length @ InfraEvent[ { 1, 2, 3 } ],
  3,
  TestID -> "InfraEvent-Length-overload"
]

EndTestSection[]
