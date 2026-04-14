Package["WolframInstitute`InfraCausality`"]

VisualizeLightRays[ g_Graph ] :=
  DynamicModule[ { vertices, selectedVertex, vertexCoords },
    vertices = VertexList[ g ];
    vertexCoords =
      AssociationThread[ vertices, VertexCoordinates /. AbsoluteOptions[ g ] ];
    selectedVertex = First[ vertices ];
    Dynamic @ EventHandler[
      HighlightGraph[ g,
        { Style[
          TransitiveReductionGraph @
            Subgraph[ g,
              OutgoingLightRays[ VertexOutComponentGraph[ g, selectedVertex ],
                selectedVertex ] ], Directive[ Yellow, Thick ] ],
          Style[
            TransitiveReductionGraph @
              Subgraph[ g,
                IncomingLightRays[ VertexInComponentGraph[ g, selectedVertex ],
                  selectedVertex ] ], Directive[ Purple, Thick ] ],
          Style[ selectedVertex, Directive[ Red ] ]
        } ],
      { "MouseClicked" :>
        With[ { mp = MousePosition[ "Graphics" ] },
          If[ mp =!= None,
            selectedVertex =
              First @ MinimalBy[ vertices, EuclideanDistance[ vertexCoords[ # ], mp ] & ] ] ] }
    ]
  ]
