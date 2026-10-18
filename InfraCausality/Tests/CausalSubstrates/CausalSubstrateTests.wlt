BeginTestSection["CausalSubstrate"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$small = AssociationMap[ CausalSubstrate[ #, "Small" ] &, CausalSubstrate[ All ] ];

$future = { g, v } |-> Sort @ VertexOutComponent[ g, { v } ];

$minkowskiQ = { g, closed } |-> With[ { c = AssociationThread[ VertexList @ g, GraphEmbedding @ g ], d = GraphDistanceMatrix @ g,
    index = AssociationThread[ VertexList @ g, Range @ VertexCount @ g ] },
  AllTrue[ Permutations[ VertexList @ g, { 2 } ], p |-> With[ { dt = Last @ c[ Last @ p ] - Last @ c[ First @ p ], dx = Norm[ Most @ c[ Last @ p ] - Most @ c[ First @ p ] ] },
    ( d[[ index[ First @ p ], index[ Last @ p ] ]] < Infinity ) == If[ closed, dt >= dx, dt > dx ] ] ] ];

$width = g |-> VertexCount @ g - Length @ FindIndependentEdgeSet @ Graph[ UndirectedEdge[ { 1, First @ # }, { 2, Last @ # } ] & /@ EdgeList @ TransitiveClosureGraph @ g ];

VerificationTest[
  AllTrue[ $small, g |-> DirectedGraphQ @ g && AcyclicGraphQ @ g ],
  True,
  TestID -> "CausalSubstrate-all-small-directed-acyclic"
]

VerificationTest[
  AllTrue[ $small, g |-> EdgeCount @ g == EdgeCount @ TransitiveReductionGraph @ g ],
  True,
  TestID -> "CausalSubstrate-all-small-transitively-reduced"
]

VerificationTest[
  AllTrue[ $small, g |-> ConnectedGraphQ @ UndirectedGraph @ g ],
  True,
  TestID -> "CausalSubstrate-all-small-weakly-connected"
]

VerificationTest[
  AllTrue[ $small, g |-> With[ { y = AssociationThread[ VertexList @ g, Last /@ GraphEmbedding @ g ] },
    AllTrue[ EdgeList @ g, e |-> y[ Last @ e ] > y[ First @ e ] ] ] ],
  True,
  TestID -> "CausalSubstrate-all-small-time-upward-in-default-layout"
]

VerificationTest[
  AllTrue[ CausalSubstrate[ All ], name |-> With[ { g = $small[ name ], h = ReleaseHold @ CausalSubstrateCode[ name, "Small" ] },
    VertexList @ g === VertexList @ h && EdgeList @ g === EdgeList @ h ] ],
  True,
  TestID -> "CausalSubstrate-all-small-code-builds-the-substrate"
]

VerificationTest[
  VertexCount @ CausalSubstrate[ "DiamondLatticeGraph", # ] & /@ { "Small", "Medium", "Large", 3 },
  ( # + 1 )^2 & /@ { 6, 10, 16, 3 },
  TestID -> "CausalSubstrate-DiamondLatticeGraph-vertex-count-n-plus-one-squared"
]

VerificationTest[
  With[ { g = $small[ "DiamondLatticeGraph" ] },
    AllTrue[ VertexList @ g, v |-> VertexInDegree[ g, v ] == Boole[ First @ v > 0 ] + Boole[ Last @ v > 0 ] <= 2 ] ],
  True,
  TestID -> "CausalSubstrate-DiamondLatticeGraph-in-degree-at-most-two"
]

VerificationTest[
  With[ { g = $small[ "DiamondLatticeGraph" ] },
    AllTrue[ VertexList @ g, v |-> $future[ g, v ] === Sort @ Select[ VertexList @ g, w |-> And @@ Thread[ v <= w ] ] ] ],
  True,
  TestID -> "CausalSubstrate-DiamondLatticeGraph-causal-order-is-the-product-order"
]

VerificationTest[
  $minkowskiQ[ CausalSubstrate[ "DiamondLatticeGraph", "Small", "KeepCoordinates" -> True ], True ],
  True,
  TestID -> "CausalSubstrate-DiamondLatticeGraph-order-is-the-closed-light-cone-on-the-coordinates"
]

VerificationTest[
  With[ { g = $small[ "CylinderLatticeGraph" ] },
    { Union[ VertexInDegree[ g, # ] & /@ Select[ VertexList @ g, v |-> Last @ v > 0 ] ],
      Union[ VertexInDegree[ g, # ] & /@ Select[ VertexList @ g, v |-> Last @ v == 0 ] ],
      CausalHeight[ g ] === AssociationMap[ Last, VertexList @ g ] } ],
  { { 2 }, { 0 }, True },
  TestID -> "CausalSubstrate-CylinderLatticeGraph-in-degree-two-off-the-bottom-row-and-rows-are-slices"
]

VerificationTest[
  AllTrue[ { 2, 3, 4, 6 }, n |-> With[ { g = CausalSubstrate[ "CylinderLatticeGraph", n ], h = CausalSubstrate[ "CylinderLatticeGraph", { n, n } ] },
      VertexCount @ g == n ( n + 1 ) && EdgeCount @ g == 2 n^2 && VertexList @ g === VertexList @ h && EdgeList @ g === EdgeList @ h &&
        CausalHeight[ g ] === AssociationMap[ Last, VertexList @ g ] ] ] &&
    EdgeList @ CausalSubstrate[ "CylinderLatticeGraph", 6 ] === EdgeList @ $small[ "CylinderLatticeGraph" ],
  True,
  TestID -> "CausalSubstrate-CylinderLatticeGraph-integer-size-n-is-the-n-by-n-cylinder"
]

VerificationTest[
  With[ { g = $small[ "CubicLatticeGraph" ] },
    { VertexCount @ g, AllTrue[ VertexList @ g, v |-> $future[ g, v ] === Sort @ Select[ VertexList @ g, w |-> And @@ Thread[ v <= w ] ] ] } ],
  { 64, True },
  TestID -> "CausalSubstrate-CubicLatticeGraph-causal-order-is-the-product-order"
]

VerificationTest[
  $minkowskiQ[ CausalSubstrate[ #, "Small", "KeepCoordinates" -> True ], False ] & /@ { "MinkowskiSprinkling2D", "MinkowskiSprinkling3D" },
  { True, True },
  TestID -> "CausalSubstrate-MinkowskiSprinkling-order-is-the-light-cone-order-on-the-coordinates"
]

VerificationTest[
  Table[ With[ { g = CausalSubstrate[ name, size ] },
      { VertexCount @ g, VertexList @ g === Range @ VertexCount @ g && AllTrue[ EdgeList @ g, e |-> First @ e < Last @ e ] } ],
    { name, { "MinkowskiSprinkling2D", "PercolationGraph" } }, { size, { "Small", "Medium" } } ],
  { { { 25, True }, { 50, True } }, { { 25, True }, { 50, True } } },
  TestID -> "CausalSubstrate-Sprinkling-Percolation-events-one-to-n-in-topological-order"
]

VerificationTest[
  AllTrue[ { "SquareTilingSprayGraph", "HexagonalTilingSprayGraph", "SquareMeshSprayGraph" }, name |->
    With[ { s = InfraSubstrate[ StringReplace[ name, "SprayGraph" -> "Graph" ], "Small" ], g = $small[ name ] },
      { c = First @ GraphCenter @ s },
      CausalHeight[ g ] === AssociationMap[ v |-> GraphDistance[ s, c, v ], VertexList @ g ] ] ],
  True,
  TestID -> "CausalSubstrate-Spray-causal-height-is-the-distance-from-the-centre"
]

VerificationTest[
  Keys @ CausalSubstrate[ ],
  { "Lattice", "Sprinkling", "Spray", "Random", "WolframModel" },
  TestID -> "CausalSubstrate-five-groups"
]

VerificationTest[
  Map[ name |-> With[ { g = $small[ name ] },
      { VertexCount @ g, EdgeCount @ g, AcyclicGraphQ @ g && EdgeCount @ g == EdgeCount @ TransitiveReductionGraph @ g && WeaklyConnectedGraphQ @ g } ],
    CausalSubstrate[ ][ "WolframModel" ] ],
  { { 100, 194, True }, { 100, 183, True }, { 100, 193, True }, { 100, 151, True }, { 100, 123, True }, { 100, 108, True } },
  TestID -> "CausalSubstrate-WolframModel-small-hasse-diagrams-with-literal-counts"
]

VerificationTest[
  AllTrue[ Transpose[ { CausalSubstrate[ ][ "WolframModel" ], { 100, 100, 100, 100, 100, 100 } } ], p |->
    Abs[ VertexCount @ $small[ First @ p ] - Last @ p ] <= Last @ p / 20 ],
  True,
  TestID -> "CausalSubstrate-WolframModel-small-event-count-within-five-percent-of-the-budget"
]

VerificationTest[
  Table[ With[ { g = CausalSubstrate[ name, size ] },
      { VertexCount @ g, Sort @ VertexList @ g === Range @ VertexCount @ g && AllTrue[ EdgeList @ g, e |-> First @ e < Last @ e ] } ],
    { name, { "wm3467", "wm1529" } }, { size, { "Medium", "Large" } } ],
  { { { 300, True }, { 800, True } }, { { 300, True }, { 700, True } } },
  TestID -> "CausalSubstrate-WolframModel-events-numbered-by-a-linear-extension"
]

VerificationTest[
  Map[ name |-> With[ { w = $width /@ ( CausalSubstrate[ name, # ] & /@ { "Small", "Medium", "Large" } ) },
      { First @ w >= 3, Less @@ w, First @ w >= Max[ Length /@ CausalHeightFoliation @ $small[ name ] ] } ],
    { "wm7978", "wm4735" } ],
  { { True, True, True }, { True, True, True } },
  TestID -> "CausalSubstrate-WolframModel-wm7978-wm4735-antichain-width-at-least-three-and-growing"
]

VerificationTest[
  With[ { h = ReleaseHold @ CausalSubstrateCode[ "wm3467", "Small" ],
      entry = Import[ PacletObject[ "WolframInstitute/InfraCausality" ][ "AssetLocation", "WolframModelCausalGraphs" ] ][ "wm3467" ][ "Small" ] },
    Sort @ EdgeList @ h === Sort @ entry && Sort @ VertexList @ h === Union @ Flatten[ List @@@ entry ] ],
  True,
  TestID -> "CausalSubstrate-wm3467-small-code-equals-the-bundled-entry"
]

VerificationTest[
  AllTrue[ { "Small", "Medium", "Large" }, size |-> With[ { style = CausalSubstrateStyle[ size ] },
    ListQ @ style && MatchQ[ style, { ( _Rule | _RuleDelayed ) .. } ] && SubsetQ[ Keys @ Options @ Graph, Keys @ style ] &&
      style === CausalSubstrateStyle[ "DiamondLatticeGraph", size ] ] ],
  True,
  TestID -> "CausalSubstrateStyle-all-sizes-graph-option-rules"
]

EndTestSection[]
