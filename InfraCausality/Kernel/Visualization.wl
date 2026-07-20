Package["WolframInstitute`InfraCausality`"]


(* Interactive and static visualisations for causal-graph constructions.
   Hosts:
     VisualizeLightRays              click-to-highlight outgoing/incoming rays
     VisualizeFoliatedCausalGraph    overlay slices and chains on an embedding
     VisualizeMessageFunction        EPS message map demo
     VisualizeEchoFunction           EPS echo map overlay                      *)


(* =========================== Light rays =========================== *)

(* Click any vertex to highlight its outgoing (light-ray yellow) and incoming
   (echo purple) light rays.                                                  *)

VisualizeLightRays[ g_Graph ] :=
  DynamicModule[ { vertices, selectedVertex, vertexCoords },
    vertices       = VertexList @ g;
    vertexCoords   = AssociationThread[ vertices, VertexCoordinates /. AbsoluteOptions @ g ];
    selectedVertex = First @ vertices;
    Dynamic @ EventHandler[
      HighlightGraph[ g,
        {
          Style[
            TransitiveReductionGraph @ Subgraph[ g,
              OutgoingLightRays[ VertexOutComponentGraph[ g, selectedVertex ], selectedVertex ]
            ],
            Directive[ $CausalColors[ "LightRay" ], Thick ]
          ],
          Style[
            TransitiveReductionGraph @ Subgraph[ g,
              IncomingLightRays[ VertexInComponentGraph[ g, selectedVertex ], selectedVertex ]
            ],
            Directive[ $CausalColors[ "Echo" ], Thick ]
          ],
          Style[ selectedVertex, Directive[ $CausalColors[ "Accent" ] ] ]
        }
      ],
      { "MouseClicked" :>
        With[ { mp = MousePosition[ "Graphics" ] },
          If[ mp =!= None,
            selectedVertex = First @ MinimalBy[ vertices, EuclideanDistance[ vertexCoords[ # ], mp ] & ]
          ]
        ]
      }
    ]
  ]


(* =========================== Foliated causal graph =========================== *)

Options[ VisualizeFoliatedCausalGraph ] = {
  "SliceColorFunction"   -> ( t |-> Blend[ { Lighter[ $CausalColors[ "Causal" ], 0.5 ], Darker[ $CausalColors[ "Causal" ], 0.25 ] }, t ] ),
  "ChainColorFunction"   -> ( t |-> Blend[ { $CausalColors[ "Observer1" ], $CausalColors[ "Observer3" ], $CausalColors[ "Observer2" ] }, t ] ),
  "SliceOpacity"         -> 0.3,
  "ChainOpacity"         -> 0.7,
  "HighlightThickness"   -> 0.03,
  ImageSize              -> Automatic
};

(* Render a foliation as coloured slices and (optionally) chains as coloured
   poly-lines on top of the graph embedding.                                  *)

VisualizeFoliatedCausalGraph[ g_Graph, foliation_List, chains_List : { },
    opts : OptionsPattern[ { VisualizeFoliatedCausalGraph, Graph, Graphics } ] ] :=
  Module[ { emb, scale, thickness, sliceCF, chainCF, sliceOp, chainOp, numS, numC,
            coords, sliceGraphics, chainGraphics },
    emb       = AssociationThread[ VertexList @ g, GraphEmbedding @ g ];
    coords    = Values @ emb;
    thickness = OptionValue[ "HighlightThickness" ];
    scale     = If[ Length @ coords >= 1, ( Max @ coords - Min @ coords ) thickness, thickness ];
    sliceCF   = OptionValue[ "SliceColorFunction" ];
    chainCF   = OptionValue[ "ChainColorFunction" ];
    sliceOp   = OptionValue[ "SliceOpacity" ];
    chainOp   = OptionValue[ "ChainOpacity" ];
    numS      = Max[ 1, Length @ foliation ];
    numC      = Max[ 1, Length @ chains ];
    sliceGraphics = MapIndexed[
      { elem, idx } |-> foliationHighlightPiece[ emb, scale, elem, sliceCF[ First @ idx / numS ], sliceOp, False ],
      foliation
    ];
    chainGraphics = MapIndexed[
      { elem, idx } |-> foliationHighlightPiece[ emb, scale, elem, chainCF[ First @ idx / numC ], chainOp, True ],
      chains
    ];
    Show[
      g,
      Graphics[ { Thickness[ thickness ], sliceGraphics, chainGraphics } ],
      Sequence @@ FilterRules[ { opts }, Options @ Graphics ]
    ]
  ]


(* =========================== EPS visualisations =========================== *)

PackageScope[ $EPSColors ]
$EPSColors := <|
  "Path1"        -> $CausalColors[ "Observer1" ],
  "Path2"        -> $CausalColors[ "Observer2" ],
  "LightRay"     -> $CausalColors[ "LightRay" ],
  "MessageArrow" -> $CausalColors[ "Observer3" ],
  "EchoArrow"    -> $CausalColors[ "Echo" ],
  "Selected"     -> $CausalColors[ "Accent" ]
|>;


(* Click a vertex on path1 to see its message images on path2 and the
   outgoing light rays that carry them.                                       *)

VisualizeMessageFunction[ g_Graph, path1_List, path2_List ] :=
  With[
    {
      msg = MultiMessageFunction[ g, path1, path2 ]
    },
    DynamicModule[ { selectedVertex = First @ path1 },
      Dynamic @ With[
        {
          targets = Lookup[ msg, selectedVertex, { } ]
        },
        HighlightGraph[ g,
          {
            Style[ Subgraph[ g, path1 ], Directive[ $EPSColors[ "Path1" ], Thick ] ],
            Style[ Subgraph[ g, path2 ], Directive[ $EPSColors[ "Path2" ], Thick ] ],
            Style[ selectedVertex, Directive[ $EPSColors[ "Selected" ], PointSize[ 0.03 ] ] ],
            Style[ #, Directive[ $EPSColors[ "MessageArrow" ], PointSize[ 0.025 ] ] ] & /@ targets
          },
          VertexLabels -> "Name",
          ImageSize    -> 500,
          PlotLabel    -> Row[ { "Message from ", selectedVertex, " \[RightArrow] ", targets } ]
        ]
      ]
    ]
  ]


(* Static overlay of the echo function on path1 via path2. *)

VisualizeEchoFunction[ g_Graph, path1_List, path2_List ] :=
  HighlightGraph[ g,
    {
      Style[ Subgraph[ g, path1 ], Directive[ $EPSColors[ "Path1" ], Thick ] ],
      Style[ Subgraph[ g, path2 ], Directive[ $EPSColors[ "Path2" ], Thick ] ]
    },
    VertexLabels -> "Name",
    ImageSize    -> 500,
    Epilog       -> { $EPSColors[ "EchoArrow" ], Thick, Arrowheads[ 0.03 ] },
    PlotLabel    -> "Echo function on Path1 via Path2"
  ]


(* =========================== Internal helper =========================== *)

(* foliationHighlightPiece: render a single slice or chain element as a Line
   when it has multiple vertices, or as a Rectangle when it is a singleton.
   Top-level helper -- keeps VisualizeFoliatedCausalGraph free of nested
   Module.                                                                    *)

PackageScope[ foliationHighlightPiece ]
foliationHighlightPiece[ emb_Association, scale_, elem_, color_, opacity_, preserveOrder_ ] :=
  With[
    {
      verts       = Replace[ elem, Style[ x_, _ ] :> x ],
      forcedColor = Replace[ elem, { Style[ _, c_ ] :> c, _ :> color } ]
    },
    With[
      {
        ordered = If[ TrueQ @ preserveOrder, verts, SortBy[ verts, First @ emb @ # & ] ]
      },
      Which[
        Length @ ordered > 1,
          { Opacity[ opacity ], forcedColor, Line[ Map[ emb, ordered ] ] },
        Length @ ordered == 1,
          { Opacity[ opacity ], forcedColor,
            Rectangle[
              emb[ First @ ordered ] - { scale, scale },
              emb[ First @ ordered ] + { scale, scale }
            ] },
        True, { }
      ]
    ]
  ]
