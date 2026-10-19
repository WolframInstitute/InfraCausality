BeginTestSection["EPSDefects"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$lattice = n |-> Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= n & ],
  { i, 0, n }, { j, 0, n } ] ];

$g = $lattice[ 9 ];

$diagonal = Table[ { m, m }, { m, 0, 9 } ];

$parallel = Table[ { m, m + 2 }, { m, 0, 7 } ];

$staircase = Append[ Catenate @ Table[ { { i, i }, { i + 1, i } }, { i, 0, 8 } ], { 9, 9 } ];

$staircaseShifted = Select[ ( # + { 0, 2 } ) & /@ $staircase, Max @ # <= 9 & ];

$moving = p |-> Table[ { ( p + 1 ) m, p m }, { m, 1, Floor[ 9 / ( p + 1 ) ] } ];

$defects = { "DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect" };

$read = { g, head } |-> ( InfraMeasurement[ g, head, # ] & /@ $defects );

$readInterior = { g, head, k } |-> ( InfraMeasurement[ g, head, #, "Margin" -> k ] & /@ $defects );

$orderDefect = { relation, order } |-> With[ { position = AssociationThread[ order, Range @ Length @ order ] },
  { images = Lookup[ position, Key /@ # ] & /@ Values @ relation },
  Count[ Subsets[ Range @ Length @ images, { 2 } ], { i_, j_ } /; images[[ i ]] =!= { } && images[[ j ]] =!= { } && Max @ images[[ i ]] > Min @ images[[ j ]] ] /
    Binomial[ Length @ images, 2 ] ];

$velocity = { c, p, q } |-> ( c[ q ][[ 1 ]] - c[ p ][[ 1 ]] ) / ( c[ q ][[ 2 ]] - c[ p ][[ 2 ]] );

$target = { g, c, p, v, width } |-> First @ MaximalBy[
  Select[ DeleteCases[ VertexOutComponent[ g, { p } ], p ], q |-> Abs[ $velocity[ c, p, q ] - v ] < width ],
  q |-> c[ q ][[ 2 ]] ];

$sprinklingPair = seed |-> With[ { g = ( SeedRandom[ seed ]; RandomCausalGraph[ 400, Method -> { "Sprinkling", 2 } ] ) },
  { c = AssociationThread[ VertexList @ g, GraphEmbedding @ g ] },
  { early = TakeSmallestBy[ VertexList @ g, v |-> c[ v ][[ 2 ]], 6 ] },
  { pa = First @ early },
  { pb = First[ Select[ Rest @ early, p |-> ! MemberQ[ VertexOutComponent[ g, { pa } ], p ] && ! MemberQ[ VertexInComponent[ g, { pa } ], p ] ], early[[ 2 ]] ] },
  { qa = $target[ g, c, pa, 0, 0.05 ], qb = $target[ g, c, pb, 0.35, 0.05 ] },
  { va = $velocity[ c, pa, qa ], vb = $velocity[ c, pb, qb ] },
  { a = ( SeedRandom[ seed ]; RandomInfraTimelikeGeodesic[ g, pa, qa ] ), b = RandomInfraTimelikeGeodesic[ g, pb, qb ] },
  { g, a, b, ( vb - va ) / ( 1 - va vb ) } ];

VerificationTest[
  Normal @ InfraMeasurement[ $g, InfraMessageFunction[ $diagonal, $parallel ], "Relation" ],
  Join[ Table[ { m, m } -> { { m, m + 2 } }, { m, 0, 7 } ], Table[ { m, m } -> { }, { m, 8, 9 } ] ],
  TestID -> "EPSDefects-diagonal-chains-message-relation-is-the-parallel-shift"
]

VerificationTest[
  { $readInterior[ $g, InfraMessageFunction[ $diagonal, $parallel ], 2 ], $readInterior[ $g, InfraMessageFunction[ $parallel, $diagonal ], 2 ],
    $readInterior[ $g, InfraEchoFunction[ $diagonal, $parallel ], 2 ], $readInterior[ $g, InfraEchoFunction[ $parallel, $diagonal ], 2 ] },
  ConstantArray[ { 0, 0, 0, 0 }, 4 ],
  TestID -> "EPSDefects-diagonal-chains-all-message-and-echo-defects-vanish-on-the-interior-window"
]

VerificationTest[
  InfraMeasurement[ $g, #, "KFactor", "Margin" -> 2 ] & /@
    { InfraMessageFunction[ $diagonal, $parallel ], InfraMessageFunction[ $parallel, $diagonal ], InfraEchoFunction[ $diagonal, $parallel ], InfraEchoFunction[ $parallel, $diagonal ] },
  { 1, 1, 1, 1 },
  TestID -> "EPSDefects-diagonal-chains-k-factor-one-for-messages-both-ways-and-echoes"
]

VerificationTest[
  { $read[ $g, InfraMessageFunction[ $diagonal, $parallel ] ], $read[ $g, InfraMessageFunction[ $parallel, $diagonal ] ],
    $read[ $g, InfraEchoFunction[ $diagonal, $parallel ] ], $read[ $g, InfraEchoFunction[ $parallel, $diagonal ] ] },
  { { 1 / 5, 0, 1 / 5, 0 }, { 0, 0, 0, 0 }, { 1 / 5, 0, 1 / 5, 0 }, { 1 / 4, 0, 1 / 4, 0 } },
  TestID -> "EPSDefects-diagonal-chains-without-margin-only-the-rays-leaving-the-lattice-fail"
]

VerificationTest[
  AllTrue[ $defects, d |-> AllTrue[ Range[ 0, 4 ], k |->
    InfraMeasurement[ $g, InfraMessageFunction[ $staircase, $staircaseShifted ], d, "Margin" -> k ] ===
      InfraMeasurement[ $g, InfraMessageFunction[ $staircase[[ k + 1 ;; -k - 1 ]], $staircaseShifted ], d ] ] ],
  True,
  TestID -> "EPSDefects-margin-drops-ticks-at-both-ends-of-the-first-observer"
]

VerificationTest[
  { $readInterior[ $g, InfraMessageFunction[ $staircase, $staircaseShifted ], 4 ], $readInterior[ $g, InfraMessageFunction[ $staircaseShifted, $staircase ], 2 ] },
  { { 0, 1 / 2, 0, 1 / 11 }, { 0, 1 / 2, 0, 1 / 11 } },
  TestID -> "EPSDefects-shifted-staircases-function-defect-one-half-on-the-interior-window"
]

VerificationTest[
  With[ { relation = InfraMeasurement[ $g, InfraMessageFunction[ $staircase[[ 5 ;; -5 ]], $staircaseShifted ], "Relation" ],
          position = AssociationThread[ $staircaseShifted, Range @ Length @ $staircaseShifted ] },
    { AllTrue[ Values @ relation, Length @ # == 2 & ],
      AllTrue[ Partition[ Values @ relation, 2, 1 ], Apply[ { earlier, later } |-> earlier === later || position @ Last @ earlier < position @ First @ later ] ],
      $orderDefect[ relation, $staircaseShifted ],
      Count[ Partition[ Values @ relation, 2, 1 ], { same_, same_ } ] / Binomial[ Length @ relation, 2 ] } ],
  { True, True, 1 / 11, 1 / 11 },
  TestID -> "EPSDefects-shifted-staircases-order-defect-counts-the-consecutive-ticks-with-equal-images"
]

VerificationTest[
  AllTrue[ { { $staircase, $staircaseShifted }, { $staircaseShifted, $staircase }, { $diagonal, $parallel }, { $parallel, $diagonal } }, Apply[ { a, b } |->
    InfraMeasurement[ $g, InfraMessageFunction[ a, b ], "OrderDefect" ] == $orderDefect[ InfraMeasurement[ $g, InfraMessageFunction[ a, b ], "Relation" ], b ] &&
      InfraMeasurement[ $g, InfraEchoFunction[ a, b ], "OrderDefect" ] == $orderDefect[ InfraMeasurement[ $g, InfraEchoFunction[ a, b ], "Relation" ], a ] ] ],
  True,
  TestID -> "EPSDefects-order-defect-equals-the-brute-force-count-over-ordered-tick-pairs"
]

VerificationTest[
  With[ { relation = InfraMeasurement[ $g, InfraMessageFunction[ $staircase[[ 5 ;; -5 ]], $staircaseShifted ], "Relation" ],
          position = AssociationThread[ $staircaseShifted, Range @ Length @ $staircaseShifted ] },
    InfraMeasurement[ $g, InfraMessageFunction[ $staircase, $staircaseShifted ], "KFactor", "Margin" -> 4 ] ==
      ( position @ First @ Last @ relation - position @ First @ First @ relation ) / ( Length @ relation - 1 ) ],
  True,
  TestID -> "EPSDefects-k-factor-is-the-earliest-image-span-ratio-where-every-tick-has-a-message"
]

VerificationTest[
  { $read[ $g, InfraMessageFunction[ Take[ $diagonal, -5 ], Take[ $diagonal, 5 ] ] ], $read[ $g, InfraEchoFunction[ Take[ $diagonal, -5 ], Take[ $diagonal, 5 ] ] ] },
  { { 1, 0, 1, 0 }, { 1, 0, 1, 0 } },
  TestID -> "EPSDefects-chain-against-a-chain-in-its-past-has-domain-defect-one"
]

VerificationTest[
  Table[
    With[ { v = 1 / ( 2 p + 1 ) },
      { InfraMeasurement[ $g, InfraEchoFunction[ $diagonal, $moving @ p ], "KFactor" ] == Sqrt[ ( 1 + v ) / ( 1 - v ) ],
        InfraMeasurement[ $g, InfraMessageFunction[ $diagonal, $moving @ p ], "KFactor" ] == 1 / p,
        InfraMeasurement[ $g, InfraMessageFunction[ $moving @ p, $diagonal ], "KFactor" ] == p + 1 } ],
    { p, 3 } ],
  ConstantArray[ { True, True, True }, 3 ],
  TestID -> "EPSDefects-lattice-echo-k-factor-is-the-Bondi-factor-at-velocity-1-over-2p-plus-1"
]

VerificationTest[
  With[ { pairs = Table[ $sprinklingPair @ seed, { seed, 10 } ] },
    { ratios = Select[ Apply[ { g, a, b, v } |-> InfraMeasurement[ g, InfraEchoFunction[ a, b ], "KFactor" ] / Sqrt[ ( 1 + v ) / ( 1 - v ) ] ] /@ pairs, NumericQ ] },
    { AllTrue[ pairs, 0.2 <= Last @ # <= 0.5 & ], Length @ ratios >= 8, Abs[ Exp @ Mean @ Log @ ratios - 1 ] < 0.25 } ],
  { True, True, True },
  TestID -> "EPSDefects-sprinkling-echo-k-factor-within-25-percent-of-the-Bondi-factor-over-ten-seeds"
]

VerificationTest[
  With[ { pairs = Table[ $sprinklingPair @ seed, { seed, 3 } ] },
    AllTrue[ pairs, Apply[ { g, a, b, v } |-> AllTrue[ { InfraMessageFunction[ a, b ], InfraMessageFunction[ b, a ], InfraEchoFunction[ a, b ] }, head |->
      With[ { defects = $read[ g, head ] },
        AllTrue[ defects, 0 <= # <= 1 & ] && defects[[ 3 ]] >= defects[[ 1 ]] ] ] ] ] ],
  True,
  TestID -> "EPSDefects-sprinkling-defects-lie-in-the-unit-interval-and-injectivity-dominates-domain"
]

EndTestSection[]
