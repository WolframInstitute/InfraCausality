Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalSubstrates :: CausalSubstrate *)

PackageScope[ substrateCode ]

Options[ CausalSubstrate ] = { "KeepCoordinates" -> False }

Options[ CausalSubstrateCode ] = Options[ CausalSubstrate ]

$wolframModelNames = { "wm3467", "wm7978", "wm4735","wm1529", "wm3975", "wm2216" }

CausalSubstrate[ ] :=
  <|
    "Lattice" -> { "DiamondLatticeGraph", "CylinderLatticeGraph", "CubicLatticeGraph" },
    "Sprinkling" -> { "MinkowskiSprinkling2D", "MinkowskiSprinkling3D" },
    "Spray" -> { "SquareTilingSprayGraph", "HexagonalTilingSprayGraph", "SquareMeshSprayGraph" },
    "Random" -> { "PercolationGraph" },
    "WolframModel" -> $wolframModelNames |>

CausalSubstrate[ All ] :=
  Catenate @ Values @ CausalSubstrate[ ]

substrateCode[ "DiamondLatticeGraph", size_ ] :=
  With[ { n = size /. { "Small" -> 6, "Medium" -> 10, "Large" -> 16 } },
    HoldComplete @ Graph[
      Catenate @ Table[ { i, j }, { i, 0, n }, { j, 0, n } ],
      Flatten @ Table[
        Join[
          If[ i < n, { DirectedEdge[ { i, j }, { i + 1, j } ] }, { } ],
          If[ j < n, { DirectedEdge[ { i, j }, { i, j + 1 } ] }, { } ] ],
        { i, 0, n }, { j, 0, n } ],
      VertexCoordinates -> Catenate @ Table[ { ( j - i ) / 2, ( i + j ) / 2 }, { i, 0, n }, { j, 0, n } ] ] ]

substrateCode[ "CylinderLatticeGraph", size_ ] :=
  With[ { dims = Replace[ size /. { "Small" -> 6, "Medium" -> 10, "Large" -> 16 }, n_Integer :> { n, n } ] },
    { w = First @ dims, h = Last @ dims },
    HoldComplete @ Graph[
      Catenate @ Table[ { k, t }, { t, 0, h }, { k, 0, w - 1 } ],
      Flatten @ Table[
        { DirectedEdge[ { k, t }, { k, t + 1 } ], DirectedEdge[ { k, t }, { Mod[ k + 1, w ], t + 1 } ] },
        { t, 0, h - 1 }, { k, 0, w - 1 } ],
      VertexCoordinates -> Catenate @ Table[ { Mod[ k - t / 2, w ], t }, { t, 0, h }, { k, 0, w - 1 } ] ] ]

substrateCode[ "CubicLatticeGraph", size_ ] :=
  With[ { n = size /. { "Small" -> 3, "Medium" -> 5, "Large" -> 7 } },
    HoldComplete @ Graph[
      Tuples[ Range[ 0, n ], 3 ],
      Catenate @ Map[
        v |-> Map[ e |-> DirectedEdge[ v, v + e ], Select[ IdentityMatrix @ 3, e |-> Max[ v + e ] <= n ] ],
        Tuples[ Range[ 0, n ], 3 ] ],
      VertexCoordinates -> N @ Map[
        v |-> { ( v[[ 1 ]] - v[[ 2 ]] ) / Sqrt[ 2 ], ( v[[ 1 ]] + v[[ 2 ]] - 2 v[[ 3 ]] ) / Sqrt[ 6 ], Total[ v ] / Sqrt[ 3 ] },
        Tuples[ Range[ 0, n ], 3 ] ] ] ]

substrateCode[ name : "MinkowskiSprinkling2D" | "MinkowskiSprinkling3D", size_ ] :=
  With[ { d = If[ name === "MinkowskiSprinkling2D", 2, 3 ], n = size /. { "Small" -> 25, "Medium" -> 50, "Large" -> 100 } },
    { seed = If[ d === 2, 102, 167 ] },
    HoldComplete @ BlockRandom[ SeedRandom[ seed ]; RandomCausalGraph[ n, Method -> { "Sprinkling", d } ] ] ]

substrateCode[ name : "SquareTilingSprayGraph" | "HexagonalTilingSprayGraph" | "SquareMeshSprayGraph", size_ ] :=
  With[ { substrate = StringReplace[ name, "SprayGraph" -> "Graph" ] },
    HoldComplete @ With[ { g = InfraSubstrate[ substrate, size ] }, SprayGraph[ g, First @ GraphCenter @ g ] ] ]

