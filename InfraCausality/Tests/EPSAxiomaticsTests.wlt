BeginTestSection["EPS"]

(* ========================= Setup ========================= *)

(* Two parallel 3-chains connected by a few cross light rays *)
$epsGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

$pathA = { 1, 2, 3, 4 };
$pathB = { 5, 6, 7, 8 };

(* ========================= MultiMessageFunction ========================= *)

VerificationTest[
  Head @ MultiMessageFunction[ $epsGraph, $pathA, $pathB ],
  Association,
  TestID -> "MultiMessageFunction-returns-association"
]

VerificationTest[
  Keys @ MultiMessageFunction[ $epsGraph, $pathA, $pathB ],
  $pathA,
  TestID -> "MultiMessageFunction-keys-match-domain"
]

VerificationTest[
  With[ { msg = MultiMessageFunction[ $epsGraph, $pathA, $pathB ] },
    AllTrue[ Values[ msg ], SubsetQ[ $pathB, # ] & ]
  ],
  True,
  TestID -> "MultiMessageFunction-values-subset-of-codomain"
]

VerificationTest[
  With[ { msg = MultiMessageFunction[ $epsGraph, $pathA, $pathB ] },
    AnyTrue[ Values[ msg ], # =!= {} & ]
  ],
  True,
  TestID -> "MultiMessageFunction-has-nonempty-image"
]

(* ========================= MonotoneQ ========================= *)

VerificationTest[
  MonotoneQ[ $pathA, $pathB, Association[ 1 -> 6, 2 -> 7, 3 -> 8 ] ],
  True,
  TestID -> "MonotoneQ-identity-like-mapping-monotone"
]

VerificationTest[
  MonotoneQ[ $pathA, $pathB, Association[ 1 -> 8, 2 -> 6 ] ],
  False,
  TestID -> "MonotoneQ-detects-reversal"
]

VerificationTest[
  MonotoneQ[ $pathA, $pathB, Association[ 1 -> {}, 2 -> 7 ] ],
  True,
  TestID -> "MonotoneQ-empty-image-ignored"
]

(* ========================= FindMessageFunction ========================= *)

VerificationTest[
  MatchQ[ FindMessageFunction[ $epsGraph, $pathA, $pathB ], { _Association ... } ],
  True,
  TestID -> "FindMessageFunction-returns-list-of-associations"
]

VerificationTest[
  Length @ FindMessageFunction[ $epsGraph, $pathA, $pathB ] > 0,
  True,
  TestID -> "FindMessageFunction-has-at-least-one-solution"
]

VerificationTest[
  With[ { solutions = FindMessageFunction[ $epsGraph, $pathA, $pathB ] },
    AllTrue[ solutions, MonotoneQ[ $pathA, $pathB, # ] & ]
  ],
  True,
  TestID -> "FindMessageFunction-all-solutions-monotone"
]

VerificationTest[
  Length @ FindMessageFunction[ $epsGraph, $pathA, $pathB, 2 ] <= 2,
  True,
  TestID -> "FindMessageFunction-n-bounds-result"
]

(* ========================= MultiEchoFunction ========================= *)

VerificationTest[
  Head @ MultiEchoFunction[ $epsGraph, $pathA, $pathB ],
  Association,
  TestID -> "MultiEchoFunction-returns-association"
]

VerificationTest[
  With[ { echo = MultiEchoFunction[ $epsGraph, $pathA, $pathB ] },
    AllTrue[ Values[ echo ], SubsetQ[ $pathA, # ] & ]
  ],
  True,
  TestID -> "MultiEchoFunction-values-subset-of-path1"
]

(* ========================= FindEchoFunction ========================= *)

VerificationTest[
  MatchQ[ FindEchoFunction[ $epsGraph, $pathA, $pathB ], { _Association ... } ],
  True,
  TestID -> "FindEchoFunction-returns-list-of-associations"
]

VerificationTest[
  With[ { solutions = FindEchoFunction[ $epsGraph, $pathA, $pathB ] },
    AllTrue[ solutions, MonotoneQ[ $pathA, $pathA, # ] & ]
  ],
  True,
  TestID -> "FindEchoFunction-all-solutions-monotone"
]

(* ========================= EchoGraph ========================= *)

VerificationTest[
  Head @ EchoGraph @ Association[ 1 -> 2, 2 -> 3, 3 -> 4 ],
  Graph,
  TestID -> "EchoGraph-returns-graph"
]

VerificationTest[
  SubsetQ[ VertexList @ EchoGraph @ Association[ 1 -> 2, 2 -> 3 ], { 1, 2 } ],
  True,
  TestID -> "EchoGraph-includes-domain-vertices"
]

EndTestSection[]
