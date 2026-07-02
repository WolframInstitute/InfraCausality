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
