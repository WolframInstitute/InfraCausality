(* ::Package:: *)
(* EPSVisualization.wl — Visualization for EPS message and echo functions *)
(* Requires: LightRays.wl, EPS.wl *)
(* Load with: Get["Code/EPSVisualization.wl"] *)


$EPSColors = <|
  "Path1" -> RGBColor[ 0.2, 0.5, 0.9 ],
  "Path2" -> RGBColor[ 0.9, 0.3, 0.3 ],
  "LightRay" -> RGBColor[ 0.95, 0.82, 0.2 ],
  "MessageArrow" -> RGBColor[ 0.4, 0.8, 0.4 ],
  "EchoArrow" -> RGBColor[ 0.7, 0.4, 0.9 ],
  "Selected" -> RGBColor[ 1.0, 0.6, 0.0 ]
|>;

VisualizeMessageFunction::usage =
  "VisualizeMessageFunction[g, path1, path2] creates an interactive \
visualization: click a vertex on path1 to see its message connections \
to path2 via light rays.";

VisualizeMessageFunction[ g_Graph, path1_List, path2_List ] :=
  Module[ { msg, allVertices, vertexCoords },
    msg = MultiMessageFunction[ g, path1, path2 ];
    allVertices = VertexList[ g ];
    DynamicModule[ { selectedVertex = First[ path1 ] },
      Dynamic @ With[ {
        targets = Lookup[ msg, selectedVertex, {} ],
        lightRayVertices = OutgoingLightRays[ g, selectedVertex ]
      },
        HighlightGraph[ g,
          {
            Style[ Subgraph[ g, path1 ], Directive[ $EPSColors[ "Path1" ], Thick ] ],
            Style[ Subgraph[ g, path2 ], Directive[ $EPSColors[ "Path2" ], Thick ] ],
            Style[ selectedVertex, Directive[ $EPSColors[ "Selected" ], PointSize[ 0.03 ] ] ],
            Style[ #, Directive[ $EPSColors[ "MessageArrow" ], PointSize[ 0.025 ] ] ] & /@ targets
          },
          VertexLabels -> "Name",
          ImageSize -> 500,
          PlotLabel -> Row[ { "Message from ", selectedVertex, " \[RightArrow] ", targets } ]
        ]
      ],
      Initialization :> (
        vertexCoords = AssociationThread[
          allVertices,
          VertexCoordinates /. AbsoluteOptions[ g ]
        ]
      )
    ]
  ]

VisualizeEchoFunction::usage =
  "VisualizeEchoFunction[g, path1, path2] visualizes the echo function \
on path1 via path2, showing echo arrows along the path.";

VisualizeEchoFunction[ g_Graph, path1_List, path2_List ] :=
  Module[ { echoFn, echoEdges },
    echoFn = MultiEchoFunction[ g, path1, path2 ];
    echoEdges = Flatten @ KeyValueMap[
      { v, targets } |-> (Style[ DirectedEdge[ v, # ], $EPSColors[ "EchoArrow" ] ] & /@ targets),
      Select[ echoFn, # =!= {} & ]
    ];
    HighlightGraph[ g,
      {
        Style[ Subgraph[ g, path1 ], Directive[ $EPSColors[ "Path1" ], Thick ] ],
        Style[ Subgraph[ g, path2 ], Directive[ $EPSColors[ "Path2" ], Thick ] ]
      },
      VertexLabels -> "Name",
      ImageSize -> 500,
      Epilog -> {
        $EPSColors[ "EchoArrow" ], Thick, Arrowheads[ 0.03 ]
      },
      PlotLabel -> "Echo function on Path1 via Path2"
    ]
  ]
