BeginTestSection[ "BondiFigures" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$initialValues = m |-> Cases[ m, { { s_Symbol, init_, _ }, ___ } :> ( s -> init ) ]

$constructionFrame = { m, name } |-> ReleaseHold[ Extract[ m, 1, Hold ] /. Prepend[ $initialValues[ m ], Extract[ m, { 2, 1, 1 } ] -> name ] ]

$grid = Tuples[ { { 0, 0.2, 0.5, 0.8, 3/5 }, { 0.3, Pi/4, 1.2 } } ]

$movingGrid = Select[ $grid, vp |-> vp[[ 1 ]] != 0 ]

$near = { x, y } |-> Max[ Abs[ N[ x - y ] ] ] < 10^-9

$onWorldline = { point, v, phi } |-> N[ point[[ 1 ]] ] > 0 && $near[ point, Norm[ point ] Through[ { Sin, Cos }[ WorldlineAngle[ v, phi ] ] ] ]

$disks = g |-> Cases[ g, Disk[ c_, _ ] :> c, Infinity ]

$radarMidpoint = { point, v, phi } |-> With[ { d = Through[ { Sin, Cos }[ WorldlineAngle[ v, phi ] ] ] },
  Mean[ Map[ right |-> First @ LinearSolve[ Transpose[ { d, { If[ right, 1, -1 ] Sin[ phi ], Cos[ phi ] } } ], point ], { True, False } ] ] ]

VerificationTest[
  With[ { m = BondiViewer[] },
    { Head @ m, Map[ name |-> Head @ $constructionFrame[ m, name ], Extract[ m, { 2, 2 } ] ] } ],
  { Manipulate, ConstantArray[ Graphics, 7 ] },
  TestID -> "BondiViewer-Initial-state-every-construction-draws"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> BondiClock[ vp[[ 1 ]], 8, "LightAngle" -> vp[[ 2 ]], "ShowTickLabels" -> True, "ShowEventLabels" -> True ], $grid ], BondiClock[ 0.4 ] ] ],
  { Graphics },
  TestID -> "BondiClock-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> DopplerConstruction[ vp[[ 1 ]], 6, "LightAngle" -> vp[[ 2 ]] ], $grid ], DopplerConstruction[ 0.4 ] ] ],
  { Graphics },
  TestID -> "DopplerConstruction-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> TimeDilationConstruction[ vp[[ 1 ]], "LightAngle" -> vp[[ 2 ]] ], $grid ], TimeDilationConstruction[ 0.4 ] ] ],
  { Graphics },
  TestID -> "TimeDilationConstruction-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> SimultaneityConstruction[ vp[[ 1 ]], "LightAngle" -> vp[[ 2 ]] ], $grid ], SimultaneityConstruction[ 0.4 ] ] ],
  { Graphics },
  TestID -> "SimultaneityConstruction-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> LengthContractionConstruction[ vp[[ 1 ]], "LightAngle" -> vp[[ 2 ]] ], $grid ], LengthContractionConstruction[ 0.4 ] ] ],
  { Graphics },
  TestID -> "LengthContractionConstruction-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> VelocityAdditionConstruction[ vp[[ 1 ]], 0.3, "LightAngle" -> vp[[ 2 ]] ], $grid ], VelocityAdditionConstruction[ 0.4, 0.3 ] ] ],
  { Graphics },
  TestID -> "VelocityAdditionConstruction-draws-on-grid"
]

VerificationTest[
  Union @ Map[ Head, Prepend[ Map[ vp |-> LightClockConstruction[ vp[[ 1 ]], 8, "LightAngle" -> vp[[ 2 ]] ], $grid ], LightClockConstruction[ 0.4 ] ] ],
  { Graphics },
  TestID -> "LightClockConstruction-draws-on-grid"
]

VerificationTest[
  AllTrue[ $movingGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { bob = Select[ $disks @ BondiClock[ v, 8, "LightAngle" -> phi ], c |-> N[ c[[ 1 ]] ] > 0 ] },
    Length[ bob ] == 4 && AllTrue[ bob, c |-> $onWorldline[ c, v, phi ] ] &&
      $near[ Ratios[ Map[ Norm, bob ] ], ConstantArray[ KFactor[ v, phi ]^2, 3 ] ] ] ],
  True,
  TestID -> "BondiClock-reflections-on-moving-worldline-grow-by-k-squared"
]

