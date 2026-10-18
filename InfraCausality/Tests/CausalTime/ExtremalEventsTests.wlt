BeginTestSection["ExtremalEvents"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$mechGraph = Graph[
  { 1 -> 2, 2 -> 3, 3 -> 4,
    5 -> 6, 6 -> 7, 7 -> 8,
    1 -> 6, 2 -> 7, 3 -> 8,
    5 -> 2, 6 -> 3, 7 -> 4 } ];

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$fixtures = <| "Mech" -> $mechGraph, "TwoSource" -> $twoSource, "Diamond" -> $diamond |>;

$heightsQ = { g, f } |-> Keys @ f @ g === Range[ 0, Max @ UniversalTime @ g ];

$inSlicesQ = { g, f } |-> AllTrue[ Normal @ f @ g, rule |-> Last @ rule =!= { } && SubsetQ[ Keys @ InfraMeasurement[ g, InfraSlice[ First @ rule ], "VertexDensity" ], Last @ rule ] ];

$largestQ = { g, f, component } |-> AllTrue[ Normal @ f @ g,
  rule |-> With[ { slice = Keys @ InfraMeasurement[ g, InfraSlice[ First @ rule ], "VertexDensity" ], volume = v |-> Length @ component[ g, { v } ] },
    Last @ rule === Sort @ Select[ slice, v |-> volume[ v ] == Max[ volume /@ slice ] ] ] ];

VerificationTest[ AllTrue[ $fixtures, g |-> $heightsQ[ g, MaximalAbsorber ] && $heightsQ[ g, MaximalEmitter ] ], True, TestID -> "MaximalAbsorber-All-keys-are-heights" ]

VerificationTest[ AllTrue[ $fixtures, g |-> $inSlicesQ[ g, MaximalAbsorber ] && $inSlicesQ[ g, MaximalEmitter ] ], True, TestID -> "MaximalAbsorber-All-values-lie-in-slices" ]

VerificationTest[ AllTrue[ $fixtures, g |-> $largestQ[ g, MaximalAbsorber, VertexInComponent ] ], True, TestID -> "MaximalAbsorber-All-largest-past-in-slice" ]

VerificationTest[ AllTrue[ $fixtures, g |-> $largestQ[ g, MaximalEmitter, VertexOutComponent ] ], True, TestID -> "MaximalEmitter-All-largest-future-in-slice" ]

VerificationTest[ MaximalAbsorber @ $twoSource, <| 0 -> { 1, 2 }, 1 -> { 3 }, 2 -> { 4 }, 3 -> { 5 } |>, TestID -> "MaximalAbsorber-TwoSource-values" ]

EndTestSection[]
