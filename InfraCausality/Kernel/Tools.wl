(* ========================= Sources & Sinks ========================= *)

GetSources[ g_ ] := Select[ VertexList @ g, VertexInDegree[ g, # ] == 0 & ]

GetSinks[ g_ ] := Select[ VertexList @ g, VertexOutDegree[ g, # ] == 0 & ]

(* ========================= Graph Generation ========================= *)

RandomConnectedDAG[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Module[ { vertexCount, edgeCount },
    vertexCount = Max[ First @ spec, 0 ];
    edgeCount = Min[ Max[ Last @ spec, 0 ], vertexCount (vertexCount - 1) / 2 ];
    Graph[
      DirectedGraph[
        First @ SortBy[ ConnectedGraphComponents[ RandomGraph[ { vertexCount, edgeCount } ] ], VertexCount ],
        "Acyclic"
      ],
      opt
    ]
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

HausdorffDistance[ d_List, setX_, setY_ ] :=
  With[ { distSubMatrix = d[[ setX, setY ]] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]

HausdorffDistance[ g_Graph, setX_List, setY_List ] :=
  With[ { distSubMatrix = Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] },
    Max[ Max[ Min /@ distSubMatrix ], Max[ Min /@ Transpose @ distSubMatrix ] ]
  ]

FrechetDistance[ d_List, setX_, setY_, f_ : Max ] :=
  f[ Diagonal[ d[[ setX, setY ]] ] ]

FrechetDistance[ g_Graph, setX_List, setY_List, f_ : Max ] :=
  f[ Diagonal[ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] ] ]

Separation[ d_List, setX_, setY_ ] :=
  Min[ d[[ setX, setY ]] ]

Separation[ g_Graph, setX_List, setY_List ] :=
  Min[ Outer[ GraphDistance[ g, #1, #2 ] &, setX, setY, 1 ] ]


(* ========================= Methods to select touples of paths ========================= *)

CentralElement[ distanceMatrix_List ] :=
  SortBy[ Range @ Length @ distanceMatrix, Max[ distanceMatrix[[ # ]] ] & ]

Options[ CentralPath ] = { "Method" -> "CentralFrechet" };

CentralPath[ _Graph, paths_List, All, OptionsPattern[] ] := paths

CentralPath[ graph_Graph, paths_List, n_Integer : 1, opts : OptionsPattern[] ] :=
  Module[ { distMatrix, vertexIndex, baseDist, pairwiseDistances, method },
    If[ Length[ paths ] <= 1, Return[ paths ] ];
    method = OptionValue[ "Method" ];
    distMatrix = GraphDistanceMatrix[ graph ];
    vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ];
    baseDist = Switch[ method,
      "CentralFrechet", FrechetDistance,
      "CentralMeanFrechet", FrechetDistance[ ##, Mean ] &,
      _, FrechetDistance
    ];
    pairwiseDistances = (# + Transpose[ # ]) & @ PadRight[ Table[
      baseDist[ distMatrix, Lookup[ vertexIndex, paths[[ i ]] ], Lookup[ vertexIndex, paths[[ j ]] ] ],
      { i, Length[ paths ] }, { j, i - 1 } ], { Length[ paths ], Length[ paths ] } ];
    paths[[ Take[ CentralElement[ pairwiseDistances ], UpTo[ n ] ] ]]
  ]

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

DiversePaths[ graph_Graph, paths_List, n_Integer : 1 ] :=
  Module[ { distMatrix, vertexIndex, pairwiseDistances },
    If[ Length[ paths ] <= n, Return[ paths ] ];
    distMatrix = GraphDistanceMatrix[ graph ];
    vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ];
    pairwiseDistances = (# + Transpose[ # ]) & @ PadRight[ Table[
      FrechetDistance[ distMatrix, Lookup[ vertexIndex, paths[[ i ]] ], Lookup[ vertexIndex, paths[[ j ]] ] ],
      { i, Length[ paths ] }, { j, i - 1 } ], { Length[ paths ], Length[ paths ] } ];
    paths[[ DiverseElement[ pairwiseDistances, n ] ]]
  ]

(* ========================= FindChain ========================= *)

Options[ FindChain ] = { "Method" -> "Longest", "MaxPaths" -> All, "TargetDistance" -> 3 };

FindChain[ g_Graph, v1_, v2_, n_Integer, opts : OptionsPattern[] ] :=
  Module[ { negGraph, d, paths, method, maxPaths },
    method = OptionValue[ "Method" ];
    maxPaths = OptionValue[ "MaxPaths" ];
    negGraph = Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ];
    d = Round[ -GraphDistance[ negGraph, v1, v2 ] ];
    If[ ! IntegerQ[ d ] || d < 1, Return[ {} ] ];
    If[ method === "Longest",
      Return[ FindPath[ g, v1, v2, { d }, n ] ]
    ];
    paths = FindPath[ g, v1, v2, { d }, All ];
    If[ paths === {}, Return[ {} ] ];
    If[ maxPaths =!= All, paths = RandomSample[ paths, UpTo[ maxPaths ] ] ];
    If[ method === "Diverse" || method === "Grow",
      Return[ DiversePaths[ g, paths, n ] ]
    ];
    CentralPath[ g, paths, n, "Method" -> method ]
  ]

FindChain[ g_Graph, v1_, v2_, opts : OptionsPattern[] ] /; ! MatchQ[ v2, _Rule | _RuleDelayed ] :=
  FindChain[ g, v1, v2, 1, opts ]

FindChain[ g_Graph, n_Integer, opts : OptionsPattern[] ] :=
  Module[ { sources, sinks, negGraph, distMat, vertexIdx, pairs, lengths, maxLen, bestPairs, allPaths, method, maxPaths, collected,
            targetDistance, undirDistMat, selected, tips, chains, extended, successors, otherTips, best },
    method = OptionValue[ "Method" ];
    maxPaths = OptionValue[ "MaxPaths" ];
    sources = GetSources[ g ];
    sinks = GetSinks[ g ];
    If[ method === "Grow",
      targetDistance = OptionValue[ "TargetDistance" ];
      undirDistMat = GraphDistanceMatrix[ UndirectedGraph[ g ] ];
      vertexIdx = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ];
      Module[ { negDistMat, depthValues, vertexLevel, nLevels, tipLevel },
        negDistMat = -GraphDistanceMatrix[ Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ] ];
        depthValues = MapThread[ Max, negDistMat[[ vertexIdx /@ sources, All ]] ];
        vertexLevel = AssociationThread[ VertexList[ g ], Round /@ depthValues ];
        nLevels = Max[ vertexLevel ];
        selected = { First @ sources };
        Do[
          AppendTo[ selected,
            First @ MaximalBy[ Complement[ sources, selected ],
              s |-> Min[ undirDistMat[[ vertexIdx[ s ], vertexIdx /@ selected ]] ] ] ],
          { Min[ n, Length @ sources ] - 1 }
        ];
        tips = selected;
        chains = List /@ tips;
        Do[
          Do[
            tipLevel = vertexLevel[ tips[[ i ]] ];
            If[ tipLevel >= level, Continue[] ];
            successors = Select[
              Complement[ VertexOutComponent[ g, { tips[[ i ]] }, 1 ], { tips[[ i ]] } ],
              vertexLevel[ # ] == level &
            ];
            If[ successors === {}, Continue[] ];
            otherTips = Delete[ tips, i ];
            best = If[ otherTips === {},
              First @ successors,
              First @ MinimalBy[ successors,
                c |-> Total[ (undirDistMat[[ vertexIdx[ c ], vertexIdx /@ otherTips ]] - targetDistance)^2 ] ]
            ];
            chains[[ i ]] = Append[ chains[[ i ]], best ];
            tips[[ i ]] = best,
            { i, Length @ chains }
          ],
          { level, 1, nLevels }
        ];
        Return[ chains ]
      ]
    ];
    negGraph = Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ];
    distMat = GraphDistanceMatrix[ negGraph ];
    vertexIdx = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ];
    pairs = Tuples[ { sources, sinks } ];
    lengths = -distMat[[ vertexIdx[ #[[ 1 ]] ], vertexIdx[ #[[ 2 ]] ] ]] & /@ pairs;
    maxLen = Max[ lengths ];
    If[ maxLen < 1, Return[ {} ] ];
    bestPairs = pairs[[ Flatten @ Position[ lengths, maxLen ] ]];
    maxLen = Round[ maxLen ];
    If[ method === "Longest",
      collected = {};
      Do[
        collected = Join[ collected, FindPath[ g, bp[[ 1 ]], bp[[ 2 ]], { maxLen }, n - Length[ collected ] ] ];
        If[ Length[ collected ] >= n, Break[] ],
        { bp, bestPairs }
      ];
      Return[ Take[ collected, UpTo[ n ] ] ]
    ];
    allPaths = Join @@ (FindPath[ g, #[[ 1 ]], #[[ 2 ]], { maxLen }, All ] & /@ bestPairs);
    If[ allPaths === {}, Return[ {} ] ];
    If[ maxPaths =!= All, allPaths = RandomSample[ allPaths, UpTo[ maxPaths ] ] ];
    If[ method === "Diverse",
      Return[ DiversePaths[ g, allPaths, n ] ]
    ];
    CentralPath[ g, allPaths, n, "Method" -> method ]
  ]

FindChain[ g_Graph, opts : OptionsPattern[] ] :=
  FindChain[ g, 1, opts ]
