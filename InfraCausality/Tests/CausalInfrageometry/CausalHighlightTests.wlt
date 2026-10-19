BeginTestSection["CausalHighlight"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$two = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = CausalSubstrate[ "DiamondLatticeGraph", 3 ];

$cylinder = CausalSubstrate[ "CylinderLatticeGraph", { 3, 3 } ];

$column = { g, k } |-> Select[ VertexList @ g, v |-> First @ v == k ];

$heads = { g, p, q, a, b } |-> {
  InfraCausalFuture[ p ], InfraCausalPast[ q ], InfraCausalDiamond[ p, q ], InfraSlice[ 1 ],
  InfraTimelikeGeodesic[ p, q ], InfraWorldline[ p, q ], InfraFutureLightCone[ p ], InfraPastLightCone[ q ],
  InfraMessageFunction[ a, b ], InfraEchoFunction[ a, b ] };

$cases = {
  { $two, 1, 5, { 1, 3, 4, 5 }, { 2, 4 } },
  { $diamond, { 0, 0 }, { 3, 3 }, $column[ $diamond, 0 ], $column[ $diamond, 2 ] },
  { $cylinder, { 0, 0 }, { 2, 3 }, $column[ $cylinder, 0 ], $column[ $cylinder, 1 ] } };

$rays = WolframInstitute`InfraCausality`PackageScope`causalInk;

$reachQ = { g, u, v } |-> GraphDistance[ g, u, v ] < Infinity;

$inked = r |-> Sort @ Union[
  Keys @ Replace[ Lookup[ Options[ r, VertexShapeFunction ], VertexShapeFunction ], Automatic -> { } ],
  Select[ Lookup[ Options[ r, GraphHighlight ], GraphHighlight ], VertexQ[ r, # ] & ] ];

$cabinet = Apply[ { x, y, t } |-> { x + y / ( 2 Sqrt[ 2 ] ), t + y / ( 2 Sqrt[ 2 ] ) } ];

$spatial = name |-> With[ { g = CausalSubstrate[ name, "Small", "KeepCoordinates" -> True ] },
  { p = First @ Pick[ VertexList @ g, VertexInDegree @ g, 0 ] },
  { q = Last @ TopologicalSort @ Subgraph[ g, VertexOutComponent[ g, p ] ] },
  { a = ( SeedRandom[ 1 ]; RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic[ p, q ] ] ) },
  { r = InfraSubstrateHighlight[ g, { InfraCausalFuture[ p ] -> StandardOrange, InfraWalk[ a ] -> StandardGreen } ] },
  { Dimensions @ GraphEmbedding @ g, GraphQ @ r, Length @ a > 1,
    Max @ Abs[ GraphEmbedding @ r - $cabinet /@ GraphEmbedding @ g ] < 10^-12,
    VertexList @ r === VertexList @ g, EdgeList @ r === EdgeList @ g, $MessageList } ];

VerificationTest[
  With[ { g = CausalSubstrate[ "DiamondLatticeGraph", "Small" ] },
    { r = InfraSubstrateHighlight[ g, { InfraCausalFuture[ { 1, 1 } ] -> StandardOrange, InfraTimelikeGeodesic[ { 0, 0 }, { 6, 6 } ], InfraSlice[ 1 ] } ] },
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

VerificationTest[
  With[ { g = CausalSubstrate[ "DiamondLatticeGraph", "Small" ] },
    { a = ( SeedRandom[ 1 ]; RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic[ { 1, 0 }, { 5, 4 } ] ] ) },
    { domain = Sort @ InfraMeasurement[ g, InfraRadarCoordinates[ a ], "Domain" ],
      list = InfraSubstrateHighlight[ g, { InfraRadarCoordinates[ a ] -> StandardGreen, InfraWalk[ a ] } ],
      single = InfraSubstrateHighlight[ g, InfraRadarCoordinates[ a ] ] },
    { GraphQ @ list, GraphQ @ single, $inked @ list === domain, $inked @ single === domain, Length @ domain < VertexCount @ g, $MessageList } ],
  { True, True, True, True, True, { } },
  TestID -> "CausalHighlight-DiamondLatticeGraph-radar-coordinates-ink-exactly-its-domain"
]

VerificationTest[
  $spatial /@ { "CubicLatticeGraph", "MinkowskiSprinkling3D" },
  { { { 64, 3 }, True, True, True, True, True, { } }, { { 25, 3 }, True, True, True, True, True, { } } },
  TestID -> "CausalHighlight-3D-substrates-drawn-by-the-cabinet-projection"
]

VerificationTest[
  With[ { lhs = First /@ DownValues @ InfraSubstrateHighlight },
    { conditional = Flatten @ Position[ lhs, Verbatim[ HoldPattern ][ Verbatim[ Condition ][ _InfraSubstrateHighlight, _ ] ], { 1 }, Heads -> False ],
      generic = Flatten @ Position[ lhs, Verbatim[ HoldPattern ][ InfraSubstrateHighlight[ _, Verbatim[ Pattern ][ _, Verbatim[ _List ] ], ___ ] ], { 1 }, Heads -> False ] },
    { Length @ conditional, Length @ generic, Max @ conditional < First @ generic } ],
  { 2, 1, True },
  TestID -> "CausalHighlight-conditional-clauses-precede-the-generic-list-clause"
]

EndTestSection[]
