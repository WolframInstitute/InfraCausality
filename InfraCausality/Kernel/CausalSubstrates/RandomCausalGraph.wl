Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalSubstrates :: RandomCausalGraph *)

PackageScope[ causalGraph ]

PackageScope[ sprinklingPoints ]

Options[ RandomCausalGraph ] = { Method -> Automatic }

causalGraph[ n_Integer, edges_List, coordinates_, opts___ ] :=
  With[ { hasse = TransitiveReductionGraph @ Graph[ Range @ n, edges ] },
    Graph[ Range @ n, EdgeList @ hasse,
      FilterRules[ { opts }, Options @ Graph ],
      Sequence @@ Replace[ coordinates, { None -> { }, c_List :> { VertexCoordinates -> c } } ],
      Sequence @@ CausalSubstrateStyle @ Which[ n <= 250, "Small", n <= 800, "Medium", True, "Large" ] ] ]

sprinklingPoints[ n_Integer, d_Integer ] :=
  SortBy[
    Take[
      NestWhile[
        points |-> Join[ points,
          Select[ Transpose @ Prepend[ RandomReal[ { -1 / 2, 1 / 2 }, { d - 1, 2 n + 8 } ], RandomReal[ 1, 2 n + 8 ] ],
            p |-> Norm @ Rest @ p < Min[ First @ p, 1 - First @ p ] ] ],
        { },
        Length @ # < n & ],
      n ],
    First ]

RandomCausalGraph[ n_Integer?Positive, opts : OptionsPattern[ { RandomCausalGraph, Graph } ] ] /;
    MatchQ[ OptionValue[ RandomCausalGraph, FilterRules[ { opts }, Options @ RandomCausalGraph ], Method ],
      Automatic | "Percolation" | "Sprinkling" | { "Percolation", _?( NumericQ[ # ] && 0 <= # <= 1 & ) } | { "Sprinkling", _Integer?( GreaterEqualThan[ 2 ] ) } ] :=
  With[ { method = Replace[ OptionValue[ RandomCausalGraph, FilterRules[ { opts }, Options @ RandomCausalGraph ], Method ],
            { Automatic | "Percolation" -> { "Percolation", N[ Log[ n ] / n ] }, "Sprinkling" -> { "Sprinkling", 2 } } ],
          graphOptions = FilterRules[ { opts }, Options @ Graph ] },
    Replace[ method, {
      { "Percolation", p_ } :> With[ { pairs = Subsets[ Range @ n, { 2 } ] },
        causalGraph[ n, DirectedEdge @@@ Pick[ pairs, UnitStep[ RandomReal[ 1, Length @ pairs ] - p ], 0 ], None, Sequence @@ graphOptions ] ],
      { "Sprinkling", d_ } :> With[ { points = sprinklingPoints[ n, d ] },
        causalGraph[ n,
          Catenate @ Table[
            If[ points[[ j, 1 ]] - points[[ i, 1 ]] > Norm[ Rest @ points[[ j ]] - Rest @ points[[ i ]] ], DirectedEdge[ i, j ], Nothing ],
            { i, n }, { j, i + 1, n } ],
          If[ d <= 3, Append[ Rest @ #, First @ # ] & /@ points, { #[[ 2 ]], #[[ 1 ]] } & /@ points ],
          Sequence @@ graphOptions ] ] } ] ]

RandomCausalGraph[ { n_Integer?Positive, m_Integer }, opts : OptionsPattern[ Graph ] ] :=
  With[ { count = Max[ n, 2 ] },
    { size = Clip[ m, { count - 1, count ( count - 1 ) / 2 } ] },
    { g = NestWhile[ previous |-> RandomGraph[ { count, size } ], RandomGraph[ { count, size } ], ! ConnectedGraphQ @ # & ] },
    causalGraph[ count, EdgeList @ DirectedGraph[ g, "Acyclic" ], None, opts ] ]
