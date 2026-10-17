Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: CausalViewers *)

PackageScope[ lightConeReading ]

PackageScope[ messageReading ]

PackageScope[ foliationReading ]

lightConeReading[ g_Graph, v_ ] :=
  <|
    "Event" -> v,
    "Time" -> UniversalTime[ g ][ v ],
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
              InfraCausalFuture[ v ] -> Lighter[ StandardOrange, 0.6 ],
              InfraCausalPast[ v ] -> Lighter[ StandardBlue, 0.6 ],
              InfraFutureLightCone[ v ] -> StandardOrange,
              InfraPastLightCone[ v ] -> StandardBlue,
              { v } -> StandardRed } ],
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
              InfraWalk[ a ] -> StandardBlue,
              InfraWalk[ b ] -> StandardRed,
              rayGraph[ g, Map[ w |-> { a[[ k ]], w }, reading[ "Images" ] ] ] -> StandardOrange,
              reading[ "Images" ] -> StandardGreen,
              { a[[ k ]] } -> StandardMagenta } ],
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
  With[ { height = Max @ UniversalTime @ g },
    Manipulate[
      With[ { reading = foliationReading[ g, k ] },
        Labeled[
          InfraSubstrateHighlight[ g, {
            InfraSlice[ { 0, k - 1 } ] -> Lighter[ StandardBlue, 0.5 ],
            InfraSlice[ k ] -> StandardOrange } ],
          Row[ { "t = ", k, ",  slice ", Length @ reading[ "Slice" ], " events,  earlier ", Length @ reading[ "Earlier" ], " events" } ],
          Top ] ],
      { { k, 0, "Time" }, 0, height, 1, Appearance -> "Labeled" },
      TrackedSymbols :> { k },
      SaveDefinitions -> True
    ]
  ]

BondiViewer[] :=
  Manipulate[
    Switch[ construction,
      "Clock",
        BondiClock[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Doppler",
        DopplerConstruction[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Time Dilation",
        TimeDilationConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Simultaneity",
        SimultaneityConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Length Contraction",
        LengthContractionConstruction[ velocity, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Velocity Addition",
        VelocityAdditionConstruction[ velocity, v2, "LightAngle" -> lightAngle, ImageSize -> 480 ],
      "Light Clock",
        LightClockConstruction[ velocity, bounces, "LightAngle" -> lightAngle, ImageSize -> 480 ]
    ],
    { { construction, "Clock", "Construction" },
      { "Clock", "Doppler", "Time Dilation", "Simultaneity",
        "Length Contraction", "Velocity Addition", "Light Clock" } },
    Delimiter,
    { { velocity, 0.4, "\[Beta]" }, 0.05, 0.9 },
    { { lightAngle, Pi/4, "\[Phi] (light angle)" }, 0.15, Pi/2 - 0.05 },
    { { bounces, 8, "Bounces / Pulses" }, 3, 15, 1 },
    Delimiter,
    { { v2, 0.3, Subscript[ "\[Beta]", "2" ] }, 0.05, 0.85 },
    ControlType -> { SetterBar, Delimiter, Slider, Slider, Slider, Delimiter, Slider },
    TrackedSymbols :> { construction, velocity, lightAngle, bounces, v2 }
  ]
