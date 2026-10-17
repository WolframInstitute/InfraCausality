BeginTestSection["RandomCausalGraph"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$orderedQ = g |-> VertexList @ g === Range @ VertexCount @ g && AllTrue[ EdgeList @ g, e |-> First @ e < Last @ e ];

$reducedQ = g |-> EdgeCount @ g == EdgeCount @ TransitiveReductionGraph @ g;

$minkowskiQ = g |-> With[ { c = AssociationThread[ VertexList @ g, GraphEmbedding @ g ], d = GraphDistanceMatrix @ g },
  AllTrue[ Permutations[ VertexList @ g, { 2 } ], p |->
    ( d[[ First @ p, Last @ p ]] < Infinity ) == ( Last @ c[ Last @ p ] - Last @ c[ First @ p ] > Norm[ Most @ c[ Last @ p ] - Most @ c[ First @ p ] ] ) ] ];

VerificationTest[
  AllTrue[ { { 20, 0.1 }, { 20, 0.3 }, { 40, 0.05 } }, spec |-> AllTrue[ Range[ 3 ], seed |->
    With[ { g = BlockRandom[ SeedRandom[ seed ]; RandomCausalGraph[ spec ] ] }, AcyclicGraphQ @ g && $orderedQ @ g && $reducedQ @ g ] ] ],
  True,
  TestID -> "RandomCausalGraph-percolation-acyclic-topological-labels-transitively-reduced"
]

VerificationTest[
  { EdgeList @ RandomCausalGraph[ { 6, 1 - 10^-12 } ], EdgeCount @ RandomCausalGraph[ { 6, 10.^-12 } ] },
  { DirectedEdge @@@ Partition[ Range[ 6 ], 2, 1 ], 0 },
  TestID -> "RandomCausalGraph-percolation-extremes-chain-and-antichain"
]

VerificationTest[
  BlockRandom[ SeedRandom[ 7 ]; With[ { gs = Table[ RandomCausalGraph[ { 5, 0.3 } ], 2000 ] },
    { Abs[ Mean[ Boole[ GraphDistance[ #, 1, 2 ] < Infinity ] & /@ gs ] - 0.3 ] < 0.04,
      Abs[ Mean[ Boole[ GraphDistance[ #, 1, 3 ] < Infinity ] & /@ gs ] - ( 1 - ( 1 - 0.3 ) ( 1 - 0.3^2 ) ) ] < 0.04 } ] ],
  { True, True },
  TestID -> "RandomCausalGraph-percolation-relation-probabilities-p-and-1-(1-p)(1-p^2)"
]

VerificationTest[
  AllTrue[ { { 12, 20 }, { 25, 50 } }, spec |-> AllTrue[ Range[ 3 ], seed |->
    With[ { g = BlockRandom[ SeedRandom[ seed ]; RandomCausalGraph[ spec ] ] },
      VertexCount @ g == First @ spec && AcyclicGraphQ @ g && ConnectedGraphQ @ UndirectedGraph @ g && $orderedQ @ g && $reducedQ @ g ] ] ],
  True,
  TestID -> "RandomCausalGraph-orientation-connected-acyclic-transitively-reduced"
]

VerificationTest[
  AllTrue[ Range[ 3 ], seed |-> With[ { g = BlockRandom[ SeedRandom[ seed ]; RandomCausalGraph[ 30 ] ] },
    VertexCount @ g == 30 && AcyclicGraphQ @ g && $orderedQ @ g && $reducedQ @ g ] ],
  True,
  TestID -> "RandomCausalGraph-default-percolation-acyclic-topological-labels-transitively-reduced"
]

VerificationTest[
  AllTrue[ { 2, 3 }, d |-> AllTrue[ Range[ 2 ], seed |->
    With[ { g = BlockRandom[ SeedRandom[ seed ]; RandomCausalGraph[ 30, Method -> { "Sprinkling", d } ] ] },
      $orderedQ @ g && $reducedQ @ g && $minkowskiQ @ g ] ] ],
  True,
  TestID -> "RandomCausalGraph-sprinkling-order-is-the-light-cone-order-on-the-coordinates"
]

VerificationTest[
  AllTrue[ { 2, 3 }, d |-> With[ { c = GraphEmbedding @ BlockRandom[ SeedRandom[ 1 ]; RandomCausalGraph[ 40, Method -> { "Sprinkling", d } ] ] },
    OrderedQ[ Last /@ c ] && AllTrue[ c, p |-> Norm[ Most @ p ] < Last @ p < 1 - Norm[ Most @ p ] ] ] ],
  True,
  TestID -> "RandomCausalGraph-sprinkling-points-in-the-unit-diamond-labelled-by-time"
]

VerificationTest[
  BlockRandom[ SeedRandom[ 3 ]; Abs[ Mean[ Last /@ GraphEmbedding @ RandomCausalGraph[ 200, Method -> "Sprinkling" ] ] - 1 / 2 ] < 0.05 ],
  True,
  TestID -> "RandomCausalGraph-sprinkling-mean-time-one-half"
]

VerificationTest[
  ( SeedRandom[ 5 ]; EdgeList @ RandomCausalGraph[ 15 ] ) === ( SeedRandom[ 5 ]; EdgeList @ RandomCausalGraph[ 15 ] ),
  True,
  TestID -> "RandomCausalGraph-seed-reproducible"
]

EndTestSection[]
