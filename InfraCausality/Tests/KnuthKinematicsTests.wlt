BeginTestSection["KnuthKinematics"]

(* ========================= Algebraic primitives ========================= *)

VerificationTest[
  KnuthEnergy[ 1, 0 ],
  1/2,
  TestID -> "KnuthEnergy-basic"
]

VerificationTest[
  KnuthMomentum[ 1, 0 ],
  1/2,
  TestID -> "KnuthMomentum-basic"
]

VerificationTest[
  KnuthInterval[ 2, 3 ],
  6,
  TestID -> "KnuthInterval-basic"
]

VerificationTest[
  KnuthMass[ 4, 9 ],
  6,
  TestID -> "KnuthMass-positive"
]

VerificationTest[
  KnuthMass[ -4, 9 ],
  6,
  TestID -> "KnuthMass-uses-abs"
]

VerificationTest[
  KnuthVelocity[ 3, 1 ],
  1/2,
  TestID -> "KnuthVelocity-basic"
]

VerificationTest[
  KnuthVelocity[ p, p ],
  0,
  TestID -> "KnuthVelocity-equal-projections-zero"
]

(* ========================= ChainProjection ========================= *)

$knuthGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

$refChain = { 1, 2, 3, 4 };
$targetChain = { 5, 6, 7, 8 };

VerificationTest[
  NumericQ @ N @ ChainProjection[ $knuthGraph, $refChain, $targetChain ],
  True,
  TestID -> "ChainProjection-default-numeric"
]

VerificationTest[
  ChainProjection[ $knuthGraph, $refChain, $targetChain, "Method" -> "Cone" ] ===
    ChainProjection[ $knuthGraph, $refChain, $targetChain ],
  True,
  TestID -> "ChainProjection-method-cone-matches-default"
]

VerificationTest[
  NumericQ @ N @ ChainProjection[ $knuthGraph, $refChain, $targetChain, "Method" -> "LightRays" ],
  True,
  TestID -> "ChainProjection-method-lightrays-numeric"
]

VerificationTest[
  ChainProjection[ $knuthGraph, $refChain, $targetChain, "Method" -> "LightRays" ] <=
    ChainProjection[ $knuthGraph, $refChain, $targetChain, "Method" -> "Cone" ],
  True,
  TestID -> "ChainProjection-lightrays-subset-of-cone"
]

(* ========================= ChainLightReach ========================= *)

VerificationTest[
  ListQ @ ChainLightReach[ $knuthGraph, $refChain ],
  True,
  TestID -> "ChainLightReach-returns-list"
]

VerificationTest[
  SubsetQ[ VertexList[ $knuthGraph ], ChainLightReach[ $knuthGraph, $refChain ] ],
  True,
  TestID -> "ChainLightReach-in-graph"
]

(* ========================= KnuthKinematics full pipeline ========================= *)

$kin = KnuthKinematics[ $knuthGraph, $refChain, { $targetChain, { 5, 6, 7 } }, "Method" -> "Cone" ];

VerificationTest[
  Head @ $kin,
  Association,
  TestID -> "KnuthKinematics-returns-association"
]

VerificationTest[
  Sort @ Keys @ $kin,
  Sort @ { "Projections", "Energy", "Momentum", "Mass", "GeometricMass", "Interval", "Velocity" },
  TestID -> "KnuthKinematics-has-expected-keys"
]

VerificationTest[
  Length @ $kin[ "Projections" ],
  2,
  TestID -> "KnuthKinematics-projections-per-target"
]

VerificationTest[
  Head @ KnuthKinematics[ $knuthGraph, $refChain, { $targetChain, { 5, 6, 7 } }, "Method" -> "LightRays" ],
  Association,
  TestID -> "KnuthKinematics-lightrays-method-runs"
]

(* ========================= Larger random graph ========================= *)

VerificationTest[
  SeedRandom[ 17 ];
  Quiet @ With[ { g = RandomCausalGraph[ { 25, 50 } ] },
    With[ { chains = FindChain[ g, 3, "Method" -> "Separated" ] },
      If[ Length[ chains ] >= 2,
        Head @ KnuthKinematics[ g, First @ chains, Rest @ chains, "Method" -> "LightRays" ],
        Association
      ]
    ]
  ],
  Association,
  TestID -> "KnuthKinematics-random-graph-smoke"
]

EndTestSection[]
