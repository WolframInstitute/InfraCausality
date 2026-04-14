Package["WolframInstitute`InfraCausality`"]

(* ========================= Sources & Sinks ========================= *)

GetSources[ g_ ] := Select[ VertexList @ g, VertexInDegree[ g, # ] == 0 & ]

GetSinks[ g_ ] := Select[ VertexList @ g, VertexOutDegree[ g, # ] == 0 & ]

(* ========================= Graph Generation ========================= *)

PackageScope[ RandomConnectedDAG ]
RandomConnectedDAG[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Module[ { vertexCount, edgeCount, g },
    vertexCount = Max[ First @ spec, 2 ];
    edgeCount = Clip[ Last @ spec, { vertexCount - 1, vertexCount (vertexCount - 1) / 2 } ];
    g = RandomGraph[ { vertexCount, edgeCount } ];
    While[ ! ConnectedGraphQ[ g ], g = RandomGraph[ { vertexCount, edgeCount } ] ];
    Graph[ DirectedGraph[ g, "Acyclic" ], opt ]
  ]

RandomCausalGraph[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Graph[
    RandomConnectedDAG[ spec, opt ],
    VertexStyle ->
      ResourceFunction[ "WolframPhysicsProjectStyleData" ][ "CausalGraph",
        "VertexStyle" ],
    EdgeStyle ->
      ResourceFunction[ "WolframPhysicsProjectStyleData" ][ "CausalGraph",
        "EdgeStyle" ],
    GraphLayout -> "LayeredDigraphEmbedding"
  ]


(* ========================= Path distances ========================= *)

PackageScope[ HausdorffDistance ]
HausdorffDistance[ d_List, setX_, setY_ ] :=
  With[ { distSubMatrix = d[[ setX, setY ]] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]

HausdorffDistance[ g_Graph, setX_List, setY_List ] :=
  With[ { distSubMatrix = Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]

PackageScope[ FrechetDistance ]
FrechetDistance[ d_List, setX_, setY_, f_ : Max ] :=
  f[ Diagonal[ d[[ setX, setY ]] ] ]

FrechetDistance[ g_Graph, setX_List, setY_List, f_ : Max ] :=
  f[ Diagonal[ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] ] ]

PackageScope[ Separation ]
Separation[ d_List, setX_, setY_ ] :=
  Min[ d[[ setX, setY ]] ]

Separation[ g_Graph, setX_List, setY_List ] :=
  Min[ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] ]


(* ========================= Internal path selection helpers ========================= *)

PackageScope[ CentralElement ]
CentralElement[ distanceMatrix_List ] :=
  SortBy[ Range @ Length @ distanceMatrix, Max[ distanceMatrix[[ # ]] ] & ]

PackageScope[ DiverseElement ]
DiverseElement[ distanceMatrix_List, n_ ] :=
  Module[ { selected, remaining, best },
    selected = { First @ CentralElement[ distanceMatrix ] };
    remaining = Complement[ Range @ Length @ distanceMatrix, selected ];
    Do[
      best = First @ MaximalBy[ remaining, idx |-> Min[ distanceMatrix[[ idx, selected ]] ] ];
      AppendTo[ selected, best ];
      remaining = DeleteCases[ remaining, best ],
      { Min[ n, Length @ distanceMatrix ] - 1 }
    ];
    selected
  ]

PackageScope[ separatedScore ]
separatedScore[ pairwiseDistances_List, target_ ] :=
  Module[ { finite, minD, maxD },
    finite = Select[ pairwiseDistances, # < Infinity & ];
    If[ finite === {},
      minD = Infinity; maxD = Infinity,
      minD = Min[ finite ]; maxD = Max[ finite ]
    ];
    Switch[ target,
      Infinity,
        { minD, maxD },
      _List,
        -( minD - target[[ 1 ]] )^2 - ( maxD - target[[ 2 ]] )^2,
      _,
        -( minD - target )^2 - ( maxD - target )^2
    ]
  ]

PackageScope[ tipToChainDistance ]
tipToChainDistance[ lpDistMat_List, vertexIdx_Association, tip_, chain_List ] :=
  With[ { distances = Select[ -lpDistMat[[ vertexIdx[ # ], vertexIdx[ tip ] ]] & /@ chain, # > 0 & ] },
    If[ distances === {}, Infinity, Min[ distances ] ]
  ]

PackageScope[ scoreTuple ]
scoreTuple[ lpDistMat_List, vertexIdx_Association, chains_List, tuple_List, activeIdx_List, target_ ] :=
  Module[ { extendedChains, allIdx, pairwiseDistances },
    extendedChains = chains;
    Do[ extendedChains[[ activeIdx[[ i ]] ]] = Append[ chains[[ activeIdx[[ i ]] ]], tuple[[ i ]] ], { i, Length @ activeIdx } ];
    allIdx = Range @ Length @ chains;
    pairwiseDistances = Flatten @ Table[
      tipToChainDistance[ lpDistMat, vertexIdx, tuple[[ i ]], extendedChains[[ j ]] ],
      { i, Length @ activeIdx }, { j, DeleteCases[ allIdx, activeIdx[[ i ]] ] }
    ];
    separatedScore[ pairwiseDistances, target ]
  ]

(* ========================= FindChain ========================= *)

Options[ FindChain ] = { "Method" -> "Longest", "TargetSeparation" -> Infinity, "TieBreaker" -> First };

FindChain[ g_Graph, v1_, v2_, n_Integer, opts : OptionsPattern[] ] :=
  Module[ { result },
    result = FindChain[ g, v1, v2, UpTo[ n ], opts ];
    If[ Length[ result ] < n, $Failed, result ]
  ]

FindChain[ g_Graph, v1_, v2_, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Module[ { negGraph, d, method },
    method = OptionValue[ "Method" ];
    negGraph = Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ];
    d = Round[ -GraphDistance[ negGraph, v1, v2 ] ];
    If[ ! IntegerQ[ d ] || d < 1, Return[ {} ] ];
    If[ method === "Longest",
      Return[ FindPath[ g, v1, v2, { d }, n ] ]
    ];
    If[ method === "Separated",
      Return[ separatedGrow[ g, n, v1, v2, opts ] ]
    ];
    {}
  ]

FindChain[ g_Graph, v1_, v2_, opts : OptionsPattern[] ] /; ! MatchQ[ v2, _Rule | _RuleDelayed ] :=
  FindChain[ g, v1, v2, 1, opts ]

FindChain[ g_Graph, n_Integer, opts : OptionsPattern[] ] :=
  Module[ { result },
    result = FindChain[ g, UpTo[ n ], opts ];
    If[ Length[ result ] < n, $Failed, result ]
  ]

FindChain[ g_Graph, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Module[ { method },
    method = OptionValue[ "Method" ];
    If[ method === "Separated",
      Return[ separatedGrow[ g, n, Automatic, Automatic, opts ] ]
    ];
    longestChains[ g, n ]
  ]

FindChain[ g_Graph, opts : OptionsPattern[] ] :=
  FindChain[ g, 1, opts ]

(* ========================= Longest chains ========================= *)

PackageScope[ longestPathLength ]
longestPathLength[ g_Graph, source_, sink_ ] :=
  Module[ { order, dist, successors },
    order = TopologicalSort[ g ];
    dist = AssociationThread[ order, -Infinity ];
    AssociateTo[ dist, source -> 0 ];
    Do[
      successors = Complement[ VertexOutComponent[ g, { u }, 1 ], { u } ];
      Scan[ (AssociateTo[ dist, # -> Max[ dist[ # ], dist[ u ] + 1 ] ]) &, successors ],
      { u, order }
    ];
    dist[ sink ]
  ]

PackageScope[ longestChains ]
longestChains[ g_Graph, n_Integer ] :=
  Module[ { sources, sinks, pairs, lengths, maxLen, collected, pairsAtLen },
    sources = GetSources[ g ];
    sinks = GetSinks[ g ];
    pairs = Tuples[ { sources, sinks } ];
    lengths = longestPathLength[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ pairs;
    maxLen = Max[ lengths ];
    If[ maxLen < 1, Return[ {} ] ];
    collected = {};
    Do[
      pairsAtLen = pairs[[ Flatten @ Position[ lengths, len ] ]];
      Do[
        collected = Join[ collected, FindPath[ g, bp[[ 1 ]], bp[[ 2 ]], { len }, n - Length[ collected ] ] ];
        If[ Length[ collected ] >= n, Break[] ],
        { bp, pairsAtLen }
      ];
      If[ Length[ collected ] >= n, Break[] ],
      { len, maxLen, 1, -1 }
    ];
    Take[ collected, UpTo[ n ] ]
  ]

(* ========================= Separated growth ========================= *)

PackageScope[ separatedGrow ]
separatedGrow[ g_Graph, n_Integer, v1_, v2_, opts : OptionsPattern[ FindChain ] ] :=
  Module[ { target, tieBreaker, lpDistMat, undirDistMat, vertexIdx, vertexLevel, nLevels,
            sources, startVertices, tips, chains, reachable,
            activeIdx, candidateSets, tuples, scores, bestScore, tied, bestTuple },
    target = OptionValue[ FindChain, { opts }, "TargetSeparation" ];
    tieBreaker = OptionValue[ FindChain, { opts }, "TieBreaker" ];
    lpDistMat = GraphDistanceMatrix[ Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ] ];
    undirDistMat = GraphDistanceMatrix[ UndirectedGraph[ g ] ];
    vertexIdx = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ];

    (* Compute vertex levels via longest paths from sources *)
    sources = GetSources[ g ];
    vertexLevel = AssociationThread[ VertexList[ g ],
      Round @ MapThread[ Max, -lpDistMat[[ vertexIdx /@ sources, All ]] ]
    ];
    nLevels = Max[ vertexLevel ];

    (* Reachable set: restrict to causal interval if endpoints given *)
    reachable = If[ v2 =!= Automatic,
      Intersection[ VertexOutComponent[ g, { v1 } ], VertexInComponent[ g, { v2 } ] ],
      VertexList[ g ]
    ];

    (* Select starting vertices *)
    If[ v1 =!= Automatic,
      startVertices = ConstantArray[ v1, n ],
      (* Greedy maximin source selection using undirected distances *)
      startVertices = { First @ sources };
      Do[
        AppendTo[ startVertices,
          First @ MaximalBy[ Complement[ sources, startVertices ],
            s |-> Min[ undirDistMat[[ vertexIdx[ s ], vertexIdx /@ startVertices ]] ] ] ],
        { Min[ n, Length @ sources ] - 1 }
      ];
      (* If fewer sources than requested chains, duplicate to fill *)
      startVertices = PadRight[ startVertices, n, startVertices ]
    ];

    tips = startVertices;
    chains = List /@ tips;

    (* Grow level by level *)
    Do[
      (* Find active chains and their candidate successors at this level *)
      activeIdx = {};
      candidateSets = {};
      Do[
        If[ vertexLevel[ tips[[ i ]] ] >= level, Continue[] ];
        Module[ { successors },
          successors = Select[
            Intersection[
              Complement[ VertexOutComponent[ g, { tips[[ i ]] }, 1 ], { tips[[ i ]] } ],
              reachable
            ],
            vertexLevel[ # ] == level &
          ];
          If[ successors =!= {},
            AppendTo[ activeIdx, i ];
            AppendTo[ candidateSets, successors ]
          ]
        ],
        { i, Length @ chains }
      ];
      If[ activeIdx === {}, Continue[] ];

      (* Enumerate all k-tuples and score them *)
      tuples = Tuples[ candidateSets ];
      If[ Length[ tuples ] == 1,
        bestTuple = First @ tuples,
        scores = scoreTuple[ lpDistMat, vertexIdx, chains, #, activeIdx, target ] & /@ tuples;
        bestScore = scores[[ Last @ Ordering[ scores ] ]];
        bestTuple = tieBreaker[ tuples[[ Flatten @ Position[ scores, bestScore ] ]] ]
      ];

      (* Extend chains with the best tuple *)
      Do[
        chains[[ activeIdx[[ i ]] ]] = Append[ chains[[ activeIdx[[ i ]] ]], bestTuple[[ i ]] ];
        tips[[ activeIdx[[ i ]] ]] = bestTuple[[ i ]],
        { i, Length @ activeIdx }
      ],
      { level, 1, nLevels }
    ];
    DeleteDuplicates[ chains ]
  ]
