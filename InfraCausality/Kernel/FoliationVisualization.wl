Package["WolframInstitute`InfraCausality`"]

Options[VisualizeFoliatedCausalGraph] = {
  "SliceColorFunction" -> (ColorData["Rainbow"][#] &),
  "ChainColorFunction" -> (ColorData["SunsetColors"][#] &),
  "SliceOpacity" -> 0.3,
  "ChainOpacity" -> 0.7,
  "HighlightThickness" -> 0.03,
  ImageSize -> Automatic
};

foliationHighlightPiece[ emb_Association, scale_, elem_, color_, opacity_, preserveOrder_ ] :=
  Module[{ verts, forcedColor, ordered },
    verts = Replace[ elem, Style[ x_, _ ] :> x ];
    forcedColor = Replace[ elem, { Style[ _, c_ ] :> c, _ :> color } ];
    ordered = If[ TrueQ[ preserveOrder ], verts, SortBy[ verts, First @ emb[ # ] & ] ];
    Which[
      Length @ ordered > 1,
        { Opacity[ opacity ], forcedColor, Line[ Map[ emb, ordered ] ] },
      Length @ ordered == 1,
        { Opacity[ opacity ], forcedColor,
          Rectangle[ emb[ First @ ordered ] - { scale, scale },
            emb[ First @ ordered ] + { scale, scale } ] },
      True, {}
    ]
  ]

VisualizeFoliatedCausalGraph[ g_Graph, foliation_List, chains_List : {},
    opts : OptionsPattern[{VisualizeFoliatedCausalGraph, Graph, Graphics}] ] :=
  Module[{ emb, scale, thickness, sliceCF, chainCF, sliceOp, chainOp,
           numS, numC, coords, sliceGraphics, chainGraphics },
    emb = AssociationThread[ VertexList @ g, GraphEmbedding @ g ];
    coords = Values @ emb;
    thickness = OptionValue[ "HighlightThickness" ];
    scale = If[ Length @ coords >= 1, ( Max @ coords - Min @ coords ) * thickness, thickness ];
    sliceCF = OptionValue[ "SliceColorFunction" ];
    chainCF = OptionValue[ "ChainColorFunction" ];
    sliceOp = OptionValue[ "SliceOpacity" ];
    chainOp = OptionValue[ "ChainOpacity" ];
    numS = Max[ 1, Length @ foliation ];
    numC = Max[ 1, Length @ chains ];
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
      Sequence @@ FilterRules[ { opts }, Options[ Graphics ] ]
    ]
  ]
