BeginTestSection["CausalHighlight"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$two = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = CausalSubstrate[ "DiamondLatticeGraph", 3 ];

$cylinder = CausalSubstrate[ "CylinderLatticeGraph", { 3, 3 } ];

$column = { g, k } |-> Select[ VertexList @ g, v |-> First @ v == k ];

$heads = { g, p, q, a, b } |-> {
  InfraCausalFuture[ p ], InfraCausalPast[ q ], InfraCausalDiamond[ p, q ], InfraSlice[ 1 ],
  InfraWorldline[ p, q ], InfraObserver[ p, q ], InfraFutureLightCone[ p ], InfraPastLightCone[ q ],
  InfraMessageFunction[ a, b ], InfraEchoFunction[ a, b ] };

$cases = {
  { $two, 1, 5, { 1, 3, 4, 5 }, { 2, 4 } },
  { $diamond, { 0, 0 }, { 3, 3 }, $column[ $diamond, 0 ], $column[ $diamond, 2 ] },
  { $cylinder, { 0, 0 }, { 2, 3 }, $column[ $cylinder, 0 ], $column[ $cylinder, 1 ] } };

$rays = WolframInstitute`InfraCausality`PackageScope`causalInk;

$reachQ = { g, u, v } |-> GraphDistance[ g, u, v ] < Infinity;

VerificationTest[
  With[ { g = CausalSubstrate[ "DiamondLatticeGraph", "Small" ] },
    { r = InfraSubstrateHighlight[ g, { InfraCausalFuture[ { 1, 1 } ] -> StandardOrange, InfraWorldline[ { 0, 0 }, { 6, 6 } ], InfraSlice[ 1 ] } ] },
    { GraphQ @ r, $MessageList } ],
  { True, { } },
  TestID -> "CausalHighlight-DiamondLatticeGraph-list-form-graph-without-messages"
]

VerificationTest[
  With[ { g = CausalSubstrate[ "MinkowskiSprinkling2D", "Small" ] },
    { r = InfraSubstrateHighlight[ g, InfraCausalFuture[ 1 ] ] },
    { GraphQ @ r, $MessageList } ],
  { True, { } },
  TestID -> "CausalHighlight-MinkowskiSprinkling2D-single-object-form-graph-without-messages"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, p, q, a, b } |-> AllTrue[ $heads[ g, p, q, a, b ], head |->
    GraphQ @ InfraSubstrateHighlight[ g, head ] &&
      GraphQ @ InfraSubstrateHighlight[ g, { head -> StandardGreen, Style[ head, StandardRed ], InfraWalk[ a ] } ] ] ] ],
  True,
  TestID -> "CausalHighlight-all-every-head-every-item-form-draws"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, p, q, a, b } |-> AllTrue[ Take[ $heads[ g, p, q, a, b ], 4 ], head |->
    $rays[ g, head ] === InfraMeasurement[ g, head, "VertexDensity" ] ] ] ],
  True,
  TestID -> "CausalHighlight-all-set-heads-drawn-by-their-density"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, p, q, a, b } |-> AllTrue[ Take[ $heads[ g, p, q, a, b ], { 9, 10 } ], head |->
    SubsetQ[ EdgeList @ g, EdgeList @ $rays[ g, head ] ] ] ] ],
  True,
  TestID -> "CausalHighlight-all-message-and-echo-drawn-on-substrate-edges"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, p, q, a, b } |-> With[ { ink = $rays[ g, InfraMessageFunction[ a, b ] ] },
    AllTrue[ Normal @ InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ], rule |->
      AllTrue[ Last @ rule, w |-> With[ { ray = FindShortestPath[ ink, First @ rule, w ] }, ray =!= { } && InfraLightRayQ[ g, ray ] ] ] ] ] ] ],
  True,
  TestID -> "CausalHighlight-all-message-pairs-joined-by-a-light-ray-in-the-drawing"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, p, q, a, b } |-> With[ { ink = $rays[ g, InfraEchoFunction[ a, b ] ] },
    AllTrue[ Normal @ InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Relation" ], rule |->
      AllTrue[ Last @ rule, u |-> $reachQ[ ink, First @ rule, u ] ] ] ] ] ],
  True,
  TestID -> "CausalHighlight-all-echo-pairs-joined-in-the-drawing"
]

EndTestSection[]
