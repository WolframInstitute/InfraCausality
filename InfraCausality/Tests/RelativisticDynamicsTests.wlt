BeginTestSection["RelativisticDynamics"]

(* ========================= Algebraic primitives ========================= *)

VerificationTest[
  InfraEnergy[ 1, 0 ],
  1/2,
  TestID -> "InfraEnergy-basic"
]

VerificationTest[
  InfraMomentum[ 1, 0 ],
  1/2,
  TestID -> "InfraMomentum-basic"
]

VerificationTest[
  InfraInterval[ 2, 3 ],
  6,
  TestID -> "InfraInterval-basic"
]

VerificationTest[
  InfraMass[ 4, 9 ],
  6,
  TestID -> "InfraMass-positive"
]

VerificationTest[
  InfraMass[ -4, 9 ],
  6,
  TestID -> "InfraMass-uses-abs"
]

VerificationTest[
  InfraVelocity[ 3, 1 ],
  1/2,
  TestID -> "InfraVelocity-basic"
]

VerificationTest[
  InfraVelocity[ p, p ],
  0,
  TestID -> "InfraVelocity-equal-projections-zero"
]

(* ========================= ChainProjection ========================= *)

$dynGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 },
  GraphLayout -> "LayeredDigraphEmbedding"
];

$refChain = { 1, 2, 3, 4 };
$targetChain = { 5, 6, 7, 8 };

VerificationTest[
  NumericQ @ N @ ChainProjection[ $dynGraph, $refChain, $targetChain ],
  True,
  TestID -> "ChainProjection-default-numeric"
]

VerificationTest[
  ChainProjection[ $dynGraph, $refChain, $targetChain, "Method" -> "Cone" ] ===
    ChainProjection[ $dynGraph, $refChain, $targetChain ],
  True,
  TestID -> "ChainProjection-method-cone-matches-default"
]

VerificationTest[
  NumericQ @ N @ ChainProjection[ $dynGraph, $refChain, $targetChain, "Method" -> "LightRays" ],
  True,
  TestID -> "ChainProjection-method-lightrays-numeric"
]

VerificationTest[
  ChainProjection[ $dynGraph, $refChain, $targetChain, "Method" -> "LightRays" ] <=
    ChainProjection[ $dynGraph, $refChain, $targetChain, "Method" -> "Cone" ],
  True,
  TestID -> "ChainProjection-lightrays-subset-of-cone"
]

(* ========================= ChainLightReach ========================= *)

VerificationTest[
  ListQ @ ChainLightReach[ $dynGraph, $refChain ],
  True,
  TestID -> "ChainLightReach-returns-list"
]

VerificationTest[
  SubsetQ[ VertexList[ $dynGraph ], ChainLightReach[ $dynGraph, $refChain ] ],
  True,
  TestID -> "ChainLightReach-in-graph"
]

(* ========================= InfraKinematics full pipeline ========================= *)

$kin = InfraKinematics[ $dynGraph, $refChain, { $targetChain, { 5, 6, 7 } }, "Method" -> "Cone" ];

VerificationTest[
  Head @ $kin,
  Association,
  TestID -> "InfraKinematics-returns-association"
]

VerificationTest[
  Sort @ Keys @ $kin,
  Sort @ { "Projections", "Energy", "Momentum", "Mass", "GeometricMass", "Interval", "Velocity" },
  TestID -> "InfraKinematics-has-expected-keys"
]

VerificationTest[
  Length @ $kin[ "Projections" ],
  2,
  TestID -> "InfraKinematics-projections-per-target"
]

VerificationTest[
  Head @ InfraKinematics[ $dynGraph, $refChain, { $targetChain, { 5, 6, 7 } }, "Method" -> "LightRays" ],
  Association,
  TestID -> "InfraKinematics-lightrays-method-runs"
]

(* ========================= Larger random graph ========================= *)

VerificationTest[
  SeedRandom[ 17 ];
  Quiet @ With[ { g = RandomCausalGraph[ { 25, 50 } ] },
    With[ { chains = FindChain[ g, 3, "Method" -> "Separated" ] },
      If[ Length[ chains ] >= 2,
        Head @ InfraKinematics[ g, First @ chains, Rest @ chains, "Method" -> "LightRays" ],
        Association
      ]
    ]
  ],
  Association,
  TestID -> "InfraKinematics-random-graph-smoke"
]

EndTestSection[]
