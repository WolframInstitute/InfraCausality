Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: CausalSetEstimators *)

PackageScope[ causalOrderMatrix ]

PackageScope[ myrheimMeyerFraction ]

PackageScope[ benincasaDowkerCoefficients ]

PackageScope[ benincasaDowker ]

Options[ benincasaDowker ] = { "Dimension" -> 2 }

causalOrderMatrix[ graph_Graph, events_List ] :=
  AdjacencyMatrix @ Graph[ events, EdgeList @ TransitiveClosureGraph @ Subgraph[ graph, events ] ]

myrheimMeyerFraction[ d_ ] :=
  Gamma[ d + 1 ] Gamma[ d / 2 ] / ( 2 Gamma[ 3 d / 2 ] )

benincasaDowkerCoefficients[ 2 ] =
  { 4, -1 / 2, { 1, -2, 1 } }

benincasaDowkerCoefficients[ 4 ] =
  { 4 / Sqrt[ 6 ], -1, { 1, -9, 16, -8 } }

benincasaDowker[ order_, dimension : 2 | 4 ] :=
  With[ { n = Length @ order, between = Normal[ order . order ], coefficients = benincasaDowkerCoefficients @ dimension },
    { weights = AssociationThread[ Range[ 0, Length @ Last @ coefficients - 1 ], Last @ coefficients ] },
    SparseArray[
      coefficients[[ 2 ]] IdentityMatrix[ n ] +
        Transpose[ Normal[ order ] Map[ k |-> Lookup[ weights, k, 0 ], between, { 2 } ] ] ] ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "OrderingFraction" ] :=
  With[ { events = Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ] },
    Total[ causalOrderMatrix[ graph, events ], 2 ] / Binomial[ Length @ events, 2 ] /; Length @ events >= 2 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "MyrheimMeyerDimension" ] :=
  With[ { r = InfraMeasurement[ graph, diamond, "OrderingFraction" ] },
    Replace[ r, {
      0 -> Infinity,
      1 -> 1,
      _ :> With[ { top = NestWhile[ 2 # &, 10, myrheimMeyerFraction[ # ] > r & ] },
        d /. FindRoot[ myrheimMeyerFraction[ d ] == r, { d, 1, top } ] ] } ] /; NumericQ @ r ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "MidpointScalingDimension" ] :=
  With[ { order = causalOrderMatrix[ graph, Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ] ] },
    Log2[ Length[ order ] / ( 1 + Max @ MapThread[ Min, { Total[ order, { 2 } ], Total[ order, { 1 } ] } ] ) ] /; Length @ order >= 1 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "IntervalAbundances" ] :=
  With[ { order = causalOrderMatrix[ graph, Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ] ] },
    { ks = Range[ 0, Length @ order - 2 ] },
    AssociationThread[ ks,
      Lookup[ Counts @ Pick[ Flatten @ Normal[ order . order ], Flatten @ Normal @ order, 1 ], ks, 0 ] ] /; Length @ order >= 2 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "BenincasaDowkerDAlembertian", opts : OptionsPattern[ benincasaDowker ] ] /;
    MatchQ[ OptionValue[ benincasaDowker, { opts }, "Dimension" ], 2 | 4 ] :=
  With[ { order = causalOrderMatrix[ graph, Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ] ], dimension = OptionValue[ benincasaDowker, { opts }, "Dimension" ] },
    First[ benincasaDowkerCoefficients @ dimension ] benincasaDowker[ order, dimension ] /; Length @ order >= 1 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "BenincasaDowkerRicci", opts : OptionsPattern[ benincasaDowker ] ] /;
    MatchQ[ OptionValue[ benincasaDowker, { opts }, "Dimension" ], 2 | 4 ] :=
  With[ { events = Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ], dimension = OptionValue[ benincasaDowker, { opts }, "Dimension" ] },
    AssociationThread[ events,
      -2 First[ benincasaDowkerCoefficients @ dimension ] ( benincasaDowker[ causalOrderMatrix[ graph, events ], dimension ] . ConstantArray[ 1, Length @ events ] ) ] /;
      Length @ events >= 1 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "BenincasaDowkerAction", opts : OptionsPattern[ benincasaDowker ] ] /;
    MatchQ[ OptionValue[ benincasaDowker, { opts }, "Dimension" ], 2 | 4 ] :=
  With[ { events = Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ], dimension = OptionValue[ benincasaDowker, { opts }, "Dimension" ] },
    -First[ benincasaDowkerCoefficients @ dimension ] Total[ benincasaDowker[ causalOrderMatrix[ graph, events ], dimension ] . ConstantArray[ 1, Length @ events ] ] /;
      Length @ events >= 1 ]
