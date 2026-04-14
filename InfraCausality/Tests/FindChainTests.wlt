BeginTestSection["FindChain"]

(* ========================= Setup ========================= *)

SeedRandom[ 42 ];

(* Single-source graph *)
$testGraph = Graph[
  { 1 -> 2, 1 -> 3, 2 -> 4, 2 -> 5, 3 -> 5, 3 -> 6, 4 -> 7, 5 -> 7, 5 -> 8, 6 -> 8, 7 -> 9, 8 -> 9 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

(* Multi-source graph: two sources feed into a shared middle *)
$multiSourceGraph = Graph[
  { 1 -> 3, 1 -> 4, 2 -> 4, 2 -> 5, 3 -> 6, 4 -> 6, 4 -> 7, 5 -> 7, 6 -> 8, 7 -> 8 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

(* ========================= Basic FindChain ========================= *)

VerificationTest[
  Length @ FindChain[ $testGraph ],
  1,
  TestID -> "FindChain-default-returns-one-chain"
]

VerificationTest[
  MatchQ[ FindChain[ $testGraph ], { { __Integer } } ],
  True,
  TestID -> "FindChain-returns-list-of-lists"
]

VerificationTest[
  Length @ First @ FindChain[ $testGraph ] >= 4,
  True,
  TestID -> "FindChain-longest-chain-has-at-least-4-vertices"
]

VerificationTest[
  With[ { chain = First @ FindChain[ $testGraph ] },
    AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ $testGraph, DirectedEdge @@ # ] & ]
  ],
  True,
  TestID -> "FindChain-is-valid-directed-path"
]

VerificationTest[
  With[ { chain = First @ FindChain[ $testGraph ] },
    MemberQ[ GetSources[ $testGraph ], First @ chain ] && MemberQ[ GetSinks[ $testGraph ], Last @ chain ]
  ],
  True,
  TestID -> "FindChain-starts-at-source-ends-at-sink"
]

(* ========================= FindChain with n ========================= *)

VerificationTest[
  Length @ FindChain[ $testGraph, 3 ] <= 3,
  True,
  TestID -> "FindChain-n-returns-at-most-n"
]

VerificationTest[
  AllTrue[ FindChain[ $testGraph, 3 ],
    chain |-> AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ $testGraph, DirectedEdge @@ # ] & ]
  ],
  True,
  TestID -> "FindChain-n-all-valid-paths"
]

(* ========================= FindChain with endpoints ========================= *)

VerificationTest[
  With[ { chain = First @ FindChain[ $testGraph, 1, 9 ] },
    First[ chain ] === 1 && Last[ chain ] === 9
  ],
  True,
  TestID -> "FindChain-v1-v2-correct-endpoints"
]

VerificationTest[
  FindChain[ $testGraph, 1, 1 ],
  {},
  TestID -> "FindChain-same-vertex-returns-empty"
]

(* ========================= Separated method: basic ========================= *)

VerificationTest[
  AllTrue[ FindChain[ $testGraph, 2, "Method" -> "Separated" ],
    chain |-> AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ $testGraph, DirectedEdge @@ # ] & ]
  ],
  True,
  TestID -> "Separated-all-valid-paths"
]

VerificationTest[
  AllTrue[ FindChain[ $testGraph, 2, "Method" -> "Separated" ],
    chain |-> MemberQ[ GetSources[ $testGraph ], First @ chain ]
  ],
  True,
  TestID -> "Separated-chains-start-at-sources"
]

(* ========================= Separated method: multi-source produces distinct chains ========================= *)

VerificationTest[
  With[ { chains = FindChain[ $multiSourceGraph, 2, "Method" -> "Separated" ] },
    Length[ chains ] == 2 && Length @ Union[ chains ] == 2
  ],
  True,
  TestID -> "Separated-multi-source-distinct"
]

(* ========================= Separated method: deduplicates when only one path exists ========================= *)

VerificationTest[
  With[ { graph = Graph[ { 1 -> 2, 2 -> 3 } ] },
    FindChain[ graph, 2, "Method" -> "Separated" ]
  ],
  { { 1, 2, 3 } },
  TestID -> "Separated-single-path-deduplicates"
]

(* ========================= Separated method: with TargetSeparation ========================= *)

VerificationTest[
  MatchQ[
    FindChain[ $multiSourceGraph, 2, "Method" -> "Separated", "TargetSeparation" -> 2 ],
    { { __Integer }, { __Integer } }
  ],
  True,
  TestID -> "Separated-with-target-number"
]

VerificationTest[
  MatchQ[
    FindChain[ $multiSourceGraph, 2, "Method" -> "Separated", "TargetSeparation" -> { 1, 3 } ],
    { { __Integer }, { __Integer } }
  ],
  True,
  TestID -> "Separated-with-target-interval"
]

(* ========================= Separated method: with endpoints ========================= *)

VerificationTest[
  With[ { chains = FindChain[ $testGraph, 1, 9, 2, "Method" -> "Separated" ] },
    AllTrue[ chains, First[ # ] === 1 & ]
  ],
  True,
  TestID -> "Separated-v1-v2-correct-start"
]

VerificationTest[
  With[ { chains = FindChain[ $testGraph, 1, 9, 2, "Method" -> "Separated" ] },
    AllTrue[ chains,
      chain |-> AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ $testGraph, DirectedEdge @@ # ] & ]
    ]
  ],
  True,
  TestID -> "Separated-v1-v2-valid-paths"
]

(* ========================= Separated method: custom tiebreaker ========================= *)

VerificationTest[
  With[ { chains = FindChain[ $testGraph, 2, "Method" -> "Separated", "TieBreaker" -> Last ] },
    AllTrue[ chains,
      chain |-> AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ $testGraph, DirectedEdge @@ # ] & ]
    ]
  ],
  True,
  TestID -> "Separated-custom-tiebreaker"
]

(* ========================= Separated method: larger graph ========================= *)

VerificationTest[
  With[ { graph = RandomConnectedDAG[ { 30, 60 } ] },
    With[ { chains = FindChain[ graph, 3, "Method" -> "Separated" ] },
      Length[ chains ] >= 1 &&
      AllTrue[ chains,
        chain |-> AllTrue[ Partition[ chain, 2, 1 ], EdgeQ[ graph, DirectedEdge @@ # ] & ]
      ]
    ]
  ],
  True,
  TestID -> "Separated-larger-graph-valid"
]

(* ========================= Edge cases ========================= *)

VerificationTest[
  FindChain[ $testGraph, 1, "Method" -> "Separated" ] // Length,
  1,
  TestID -> "Separated-n-equals-1"
]

EndTestSection[]
