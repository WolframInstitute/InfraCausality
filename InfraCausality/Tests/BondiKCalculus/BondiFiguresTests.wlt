BeginTestSection[ "BondiFigures" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$initialValues = m |-> Cases[ m, { { s_Symbol, init_, _ }, ___ } :> ( s -> init ) ]

$constructionFrame = { m, name } |-> ReleaseHold[ Extract[ m, 1, Hold ] /. Prepend[ $initialValues[ m ], Extract[ m, { 2, 1, 1 } ] -> name ] ]

$grid = Tuples[ { { 0, 0.2, 0.5, 0.8, 3/5 }, { 0.3, Pi/4, 1.2 } } ]

$movingGrid = Select[ $grid, vp |-> vp[[ 1 ]] != 0 ]

$near = { x, y } |-> Max[ Abs[ N[ x - y ] ] ] < 10^-9

$onWorldline = { point, v, phi } |-> N[ point[[ 1 ]] ] > 0 && $near[ point, Norm[ point ] WorldlineDirection[ v, phi ] ]

$disks = g |-> Cases[ g, Disk[ c_, _ ] :> c, Infinity ]

$radarMidpoint = { point, v, phi } |-> With[ { d = WorldlineDirection[ v, phi ] },
  Mean[ Map[ right |-> First @ LinearSolve[ Transpose[ { d, LightDirection[ phi, right ] } ], point ], { True, False } ] ] ]

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

VerificationTest[
  AllTrue[ $movingGrid, vp |-> With[
    { v = vp[[ 1 ]], phi = vp[[ 2 ]] },
    { ticks = Select[
        Map[ pq |-> Mean[ pq ], Select[ Cases[ TimeDilationConstruction[ v, "LightAngle" -> phi ], Line[ pq : { _, _ } ] :> pq, Infinity ],
          pq |-> Abs[ N[ ( pq[[ 2 ]] - pq[[ 1 ]] ) . WorldlineDirection[ v, phi ] ] ] < 10^-9 ] ],
        mid |-> $onWorldline[ mid, v, phi ] ] },
    Length[ ticks ] >= 1 && $near[ Sort[ ProperTimeScale[ v, phi ] Map[ Norm, ticks ] ], Range @ Length @ ticks ] ] ],
  True,
  TestID -> "TimeDilationConstruction-ticks-at-proper-time-arc-lengths"
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

VerificationTest[
  AllTrue[ $grid, vp |-> With[
    { phi = vp[[ 2 ]] },
    { light = First @ Cases[ LightClockConstruction[ vp[[ 1 ]], 8, "LightAngle" -> phi ], Line[ pts_ /; Length[ pts ] > 3 ] :> pts, Infinity ] },
    $near[ Map[ Normalize, Differences[ light ] ], Map[ i |-> LightDirection[ phi, OddQ[ i ] ], Range[ 8 ] ] ] ] ],
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
