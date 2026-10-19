BeginTestSection[ "CausalViewers" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$two = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ]

$diamond = CausalSubstrate[ "DiamondLatticeGraph", 3 ]

$cylinder = CausalSubstrate[ "CylinderLatticeGraph", { 3, 3 } ]

$fixtures = { $two, $diamond, $cylinder }

$column = { g, k } |-> Select[ VertexList @ g, v |-> First @ v == k ]

$observerPairs = {
  { $two, { 1, 3, 4, 5 }, { 2, 4, 5 } },
  { $diamond, $column[ $diamond, 0 ], $column[ $diamond, 2 ] },
  { $diamond, $column[ $diamond, 2 ], $column[ $diamond, 0 ] },
  { $cylinder, $column[ $cylinder, 0 ], $column[ $cylinder, 1 ] }
}

$lightConeReading = WolframInstitute`InfraCausality`PackageScope`lightConeReading

$messageReading = WolframInstitute`InfraCausality`PackageScope`messageReading

$foliationReading = WolframInstitute`InfraCausality`PackageScope`foliationReading

$frame = { m, value } |-> With[ { sym = Extract[ m, { 2, 1, 1 } ] }, ReleaseHold[ Extract[ m, 1, Hold ] /. sym -> value ] ]

$drawsSubstrateQ = { frame, g } |->
  MatchQ[ Cases[ frame, h_Graph /; GraphQ[ h ] :> { VertexList @ h, EdgeList @ h }, { 0, Infinity } ], { { VertexList @ g, EdgeList @ g } } ]

$future = { g, e } |-> VertexOutComponent[ g, { e } ]

$lightCone = { g, v } |->
  Select[ $future[ g, v ], w |->
    With[ { d = Intersection[ $future[ g, v ], VertexInComponent[ g, { w } ] ] },
      AllTrue[ Subsets[ d, { 2 } ], pair |-> MemberQ[ $future[ g, First @ pair ], Last @ pair ] || MemberQ[ $future[ g, Last @ pair ], First @ pair ] ] ] ]

VerificationTest[
  Head /@ { LightConeViewer[ $diamond ], MessageFunctionViewer @@ $observerPairs[[ 2 ]], FoliationViewer[ $cylinder ] },
  { Manipulate, Manipulate, Manipulate },
  TestID -> "CausalViewers-Substrates-every-viewer-is-a-Manipulate"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> With[ { m = LightConeViewer[ g ] }, AllTrue[ VertexList @ g, v |-> $drawsSubstrateQ[ $frame[ m, v ], g ] ] ] ],
  True,
  TestID -> "LightConeViewer-Fixtures-every-event-draws-the-substrate"
]

VerificationTest[
  AllTrue[ $observerPairs, case |-> With[ { m = MessageFunctionViewer @@ case },
    AllTrue[ Range @ Length @ case[[ 2 ]], k |-> $drawsSubstrateQ[ $frame[ m, k ], First @ case ] ] ] ],
  True,
  TestID -> "MessageFunctionViewer-Observers-every-tick-draws-the-substrate"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> With[ { m = FoliationViewer[ g ] },
    AllTrue[ Range[ 0, Max @ UniversalTime @ g ], k |-> $drawsSubstrateQ[ $frame[ m, k ], g ] ] ] ],
  True,
  TestID -> "FoliationViewer-Fixtures-every-time-draws-the-substrate"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |->
    With[ { r = $lightConeReading[ g, v ] },
      Sort @ r[ "Future" ] === Sort @ VertexOutComponent[ g, { v } ] &&
      Sort @ r[ "Past" ] === Sort @ VertexInComponent[ g, { v } ] &&
      Intersection[ r[ "Future" ], r[ "Past" ] ] === { v } &&
      r[ "Time" ] === UniversalTime[ g ][ v ] ] ] ],
  True,
  TestID -> "LightConeViewer-Fixtures-reading-cones-meet-only-at-the-event"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |->
    With[ { r = $lightConeReading[ g, v ] },
      Sort @ r[ "FutureLightCone" ] === Sort @ $lightCone[ g, v ] &&
      Sort @ r[ "PastLightCone" ] === Sort @ $lightCone[ ReverseGraph @ g, v ] &&
      SubsetQ[ r[ "Future" ], r[ "FutureLightCone" ] ] && SubsetQ[ r[ "Past" ], r[ "PastLightCone" ] ] ] ] ],
  True,
  TestID -> "LightConeViewer-Fixtures-reading-light-cones-are-the-events-with-chain-diamonds"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |->
    With[ { r = $lightConeReading[ g, v ] },
      r[ "FutureRays" ] == Count[ r[ "FutureLightCone" ], w_ /; ! IntersectingQ[ DeleteCases[ $future[ g, w ], w ], r[ "FutureLightCone" ] ] ] &&
      r[ "PastRays" ] == Count[ r[ "PastLightCone" ], w_ /; ! IntersectingQ[ DeleteCases[ VertexInComponent[ g, { w } ], w ], r[ "PastLightCone" ] ] ] ] ] ],
  True,
  TestID -> "LightConeViewer-Fixtures-reading-rays-count-the-extremal-events-of-the-light-cone"
]

VerificationTest[
  Map[ v |-> $lightConeReading[ $diamond, v ][ "FutureRays" ], { { 0, 0 }, { 1, 1 }, { 3, 0 }, { 3, 3 } } ],
  { 2, 2, 1, 1 },
  TestID -> "LightConeViewer-Diamond-reading-two-null-rays-off-the-boundary"
]

VerificationTest[
  AllTrue[ $observerPairs, case |-> With[ { g = case[[ 1 ]], a = case[[ 2 ]], b = case[[ 3 ]] },
    With[ { relation = InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ] },
      AllTrue[ a, v |-> With[ { r = $messageReading[ g, a, b, v ] },
        r[ "Images" ] === relation[ v ] && SubsetQ[ b, r[ "Images" ] ] &&
        Last /@ r[ "Rays" ] === r[ "Images" ] && AllTrue[ r[ "Rays" ], ray |-> First @ ray === v ] ] ] ] ] ],
  True,
  TestID -> "MessageFunctionViewer-Observers-reading-images-are-the-message-relation"
]

VerificationTest[
  AllTrue[ $observerPairs, case |-> With[ { g = case[[ 1 ]], a = case[[ 2 ]], b = case[[ 3 ]] },
    AllTrue[ a, v |-> AllTrue[ $messageReading[ g, a, b, v ][ "Rays" ], ray |->
      InfraLightRayQ[ g, ray ] && SubsetQ[ $lightCone[ g, v ], ray ] &&
      Length @ ray == Length @ Intersection[ $future[ g, v ], VertexInComponent[ g, { Last @ ray } ] ] ] ] ] ],
  True,
  TestID -> "MessageFunctionViewer-Observers-reading-rays-are-light-rays-filling-their-diamond"
]

VerificationTest[
  Map[ v |-> $messageReading[ $diamond, $column[ $diamond, 0 ], $column[ $diamond, 2 ], v ][ "Images" ], $column[ $diamond, 0 ] ],
  { { { 2, 0 } }, { { 2, 1 } }, { { 2, 2 } }, { { 2, 3 } } },
  TestID -> "MessageFunctionViewer-Diamond-reading-null-columns-message-straight-across"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> With[ { t = UniversalTime @ g }, AllTrue[ Range[ 0, Max @ t ], k |->
    With[ { r = $foliationReading[ g, k ] },
      Sort @ Join[ r[ "Slice" ], r[ "Earlier" ] ] === Sort @ Keys @ Select[ t, # <= k & ] &&
      ! IntersectingQ[ r[ "Slice" ], r[ "Earlier" ] ] &&
      InfraAntichainQ[ g, r[ "Slice" ] ] && AllTrue[ r[ "Earlier" ], u |-> t[ u ] < k ] ] ] ] ],
  True,
  TestID -> "FoliationViewer-Fixtures-reading-slice-over-earlier-band-partitions-the-past"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> With[ { t = UniversalTime @ g }, AllTrue[ Range[ 1, Max @ t ], k |->
    With[ { r = $foliationReading[ g, k ] },
      AllTrue[ r[ "Slice" ], w |-> AnyTrue[ VertexInComponent[ g, { w }, 1 ], u |-> t[ u ] == k - 1 ] &&
        SubsetQ[ r[ "Earlier" ], DeleteCases[ VertexInComponent[ g, { w } ], w ] ] ] ] ] ] ],
  True,
  TestID -> "FoliationViewer-Fixtures-reading-slice-events-have-their-strict-past-earlier-and-a-parent-one-below"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> Total[ Length[ $foliationReading[ g, # ][ "Slice" ] ] & /@ Range[ 0, Max @ UniversalTime @ g ] ] == VertexCount @ g ],
  True,
  TestID -> "FoliationViewer-Fixtures-reading-slices-exhaust-the-events"
]

EndTestSection[]