substrateCode[ "PercolationGraph", size_ ] :=
  With[ { n = size /. { "Small" -> 25, "Medium" -> 50, "Large" -> 100 } },
    HoldComplete @ BlockRandom[ SeedRandom[ 102 ]; RandomCausalGraph[ n ] ] ]

substrateCode[ name_String /; MemberQ[ $wolframModelNames, name ], size_ ] :=
  HoldComplete @ Graph[ Import[ PacletObject[ "WolframInstitute/InfraCausality" ][ "AssetLocation", "WolframModelCausalGraphs" ] ][ name ][ size ] ]

CausalSubstrate[ name_String /; MemberQ[ CausalSubstrate[ All ], name ] ] :=
  CausalSubstrate[ name, "Medium" ]

CausalSubstrate[ name_String /; MemberQ[ CausalSubstrate[ All ], name ], size_, opts : OptionsPattern[ { CausalSubstrate, Graph } ] ] :=
  With[ { g = ReleaseHold @ substrateCode[ name, size ] },
    Graph[ VertexList @ g, EdgeList @ g,
      Sequence @@ FilterRules[ { opts }, Options @ Graph ],
      Sequence @@ If[ TrueQ @ OptionValue[ CausalSubstrate, FilterRules[ { opts }, Options @ CausalSubstrate ], "KeepCoordinates" ],
        { VertexCoordinates -> GraphEmbedding @ g }, { } ],
      Sequence @@ CausalSubstrateStyle[ name, Replace[ size, Except[ "Small" | "Medium" | "Large" ] :>
        Which[ VertexCount @ g <= 250, "Small", VertexCount @ g <= 800, "Medium", True, "Large" ] ] ] ] ]

CausalSubstrateCode[ name_String /; MemberQ[ CausalSubstrate[ All ], name ] ] :=
  CausalSubstrateCode[ name, "Medium" ]

CausalSubstrateCode[ name_String /; MemberQ[ CausalSubstrate[ All ], name ], size_, opts : OptionsPattern[ { CausalSubstrate, Graph } ] ] :=
  With[ { code = substrateCode[ name, size ] },
    { public = code /. Map[
        s |-> s -> ToExpression[ SymbolName @ Unevaluated @ s, InputForm, Hold ],
        Cases[ code, s_Symbol /; StringEndsQ[ Context @ Unevaluated @ s, "`PackagePrivate`" ], Infinity, Heads -> True ] ] /.
        Hold[ x_ ] :> x,
      arguments = Join[ FilterRules[ { opts }, Options @ Graph ],
        If[ TrueQ @ OptionValue[ CausalSubstrate, FilterRules[ { opts }, Options @ CausalSubstrate ], "KeepCoordinates" ],
          { VertexCoordinates -> GraphEmbedding @ ReleaseHold @ code }, { } ] ] },
    Replace[ Join[ public, HoldComplete @@ arguments ], {
      HoldComplete[ body_ ] :> HoldForm @ body,
      HoldComplete[ body_, args__ ] :> HoldForm @ Graph[ body, args ] } ] ]

CausalSubstrateStyle[ "Small" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.5 ], Arrowheads[ 0.02 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.6 ], EdgeForm[ { Darker[ StandardGray, 0.6 ], Opacity[ 0.65 ] } ] ],
  VertexSize -> { "Scaled", 0.015 },
  GraphLayout -> { "LayeredDigraphEmbedding", "Orientation" -> Bottom } }

CausalSubstrateStyle[ "Medium" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.4 ], Arrowheads[ 0.012 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.5 ], EdgeForm[ { Darker[ StandardGray, 0.6 ], Opacity[ 0.6 ] } ] ],
  VertexSize -> { "Scaled", 0.01 },
  GraphLayout -> { "LayeredDigraphEmbedding", "Orientation" -> Bottom } }

CausalSubstrateStyle[ "Large" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.3 ], Arrowheads[ 0.006 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.4 ], EdgeForm[ { Darker[ StandardGray, 0.6 ], Opacity[ 0.45 ] } ] ],
  VertexSize -> { "Scaled", 0.006 },
  GraphLayout -> { "LayeredDigraphEmbedding", "Orientation" -> Bottom } }

CausalSubstrateStyle[ _String, size : "Small" | "Medium" | "Large" ] :=
  CausalSubstrateStyle @ size