VerificationTest[
  AllTrue[ $movingGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { disks = $disks @ DopplerConstruction[ v, 6, "LightAngle" -> phi ] },
    { alice = Select[ disks, c |-> N[ c[[ 1 ]] ] == 0 ],
      bob = Select[ disks, c |-> N[ c[[ 1 ]] ] > 0 ] },
    Length[ bob ] == 6 && AllTrue[ bob, c |-> $onWorldline[ c, v, phi ] ] &&
      $near[ Differences[ ProperTimeScale[ v, phi ] Map[ Norm, bob ] ], KFactor[ v, phi ] Differences[ alice[[ All, 2 ]] ] ] ] ],
  True,
  TestID -> "DopplerConstruction-receptions-on-moving-worldline-spaced-by-k"
]

$ticks = { g, v, phi } |-> Sort @ Map[ Norm, Select[
  Map[ pq |-> Mean[ pq ], Select[ Cases[ g, Line[ pq : { _, _ } ] :> pq, Infinity ],
    pq |-> Abs[ N[ ( pq[[ 2 ]] - pq[[ 1 ]] ) . Through[ { Sin, Cos }[ WorldlineAngle[ v, phi ] ] ] ] ] < 10^-9 ] ],
  mid |-> If[ v == 0, Abs[ N @ First @ mid ] < 10^-9 && N[ Last @ mid ] > 0, $onWorldline[ mid, v, phi ] ] ] ]

$drawnLength = { g, v, phi } |-> Max @ Map[ Norm, Select[ Cases[ g, Line[ { { 0 | 0., 0 | 0. }, q_ } ] :> q, Infinity ],
  q |-> If[ v == 0, Abs[ N @ First @ q ] < 10^-9, $onWorldline[ q, v, phi ] ] ] ]

$wideGrid = Join[ $movingGrid, { { 0.9, 1.3 }, { 0.95, Pi/4 } } ]

VerificationTest[
  AllTrue[ $movingGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { taus = ProperTimeScale[ v, phi ] $ticks[ TimeDilationConstruction[ v, "LightAngle" -> phi ], v, phi ] },
    Length[ taus ] >= 4 && $near[ taus / First[ taus ], Range @ Length @ taus ] &&
      $near[ taus[[ 4 ]], ProperTimeScale[ v, phi ] 0.6 ] ] ],
  True,
  TestID -> "TimeDilationConstruction-ticks-at-equal-proper-time-steps-event-at-the-fourth"
]

VerificationTest[
  AllTrue[ $wideGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { g = TimeDilationConstruction[ v, "LightAngle" -> phi ] },
    { event = First @ Select[ $disks @ g, c |-> N[ c[[ 1 ]] ] > 0 ],
      now = First @ Cases[ g, { Dashed, ___, Line[ pts_ ] } :> pts, Infinity ] },
    Max[ $ticks[ g, v, phi ] ] <= $drawnLength[ g, v, phi ] &&
      Max[ $ticks[ g, 0, phi ] ] <= $drawnLength[ g, 0, phi ] &&
      Norm[ event ] <= $drawnLength[ g, v, phi ] &&
      $near[ First @ now, { 0, Last @ event } ] &&
      N[ First @ Last @ now ] > N[ First @ event ] && $near[ Last @ Last @ now, Last @ event ] ] ],
  True,
  TestID -> "TimeDilationConstruction-ticks-on-the-drawn-worldlines-and-now-line-reaches-the-event"
]

