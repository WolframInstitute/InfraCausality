Package["WolframInstitute`InfraCausality`"]


(* Generic graph utilities: source/sink extraction, random causal graphs,
   path metrics, and chain finding (longest or maximally separated).         *)


(* =========================== Sources & sinks =========================== *)

(* Sources of a DAG: vertices with in-degree zero. *)
GetSources[ g_ ] := Select[ VertexList @ g, VertexInDegree[ g, # ] == 0 & ]

(* Sinks of a DAG: vertices with out-degree zero. *)
GetSinks[ g_ ] := Select[ VertexList @ g, VertexOutDegree[ g, # ] == 0 & ]


(* =========================== Graph generation =========================== *)

(* RandomConnectedDAG[{n, m}]: random connected DAG on n vertices with m edges,
   acyclically oriented from an underlying random connected undirected graph. *)

PackageScope[ RandomConnectedDAG ]
RandomConnectedDAG[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Module[ { vertexCount, edgeCount, g },
    vertexCount = Max[ First @ spec, 2 ];
    edgeCount   = Clip[ Last @ spec, { vertexCount - 1, vertexCount ( vertexCount - 1 ) / 2 } ];
    g           = RandomGraph[ { vertexCount, edgeCount } ];
    While[ ! ConnectedGraphQ @ g, g = RandomGraph[ { vertexCount, edgeCount } ] ];
    Graph[ DirectedGraph[ g, "Acyclic" ], opt ]
  ]


(* RandomCausalGraph[{n, m}]: a RandomConnectedDAG styled with the causal
   palette and a layered embedding.                                          *)

RandomCausalGraph[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Graph[
    RandomConnectedDAG[ spec, opt ],
    Sequence @@ CausalGraphStyle[ "Default" ],
    GraphLayout -> "LayeredDigraphEmbedding"
  ]


(* =========================== Path-set distances =========================== *)

(* Hausdorff distance: max_{x in X} min_{y in Y} d(x, y), symmetrised. *)

PackageScope[ HausdorffDistance ]
HausdorffDistance[ d_List, setX_, setY_ ] :=
  With[ { distSubMatrix = d[[ setX, setY ]] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]

HausdorffDistance[ g_Graph, setX_List, setY_List ] :=
  With[ { distSubMatrix = Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]


(* Frechet distance with reducer f (default Max), evaluated on the diagonal of
   the pairwise-distance matrix.                                              *)

PackageScope[ FrechetDistance ]
FrechetDistance[ d_List, setX_, setY_, f_ : Max ] :=
  f @ Diagonal @ d[[ setX, setY ]]

FrechetDistance[ g_Graph, setX_List, setY_List, f_ : Max ] :=
  f @ Diagonal @ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ]


(* Separation: minimum pairwise distance between two vertex sets. *)

PackageScope[ Separation ]
Separation[ d_List, setX_, setY_ ] :=
  Min @ d[[ setX, setY ]]

Separation[ g_Graph, setX_List, setY_List ] :=
  Min @ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ]


(* =========================== Internal scoring helpers =========================== *)

(* CentralElement: indices sorted by eccentricity (ascending). *)

PackageScope[ CentralElement ]
CentralElement[ distanceMatrix_List ] :=
  SortBy[ Range @ Length @ distanceMatrix, Max[ distanceMatrix[[ # ]] ] & ]


(* DiverseElement: greedy farthest-point sampling of n indices. *)

PackageScope[ DiverseElement ]
DiverseElement[ distanceMatrix_List, n_ ] :=
  Module[ { selected, remaining, best },
    selected  = { First @ CentralElement @ distanceMatrix };
    remaining = Complement[ Range @ Length @ distanceMatrix, selected ];
    Do[
      best      = First @ MaximalBy[ remaining, idx |-> Min[ distanceMatrix[[ idx, selected ]] ] ];
      AppendTo[ selected, best ];
      remaining = DeleteCases[ remaining, best ],
      { Min[ n, Length @ distanceMatrix ] - 1 }
    ];
    selected
  ]


(* separatedScore[ds, target]: score a list of pairwise tip distances against
   a target separation. Infinity asks for the {min, max} pair, a number asks
   to minimise -((min - t)^2 + (max - t)^2), a {lo, hi} interval matches both
   ends.                                                                     *)

PackageScope[ separatedScore ]
separatedScore[ pairwiseDistances_List, target_ ] :=
  Module[ { finite, minD, maxD },
    finite = Select[ pairwiseDistances, # < Infinity & ];
    If[ finite === { },
      minD = Infinity; maxD = Infinity,
      minD = Min @ finite; maxD = Max @ finite
    ];
    Switch[ target,
      Infinity, { minD, maxD },
      _List,    -( minD - target[[ 1 ]] )^2 - ( maxD - target[[ 2 ]] )^2,
      _,        -( minD - target )^2        - ( maxD - target )^2
    ]
  ]


(* tipToChainDistance: longest-path distance from a tip vertex to any vertex
   of a chain along the directed graph (Infinity if unreachable).            *)

PackageScope[ tipToChainDistance ]
tipToChainDistance[ lpDistMat_List, vertexIdx_Association, tip_, chain_List ] :=
  If[ MemberQ[ chain, tip ], 0,
    With[
      {
        distances = Select[ -lpDistMat[[ vertexIdx[ # ], vertexIdx[ tip ] ]] & /@ chain, # > 0 & ]
      },
      If[ distances === { }, Infinity, Min @ distances ]
    ]
  ]


(* scoreTuple: score a candidate tuple of next vertices for the active chains
   by feeding all tip-to-chain distances into separatedScore.                *)

PackageScope[ scoreTuple ]
scoreTuple[ lpDistMat_List, vertexIdx_Association, chains_List, tuple_List, activeIdx_List, target_ ] :=
  Module[ { extendedChains, allIdx, pairwiseDistances },
    extendedChains = chains;
    Do[
      extendedChains[[ activeIdx[[ i ]] ]] = Append[ chains[[ activeIdx[[ i ]] ]], tuple[[ i ]] ],
      { i, Length @ activeIdx }
    ];
    allIdx = Range @ Length @ chains;
    pairwiseDistances = Flatten @ Table[
      tipToChainDistance[ lpDistMat, vertexIdx, tuple[[ i ]], extendedChains[[ j ]] ],
      { i, Length @ activeIdx },
      { j, DeleteCases[ allIdx, activeIdx[[ i ]] ] }
    ];
    separatedScore[ pairwiseDistances, target ]
  ]


(* =========================== FindChain =========================== *)

(* FindChain[g, ...]: find one or several directed chains in the DAG g.
     Method "Longest"   -- longest paths from a source to a sink.
     Method "Separated" -- greedy growth keeping chain tips at a target
                           separation (controlled by "TargetSeparation",
                           ties broken by "TieBreaker").                      *)

Options[ FindChain ] = { "Method" -> "Longest", "TargetSeparation" -> Infinity, "TieBreaker" -> First };

FindChain[ g_Graph, v1_, v2_, n_Integer, opts : OptionsPattern[] ] :=
  FindChain[ g, v1, v2, UpTo[ n ], opts ]

FindChain[ g_Graph, v1_, v2_, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Module[ { method, negGraph, d },
    method   = OptionValue[ "Method" ];
    negGraph = Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount @ g ] ];
    d        = Round[ -GraphDistance[ negGraph, v1, v2 ] ];
    Which[
      ! IntegerQ @ d || d < 1,    { },
      method === "Longest",       FindPath[ g, v1, v2, { d }, n ],
      method === "Separated",     separatedGrow[ g, n, v1, v2, opts ],
      True,                       { }
    ]
  ]

FindChain[ g_Graph, v1_, v2_, opts : OptionsPattern[] ] /; ! MatchQ[ v2, _Rule | _RuleDelayed ] :=
  FindChain[ g, v1, v2, 1, opts ]

FindChain[ g_Graph, n_Integer, opts : OptionsPattern[] ] :=
  FindChain[ g, UpTo[ n ], opts ]

FindChain[ g_Graph, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  If[ OptionValue[ "Method" ] === "Separated",
    separatedGrow[ g, n, Automatic, Automatic, opts ],
    longestChains[ g, n ]
  ]

FindChain[ g_Graph, opts : OptionsPattern[] ] :=
  FindChain[ g, 1, opts ]


(* =========================== Longest chains =========================== *)

(* longestPathLength: length of the longest directed path from source to sink
   via topological-order dynamic programming.                                 *)

PackageScope[ longestPathLength ]
longestPathLength[ g_Graph, source_, sink_ ] :=
  Module[ { order, dist, successors },
    order = TopologicalSort @ g;
    dist  = AssociationThread[ order, -Infinity ];
    AssociateTo[ dist, source -> 0 ];
    Do[
      successors = Complement[ VertexOutComponent[ g, { u }, 1 ], { u } ];
      Scan[ ( AssociateTo[ dist, # -> Max[ dist @ #, dist @ u + 1 ] ] ) &, successors ],
      { u, order }
    ];
    dist @ sink
  ]


(* longestChains: collect up to n chains of decreasing length. *)

PackageScope[ longestChains ]
longestChains[ g_Graph, n_Integer ] :=
  Module[ { sources, sinks, pairs, lengths, maxLen, collected, pairsAtLen },
    sources = GetSources @ g;
    sinks   = GetSinks   @ g;
    pairs   = Tuples[ { sources, sinks } ];
    lengths = longestPathLength[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ pairs;
    maxLen  = Max @ lengths;
    If[ maxLen < 1, Return[ { } ] ];
    collected = { };
    Do[
      pairsAtLen = pairs[[ Flatten @ Position[ lengths, len ] ]];
      Do[
        collected = Join[ collected, FindPath[ g, bp[[ 1 ]], bp[[ 2 ]], { len }, n - Length @ collected ] ];
        If[ Length @ collected >= n, Break[] ],
        { bp, pairsAtLen }
      ];
      If[ Length @ collected >= n, Break[] ],
      { len, maxLen, 1, -1 }
    ];
    Take[ collected, UpTo[ n ] ]
  ]


(* =========================== Separated growth =========================== *)

(* successorsAtLevel: vertices reachable in one directed step from tip,
   restricted to the given reachable set and the requested universal-time
   level.  Top-level helper to remove the nested Module from separatedGrow. *)

PackageScope[ successorsAtLevel ]
successorsAtLevel[ g_Graph, tip_, level_, vertexLevel_Association, reachable_List ] :=
  Select[
    Intersection[ Complement[ VertexOutComponent[ g, { tip }, 1 ], { tip } ], reachable ],
    vertexLevel @ # == level &
  ]


(* separatedGrow: grow n chains in lock-step from chosen sources, level by
   level, picking the candidate tuple that maximises separatedScore.         *)

PackageScope[ separatedGrow ]
separatedGrow[ g_Graph, n_Integer, v1_, v2_, opts : OptionsPattern[ FindChain ] ] :=
  Module[
    {
      target, tieBreaker, lpDistMat, undirDistMat, vertexIdx, vertexLevel, nLevels,
      sources, startVertices, tips, chains, reachable,
      activeIdx, candidateSets, successors, tuples, scores, bestScore, bestTuple
    },
    target       = OptionValue[ FindChain, { opts }, "TargetSeparation" ];
    tieBreaker   = OptionValue[ FindChain, { opts }, "TieBreaker" ];
    lpDistMat    = GraphDistanceMatrix[ Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount @ g ] ] ];
    undirDistMat = GraphDistanceMatrix @ UndirectedGraph @ g;
    vertexIdx    = AssociationThread[ VertexList @ g, Range @ VertexCount @ g ];
    sources      = GetSources @ g;
    vertexLevel  = AssociationThread[
      VertexList @ g,
      Round @ MapThread[ Max, -lpDistMat[[ vertexIdx /@ sources, All ]] ]
    ];
    nLevels   = Max @ vertexLevel;
    reachable = If[ v2 =!= Automatic,
      Intersection[ VertexOutComponent[ g, { v1 } ], VertexInComponent[ g, { v2 } ] ],
      VertexList @ g
    ];
    startVertices = If[ v1 =!= Automatic,
      ConstantArray[ v1, n ],
      pickSeparatedSources[ sources, undirDistMat, vertexIdx, n ]
    ];
    tips   = startVertices;
    chains = List /@ tips;
    Do[
      activeIdx     = { };
      candidateSets = { };
      Do[
        If[ vertexLevel @ tips[[ i ]] >= level, Continue[] ];
        successors = successorsAtLevel[ g, tips[[ i ]], level, vertexLevel, reachable ];
        If[ successors =!= { },
          AppendTo[ activeIdx, i ];
          AppendTo[ candidateSets, successors ]
        ],
        { i, Length @ chains }
      ];
      If[ activeIdx === { }, Continue[] ];
      tuples = Tuples @ candidateSets;
      bestTuple = If[ Length @ tuples == 1,
        First @ tuples,
        scores    = scoreTuple[ lpDistMat, vertexIdx, chains, #, activeIdx, target ] & /@ tuples;
        bestScore = scores[[ Last @ Ordering @ scores ]];
        tieBreaker @ tuples[[ Flatten @ Position[ scores, bestScore ] ]]
      ];
      Do[
        chains[[ activeIdx[[ i ]] ]] = Append[ chains[[ activeIdx[[ i ]] ]], bestTuple[[ i ]] ];
        tips  [[ activeIdx[[ i ]] ]] = bestTuple[[ i ]],
        { i, Length @ activeIdx }
      ],
      { level, 1, nLevels }
    ];
    DeleteDuplicates @ chains
  ]


(* pickSeparatedSources: greedy maximin selection of n source vertices using
   the undirected distance matrix; pads with duplicates if fewer sources
   exist than chains requested.                                              *)

PackageScope[ pickSeparatedSources ]
pickSeparatedSources[ sources_List, undirDistMat_List, vertexIdx_Association, n_Integer ] :=
  Module[ { selected },
    selected = { First @ sources };
    Do[
      AppendTo[ selected,
        First @ MaximalBy[ Complement[ sources, selected ],
          s |-> Min[ undirDistMat[[ vertexIdx @ s, vertexIdx /@ selected ]] ]
        ]
      ],
      { Min[ n, Length @ sources ] - 1 }
    ];
    PadRight[ selected, n, selected ]
  ]
