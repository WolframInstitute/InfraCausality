Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: CausalViewers *)

PackageScope[ lightConeReading ]

PackageScope[ messageReading ]

PackageScope[ foliationReading ]

lightConeReading[ g_Graph, v_ ] :=
  <|
    "Event" -> v,
    "Time" -> CausalHeight[ g ][ v ],
    "Future" -> Keys @ InfraMeasurement[ g, InfraCausalFuture[ v ], "VertexDensity" ],
    "Past" -> Keys @ InfraMeasurement[ g, InfraCausalPast[ v ], "VertexDensity" ],
    "FutureLightCone" -> Keys @ InfraMeasurement[ g, InfraFutureLightCone[ v ], "VertexDensity" ],
    "PastLightCone" -> Keys @ InfraMeasurement[ g, InfraPastLightCone[ v ], "VertexDensity" ],
    "FutureRays" -> InfraMeasurement[ g, InfraFutureLightCone[ v ], "Cardinality" ],
    "PastRays" -> InfraMeasurement[ g, InfraPastLightCone[ v ], "Cardinality" ]
  |>

messageReading[ g_Graph, a_List, b_List, v_ ] :=
  With[ { images = Lookup[ InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ], Key[ v ], { } ],
          tree = InfraMeasurement[ g, InfraFutureLightCone[ v ], "Graph" ] },
    <|
      "Tick" -> v,
      "Images" -> images,
      "Rays" -> Map[ w |-> FindShortestPath[ tree, v, w ], images ]
    |>
  ]

foliationReading[ g_Graph, k_Integer ] :=
  <|
    "Time" -> k,
    "Slice" -> Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ],
    "Earlier" -> Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k - 1 } ], "VertexDensity" ]
  |>

LightConeViewer[ g_Graph ] :=
  With[ { nearest = Nearest[ GraphEmbedding[ g ] -> VertexList[ g ] ],
          start = First @ GraphCenter @ UndirectedGraph @ g },
    Manipulate[
      With[ { reading = lightConeReading[ g, v ] },
        Labeled[
          EventHandler[
            InfraSubstrateHighlight[ g, {
              InfraCausalFuture[ v ] -> $causalColors[ "Future" ],
              InfraCausalPast[ v ] -> $causalColors[ "Past" ],
              InfraFutureLightCone[ v ] -> $causalColors[ "Light" ],
              InfraPastLightCone[ v ] -> $causalColors[ "PastLight" ],
              { v } -> $causalColors[ "Marker" ] } ],
            { "MouseClicked" :> With[ { mp = MousePosition[ "Graphics" ] },
              If[ mp =!= None, v = First @ nearest[ mp ] ] ] },
            PassEventsDown -> True ],
          Row[ {
            "event ", v, ",  t = ", reading[ "Time" ],
            ",  |J+| = ", Length @ reading[ "Future" ], ",  |J-| = ", Length @ reading[ "Past" ],
            ",  rays out ", reading[ "FutureRays" ], ",  rays in ", reading[ "PastRays" ] } ],
          Top ] ],
      { { v, start }, None },
      TrackedSymbols :> { v },
      SaveDefinitions -> True
    ]
  ]

MessageFunctionViewer[ g_Graph, a_List, b_List ] :=
  With[ { nearest = Nearest[ Lookup[ AssociationThread[ VertexList[ g ], GraphEmbedding[ g ] ], a ] -> Range @ Length @ a ] },
    Manipulate[
      With[ { reading = messageReading[ g, a, b, a[[ k ]] ] },
        Labeled[
          EventHandler[
            InfraSubstrateHighlight[ g, {
              InfraWalk[ a ] -> $causalColors[ "Worldline" ],
              InfraWalk[ b ] -> $causalColors[ "Observer" ],
              rayGraph[ g, Map[ w |-> { a[[ k ]], w }, reading[ "Images" ] ] ] -> $causalColors[ "Light" ],
              reading[ "Images" ] -> $causalColors[ "Image" ],
              { a[[ k ]] } -> $causalColors[ "Marker" ] } ],
            { "MouseClicked" :> With[ { mp = MousePosition[ "Graphics" ] },
              If[ mp =!= None, k = First @ nearest[ mp ] ] ] },
            PassEventsDown -> True ],
          Row[ { "message from ", a[[ k ]], " to ", reading[ "Images" ] } ],
          Top ] ],
      { { k, 1, "Tick" }, 1, Length @ a, 1, Appearance -> "Labeled" },
      TrackedSymbols :> { k },
      SaveDefinitions -> True
    ]
  ]

FoliationViewer[ g_Graph ] :=
  With[ { height = Max @ CausalHeight @ g },
    Manipulate[
      With[ { reading = foliationReading[ g, k ] },
        Labeled[
          InfraSubstrateHighlight[ g, {
            InfraSlice[ { 0, k - 1 } ] -> $causalColors[ "Earlier" ],
            InfraSlice[ k ] -> $causalColors[ "Slice" ] } ],
          Row[ { "t = ", k, ",  slice ", Length @ reading[ "Slice" ], " events,  earlier ", Length @ reading[ "Earlier" ], " events" } ],
          Top ] ],
      { { k, 0, "Time" }, 0, height, 1, Appearance -> "Labeled" },
      TrackedSymbols :> { k },
      SaveDefinitions -> True
    ]
  ]