VerificationTest[
  AllTrue[ $grid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { lines = Cases[ SimultaneityConstruction[ v, "LightAngle" -> phi ], Line[ pts : { _, _, _ } ] :> pts, Infinity ] },
    Length[ lines ] == 2 && AllTrue[ Transpose[ { lines, { 0, v } } ], lineV |-> AllTrue[ lineV[[ 1 ]],
      point |-> $near[ $radarMidpoint[ point, lineV[[ 2 ]], phi ], Norm[ lineV[[ 1, 2 ]] ] ] ] ] ] ],
  True,
  TestID -> "SimultaneityConstruction-lines-pass-through-radar-midpoint-of-event"
]

$exactGrid = Tuples[ { { 1/5, 1/2, 3/5, 4/5, 9/10 }, { Pi/6, Pi/4, Pi/3 } } ]

$exact = { x, y } |-> Max[ Abs[ N[ x, 30 ] - N[ y, 30 ] ] ] < 10^-20

$spacelikeLength = { pq, phi } |-> With[ { d = pq[[ 2 ]] - pq[[ 1 ]] }, Sqrt[ ( d[[ 1 ]] / Tan[ phi ] )^2 - d[[ 2 ]]^2 ] ]

$parallel = { d, e } |-> Abs[ N[ Det[ { d, e } ] ] ] < 10^-9

$rodAndBar = { v, phi } |-> With[
  { lines = Cases[ LengthContractionConstruction[ v, "LightAngle" -> phi, "RodRestLength" -> 3/20, "MeasureArcLength" -> 3/5 ], Line[ pq : { _, _ } ] :> pq, Infinity ] },
  { Select[ lines, pq |-> $parallel[ pq[[ 2 ]] - pq[[ 1 ]], { Tan[ phi ], v } ] ],
    Select[ lines, pq |-> Abs[ N[ pq[[ 2, 2 ]] - pq[[ 1, 2 ]] ] ] < 10^-9 ] } ]

VerificationTest[
  AllTrue[ $exactGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { rods = First @ $rodAndBar[ v, phi ] },
    Length[ rods ] == 1 && $onWorldline[ rods[[ 1, 1 ]], v, phi ] && $exact[ $spacelikeLength[ First @ rods, phi ], 3/20 ] ] ],
  True,
  TestID -> "LengthContractionConstruction-rod-along-simultaneity-line-has-rest-length-L"
]

VerificationTest[
  AllTrue[ $exactGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { rodAndBar = $rodAndBar[ v, phi ] },
    { rod = rodAndBar[[ 1, 1 ]], bars = Last @ rodAndBar },
    Length[ bars ] == 1 && $exact[ bars[[ 1, 1 ]], rod[[ 1 ]] ] &&
      $exact[ $spacelikeLength[ First @ bars, phi ], 3 / ( 20 LorentzGamma[ v ] ) ] &&
      $parallel[ bars[[ 1, 2 ]] - rod[[ 2 ]], Through[ { Sin, Cos }[ WorldlineAngle[ v, phi ] ] ] ] ] ],
  True,
  TestID -> "LengthContractionConstruction-measured-at-one-radar-time-has-length-L-over-gamma"
]

VerificationTest[
  AllTrue[ $grid, vp |-> With[
    { phi = vp[[ 2 ]] },
    { light = First @ Cases[ LightClockConstruction[ vp[[ 1 ]], 8, "LightAngle" -> phi ], Line[ pts_ /; Length[ pts ] > 3 ] :> pts, Infinity ] },
    $near[ Map[ Normalize, Differences[ light ] ], Map[ i |-> { If[ OddQ[ i ], 1, -1 ] Sin[ phi ], Cos[ phi ] }, Range[ 8 ] ] ] ] ],
  True,
  TestID -> "LightClockConstruction-light-segments-at-light-directions"
]

VerificationTest[
  AllTrue[ $movingGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { returns = First[ Cases[ LightClockConstruction[ v, 8, "LightAngle" -> phi ], Line[ pts_ /; Length[ pts ] > 3 ] :> pts, Infinity ] ][[ 1 ;; -1 ;; 2 ]] },
    AllTrue[ returns, c |-> $onWorldline[ c, v, phi ] ] && Min[ Differences[ Map[ Norm, returns ] ] ] > 0 ] ],
  True,
  TestID -> "LightClockConstruction-light-returns-to-observer-later"
]

EndTestSection[]
