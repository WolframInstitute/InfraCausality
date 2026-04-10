(* ::Package:: *)
(* BondiVisualization.wl — Visualization for Bondi k-calculus *)
(* Requires: BondiKCalculus.wl *)
(* Load with: Get["Code/BondiVisualization.wl"] *)


(* === Color Palette === *)

$BondiColors = <|
  "Alice" -> RGBColor[ 0.4, 0.65, 0.95 ],
  "Bob" -> RGBColor[ 0.95, 0.45, 0.45 ],
  "Carol" -> RGBColor[ 0.35, 0.78, 0.45 ],
  "Light" -> RGBColor[ 0.95, 0.82, 0.2 ],
  "LightFaded" -> RGBColor[ 0.92, 0.88, 0.6 ],
  "Event" -> RGBColor[ 0.65, 0.5, 0.85 ],
  "Simultaneity" -> RGBColor[ 0.9, 0.65, 0.35 ],
  "SimAlice" -> RGBColor[ 0.55, 0.75, 0.95 ],
  "SimBob" -> RGBColor[ 0.95, 0.6, 0.6 ],
  "Tick" -> GrayLevel[ 0.35 ],
  "Label" -> GrayLevel[ 0.2 ],
  "Background" -> RGBColor[ 0.98, 0.98, 0.96 ]
|>;


(* === Drawing Helpers === *)

DrawWorldline[ velocity_, range_List, lightAngle_, color_ : Automatic ] :=
  With[ { dir = WorldlineDirection[ velocity, lightAngle ],
           col = If[ color === Automatic,
             Switch[ True, velocity == 0, $BondiColors[ "Alice" ],
                           velocity > 0, $BondiColors[ "Bob" ],
                           True, $BondiColors[ "Carol" ] ],
             color ] },
    { AbsoluteThickness[ 2.5 ], col,
      Line[ { range[[ 1 ]] dir, range[[ 2 ]] dir } ] }
  ]

DrawLightRay[ from_List, to_List, color_ : Automatic ] :=
  { If[ color === Automatic, $BondiColors[ "Light" ], color ],
    AbsoluteThickness[ 1.2 ], Line[ { from, to } ] }

DrawEvent[ point_List, scale_ : 1 ] :=
  { $BondiColors[ "Event" ], EdgeForm[ { GrayLevel[ 0.3 ], AbsoluteThickness[ 0.8 ] } ],
    Disk[ point, 0.01 scale ] }

DrawTicks[ velocity_, tauRange_List, lightAngle_, scale_ : 1 ] :=
  With[ { pScale = ProperTimeScale[ velocity, lightAngle ],
           dir = WorldlineDirection[ velocity, lightAngle ],
           normal = WorldlineNormal[ velocity, lightAngle ],
           tickLen = 0.02 scale },
    { $BondiColors[ "Tick" ], AbsoluteThickness[ 1 ],
      Table[
        With[ { point = (tau / pScale) dir },
          Line[ { point - tickLen normal, point + tickLen normal } ]
        ],
        { tau, tauRange[[ 1 ]], tauRange[[ 2 ]] }
      ] }
  ]

DrawTickLabels[ velocity_, tauRange_List, lightAngle_, scale_ : 1, side_ : -1 ] :=
  With[ { pScale = ProperTimeScale[ velocity, lightAngle ],
           dir = WorldlineDirection[ velocity, lightAngle ],
           normal = WorldlineNormal[ velocity, lightAngle ],
           offset = 0.04 scale },
    Table[
      Text[ Style[ tau, 9, $BondiColors[ "Label" ] ],
        (tau / pScale) dir + side offset normal ],
      { tau, tauRange[[ 1 ]], tauRange[[ 2 ]] }
    ]
  ]

DrawLabel[ text_, point_List, fontSize_ : 10 ] :=
  Text[ Style[ text, fontSize, $BondiColors[ "Label" ] ], point ]

DrawZigzag[ velocity_, emitArc_, nBounces_, lightAngle_, scale_ : 1 ] :=
  With[ { events = LightZigzag[ velocity, emitArc, nBounces, lightAngle ] },
    { { $BondiColors[ "Light" ], AbsoluteThickness[ 1.2 ],
        Line[ #Point & /@ events ] },
      DrawEvent[ #Point, scale ] & /@ events }
  ]

EventLabels[ events_List, k_, startIndex_ : 0, offset_ : { -0.05, 0 } ] :=
  MapIndexed[
    With[ { n = startIndex + First[ #2 ] - 1, obsSign = If[ #1[ "Observer" ] === "Alice", -1, 1 ] },
      Text[
        Style[ Superscript[ "k", n ], 8, $BondiColors[ "Label" ] ],
        #1[ "Point" ] + obsSign Abs[ offset ]
      ]
    ] &,
    events
  ]


(* === SR Constructions === *)

Options[ BondiClock ] = {
  "LightAngle" -> Pi/4,
  "EmitArcLength" -> Automatic,
  "ShowTicks" -> True,
  "ShowTickLabels" -> False,
  "ShowEventLabels" -> False,
  ImageSize -> 500
};

BondiClock[ velocity_, nBounces_ : 8, opts : OptionsPattern[] ] :=
  Module[ { phi, k, alpha, emitArc, events, maxArc, scale, elements },
    phi = OptionValue[ "LightAngle" ];
    k = KFactor[ velocity, phi ] // N;
    alpha = WorldlineAngle[ velocity, phi ];
    emitArc = OptionValue[ "EmitArcLength" ] /. Automatic -> Max[ 0.05, 1.0 / k^(nBounces/2) ];
    events = LightZigzag[ velocity, emitArc, nBounces, phi ];
    maxArc = 1.1 Max[ #ArcLength & /@ events ];
    scale = maxArc;
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi ],
      DrawWorldline[ velocity, { 0, maxArc }, phi ],
      DrawZigzag[ velocity, emitArc, nBounces, phi, scale ]
    };
    If[ OptionValue[ "ShowTicks" ],
      With[ { maxTauAlice = Floor[ maxArc ProperTimeScale[ 0, phi ] ],
              maxTauBob = Floor[ maxArc ProperTimeScale[ velocity, phi ] ] },
        If[ maxTauAlice >= 1,
          AppendTo[ elements, DrawTicks[ 0, { 1, maxTauAlice }, phi, scale ] ] ];
        If[ maxTauBob >= 1,
          AppendTo[ elements, DrawTicks[ velocity, { 1, maxTauBob }, phi, scale ] ] ];
        If[ OptionValue[ "ShowTickLabels" ],
          If[ maxTauAlice >= 1,
            AppendTo[ elements, DrawTickLabels[ 0, { 1, maxTauAlice }, phi, scale, -1 ] ] ];
          If[ maxTauBob >= 1,
            AppendTo[ elements, DrawTickLabels[ velocity, { 1, maxTauBob }, phi, scale, 1 ] ] ]
        ]
      ]
    ];
    If[ OptionValue[ "ShowEventLabels" ],
      AppendTo[ elements,
        EventLabels[ events, k, 0, 0.05 scale { -1, 0 } ]
      ]
    ];
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.06 ]
    ]
  ]


Options[ DopplerConstruction ] = {
  "LightAngle" -> Pi/4,
  "EmitStart" -> 0.15,
  "PulseSpacing" -> 0.12,
  ImageSize -> 500
};

DopplerConstruction[ velocity_, nPulses_ : 6, opts : OptionsPattern[] ] :=
  Module[ { phi, k, alpha, kOut, emitStart, spacing,
            emitArcs, receiveArcs, maxArc, scale, dir, normal, elements },
    phi = OptionValue[ "LightAngle" ];
    k = KFactor[ velocity, phi ] // N;
    alpha = WorldlineAngle[ velocity, phi ];
    kOut = OutgoingRatio[ velocity, phi ];
    dir = WorldlineDirection[ velocity, phi ];
    normal = WorldlineNormal[ velocity, phi ];
    emitStart = OptionValue[ "EmitStart" ];
    spacing = OptionValue[ "PulseSpacing" ];
    emitArcs = Table[ emitStart + n spacing, { n, 0, nPulses - 1 } ];
    receiveArcs = kOut # & /@ emitArcs;
    maxArc = 1.15 Max[ receiveArcs ];
    scale = maxArc;
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi ],
      DrawWorldline[ velocity, { 0, maxArc }, phi ],
      Table[
        DrawLightRay[ { 0, emitArcs[[ i ]] }, receiveArcs[[ i ]] dir ],
        { i, nPulses }
      ],
      DrawEvent[ { 0, # }, scale ] & /@ emitArcs,
      DrawEvent[ # dir, scale ] & /@ receiveArcs,
      { $BondiColors[ "Alice" ], AbsoluteThickness[ 2 ],
        Line[ { { 0, emitArcs[[ 1 ]] }, { 0, emitArcs[[ 2 ]] } } ] },
      { $BondiColors[ "Bob" ], AbsoluteThickness[ 2 ],
        Line[ { receiveArcs[[ 1 ]] dir, receiveArcs[[ 2 ]] dir } ] },
      DrawLabel[ "\[CapitalDelta]\[Tau]",
        { -0.05 scale, (emitArcs[[ 1 ]] + emitArcs[[ 2 ]]) / 2 } ],
      DrawLabel[ "k \[CapitalDelta]\[Tau]",
        (receiveArcs[[ 1 ]] + receiveArcs[[ 2 ]]) / 2 dir + 0.06 scale normal ]
    };
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.06 ]
    ]
  ]


Options[ TimeDilationConstruction ] = {
  "LightAngle" -> Pi/4,
  "EventArcLength" -> 0.6,
  ImageSize -> 500
};

TimeDilationConstruction[ velocity_, opts : OptionsPattern[] ] :=
  Module[ { phi, k, alpha, kOut, kIn, gamma,
            eventArc, bobPoint, emitArc, returnArc, radarArc,
            dir, normal, maxArc, scale, simLine, elements },
    phi = OptionValue[ "LightAngle" ];
    k = KFactor[ velocity, phi ] // N;
    gamma = (k + 1/k) / 2;
    alpha = WorldlineAngle[ velocity, phi ];
    kOut = OutgoingRatio[ velocity, phi ];
    kIn = IncomingRatio[ velocity, phi ];
    dir = WorldlineDirection[ velocity, phi ];
    normal = WorldlineNormal[ velocity, phi ];
    eventArc = OptionValue[ "EventArcLength" ];
    bobPoint = eventArc dir;
    emitArc = eventArc / kOut;
    returnArc = eventArc kIn;
    radarArc = (emitArc + returnArc) / 2;
    maxArc = 1.15 returnArc;
    scale = maxArc;
    simLine = SimultaneityLine[ 0, radarArc, phi, 0.3 scale ];
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi ],
      DrawWorldline[ velocity, { 0, maxArc }, phi ],
      DrawLightRay[ { 0, emitArc }, bobPoint ],
      DrawLightRay[ bobPoint, { 0, returnArc } ],
      { Dashed, AbsoluteThickness[ 1.5 ], $BondiColors[ "Simultaneity" ],
        Line[ simLine ] },
      { AbsoluteThickness[ 2.5 ], $BondiColors[ "Simultaneity" ],
        Line[ { { 0, radarArc }, { 0, radarArc } + 0.01 { 1, 0 } } ] },
      DrawEvent[ { 0, emitArc }, scale ],
      DrawEvent[ bobPoint, scale ],
      DrawEvent[ { 0, returnArc }, scale ],
      DrawEvent[ { 0, radarArc }, scale ],
      DrawLabel[ Subscript[ "\[Tau]", "emit" ], { -0.06 scale, emitArc } ],
      DrawLabel[ Subscript[ "\[Tau]", "B" ], bobPoint + 0.05 scale normal ],
      DrawLabel[ Subscript[ "\[Tau]", "return" ], { -0.06 scale, returnArc } ],
      DrawLabel[ Subscript[ "\[Tau]", "radar" ], { -0.06 scale, radarArc } ],
      DrawLabel[
        Row[ { "\[Gamma] = ", NumberForm[ gamma, { 3, 2 } ] } ],
        { -0.1 scale, maxArc 0.95 }, 9 ],
      DrawTicks[ 0, { 1, Floor[ maxArc ] }, phi, scale ],
      DrawTicks[ velocity, { 1, Max[ 1, Floor[ maxArc ProperTimeScale[ velocity, phi ] ] ] }, phi, scale ]
    };
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.08 ]
    ]
  ]


Options[ SimultaneityConstruction ] = {
  "LightAngle" -> Pi/4,
  "ArcLength" -> 0.7,
  "Extent" -> 0.35,
  ImageSize -> 500
};

SimultaneityConstruction[ velocity_, opts : OptionsPattern[] ] :=
  Module[ { phi, alpha, arcLen, extent, dir, normal, maxArc, scale,
            aliceSim, bobSim, elements },
    phi = OptionValue[ "LightAngle" ];
    alpha = WorldlineAngle[ velocity, phi ];
    dir = WorldlineDirection[ velocity, phi ];
    normal = WorldlineNormal[ velocity, phi ];
    arcLen = OptionValue[ "ArcLength" ];
    extent = OptionValue[ "Extent" ];
    maxArc = arcLen + extent + 0.3;
    scale = maxArc;
    aliceSim = SimultaneityLine[ 0, arcLen, phi, extent ];
    bobSim = SimultaneityLine[ velocity, arcLen, phi, extent ];
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi ],
      DrawWorldline[ velocity, { 0, maxArc }, phi ],
      { AbsoluteThickness[ 2 ], Dashing[ { 0.015, 0.008 } ],
        $BondiColors[ "SimAlice" ], Line[ aliceSim ] },
      { AbsoluteThickness[ 2 ], Dashing[ { 0.015, 0.008 } ],
        $BondiColors[ "SimBob" ], Line[ bobSim ] },
      DrawEvent[ { 0, arcLen }, scale ],
      DrawEvent[ arcLen dir, scale ],
      DrawLabel[ "Alice's now", aliceSim[[ 3 ]] + { 0.04 scale, 0 }, 9 ],
      DrawLabel[ "Bob's now", bobSim[[ 3 ]] + { 0.04 scale, 0 }, 9 ]
    };
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.08 ]
    ]
  ]


Options[ LengthContractionConstruction ] = {
  "LightAngle" -> Pi/4,
  "RodRestLength" -> 0.15,
  "MeasureArcLength" -> 0.6,
  ImageSize -> 500
};

LengthContractionConstruction[ velocity_, opts : OptionsPattern[] ] :=
  Module[ { phi, k, alpha, kOut, kIn, gamma, rodLength, measureArc,
            dir, normal, rodOffset, frontPoint, backPoint,
            emitFront, returnFront, aliceFront,
            radarBack, aliceBack, maxArc, scale, elements },
    phi = OptionValue[ "LightAngle" ];
    k = KFactor[ velocity, phi ] // N;
    gamma = (k + 1/k) / 2;
    alpha = WorldlineAngle[ velocity, phi ];
    kOut = OutgoingRatio[ velocity, phi ];
    kIn = IncomingRatio[ velocity, phi ];
    dir = WorldlineDirection[ velocity, phi ];
    normal = WorldlineNormal[ velocity, phi ];
    rodLength = OptionValue[ "RodRestLength" ];
    measureArc = OptionValue[ "MeasureArcLength" ];
    rodOffset = rodLength normal;
    frontPoint = measureArc dir;
    backPoint = measureArc dir + rodOffset;
    emitFront = measureArc / kOut;
    returnFront = measureArc kIn;
    aliceFront = (emitFront + returnFront) / 2;
    radarBack = RadarCoordinatesFromAlice[ backPoint, phi ];
    aliceBack = radarBack[ "RadarTime" ];
    maxArc = 1.15 Max[ returnFront, radarBack[ "ReturnArcLength" ] ];
    scale = maxArc;
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi ],
      DrawWorldline[ velocity, { 0, maxArc }, phi ],
      { AbsoluteThickness[ 1.5 ], $BondiColors[ "Bob" ], Opacity[ 0.5 ],
        Dashing[ { 0.01, 0.006 } ],
        Line[ { rodOffset, maxArc dir + rodOffset } ] },
      { AbsoluteThickness[ 3 ], $BondiColors[ "Bob" ], Opacity[ 0.6 ],
        Line[ { frontPoint, backPoint } ] },
      DrawLightRay[ { 0, emitFront }, frontPoint, $BondiColors[ "LightFaded" ] ],
      DrawLightRay[ frontPoint, { 0, returnFront }, $BondiColors[ "LightFaded" ] ],
      DrawLightRay[ { 0, radarBack[ "EmitArcLength" ] }, backPoint, $BondiColors[ "LightFaded" ] ],
      DrawLightRay[ backPoint, { 0, radarBack[ "ReturnArcLength" ] }, $BondiColors[ "LightFaded" ] ],
      { AbsoluteThickness[ 3 ], $BondiColors[ "Simultaneity" ],
        Line[ { { -0.01 scale, aliceFront }, { -0.01 scale, aliceBack } } ] },
      DrawEvent[ frontPoint, scale ],
      DrawEvent[ backPoint, scale ],
      DrawEvent[ { 0, aliceFront }, scale ],
      DrawEvent[ { 0, aliceBack }, scale ],
      DrawLabel[ "L",
        (frontPoint + backPoint) / 2 + 0.03 scale dir, 10 ],
      DrawLabel[
        Row[ { "L/\[Gamma] = ", NumberForm[ N[ rodLength / gamma ], { 3, 2 } ] } ],
        { -0.08 scale, (aliceFront + aliceBack) / 2 }, 9 ]
    };
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.08 ]
    ]
  ]


Options[ VelocityAdditionConstruction ] = {
  "LightAngle" -> Pi/4,
  "EmitArcLength" -> 0.2,
  ImageSize -> 550
};

VelocityAdditionConstruction[ v1_, v2_, opts : OptionsPattern[] ] :=
  Module[ { phi, k1, k2, kTotal, vTotal, alpha1, alphaTotal,
            dir1, dirTotal, normal1, normalTotal,
            emitArc, kOut1, kOutTotal,
            bobArc, carolArc, bobPoint, carolPoint,
            maxArc, scale, elements },
    phi = OptionValue[ "LightAngle" ];
    k1 = KFactor[ v1, phi ] // N;
    k2 = KFactor[ v2, phi ] // N;
    kTotal = k1 k2;
    vTotal = VelocityFromK[ kTotal ];
    alpha1 = WorldlineAngle[ v1, phi ];
    alphaTotal = WorldlineAngle[ vTotal, phi ];
    dir1 = WorldlineDirection[ v1, phi ];
    dirTotal = WorldlineDirection[ vTotal, phi ];
    normal1 = WorldlineNormal[ v1, phi ];
    normalTotal = WorldlineNormal[ vTotal, phi ];
    emitArc = OptionValue[ "EmitArcLength" ];
    kOut1 = OutgoingRatio[ v1, phi ];
    kOutTotal = OutgoingRatio[ vTotal, phi ];
    bobArc = emitArc kOut1;
    carolArc = emitArc kOutTotal;
    bobPoint = bobArc dir1;
    carolPoint = carolArc dirTotal;
    maxArc = 1.2 Max[ bobArc, carolArc ];
    scale = maxArc;
    elements = {
      DrawWorldline[ 0, { 0, maxArc }, phi, $BondiColors[ "Alice" ] ],
      DrawWorldline[ v1, { 0, maxArc }, phi, $BondiColors[ "Bob" ] ],
      DrawWorldline[ vTotal, { 0, maxArc }, phi, $BondiColors[ "Carol" ] ],
      DrawLightRay[ { 0, emitArc }, bobPoint ],
      DrawLightRay[ bobPoint, carolPoint ],
      DrawLightRay[ { 0, emitArc }, carolPoint, $BondiColors[ "LightFaded" ] ],
      DrawEvent[ { 0, emitArc }, scale ],
      DrawEvent[ bobPoint, scale ],
      DrawEvent[ carolPoint, scale ],
      DrawLabel[ "Alice", { -0.05 scale, maxArc 0.95 }, 10 ],
      DrawLabel[ "Bob",
        maxArc 0.95 dir1 + 0.04 scale normal1, 10 ],
      DrawLabel[ "Carol",
        maxArc 0.95 dirTotal + 0.04 scale normalTotal, 10 ],
      DrawLabel[
        Column[ {
          Row[ { Subscript[ "k", "1" ], " = ", NumberForm[ k1, { 3, 2 } ] } ],
          Row[ { Subscript[ "k", "2" ], " = ", NumberForm[ k2, { 3, 2 } ] } ],
          Row[ { Subscript[ "k", "1" ], Subscript[ "k", "2" ], " = ", NumberForm[ kTotal, { 3, 2 } ] } ],
          Row[ { Subscript[ "v", "\[CirclePlus]" ], " = ", NumberForm[ N[ vTotal ], { 3, 2 } ] } ]
        }, Spacings -> 0.3 ],
        { -0.12 scale, maxArc 0.5 }, 9 ]
    };
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.1 ]
    ]
  ]


Options[ LightClockConstruction ] = {
  "LightAngle" -> Pi/4,
  "ClockLength" -> 0.12,
  "StartArcLength" -> 0.1,
  ImageSize -> 550
};

LightClockConstruction[ velocity_, nBounces_ : 8, opts : OptionsPattern[] ] :=
  Module[ { phi, alpha, dir, normal, clockLen, startArc,
            mirrorOffset, lightOut, lightIn,
            events, maxArc, scale, elements },
    phi = OptionValue[ "LightAngle" ];
    alpha = WorldlineAngle[ velocity, phi ];
    dir = WorldlineDirection[ velocity, phi ];
    normal = WorldlineNormal[ velocity, phi ];
    clockLen = OptionValue[ "ClockLength" ];
    startArc = OptionValue[ "StartArcLength" ];
    mirrorOffset = clockLen normal;
    lightOut = LightDirection[ phi, True ];
    lightIn = LightDirection[ phi, False ];
    events = NestList[
      Module[ { p = #Point, side = #Side, lightDir, offset, t },
        lightDir = If[ side === "observer", lightOut, lightIn ];
        offset = If[ side === "observer", mirrorOffset, -mirrorOffset ];
        t = (offset[[ 2 ]] dir[[ 1 ]] - offset[[ 1 ]] dir[[ 2 ]]) /
            (lightDir[[ 1 ]] dir[[ 2 ]] - lightDir[[ 2 ]] dir[[ 1 ]]);
        <| "Point" -> p + t lightDir,
           "Side" -> If[ side === "observer", "mirror", "observer" ] |>
      ] &,
      <| "Point" -> startArc dir, "Side" -> "observer" |>,
      nBounces
    ];
    maxArc = 1.1 Max[ Norm /@ (#Point & /@ events) ];
    scale = maxArc;
    elements = {
      { AbsoluteThickness[ 2.5 ], $BondiColors[ "Bob" ],
        Line[ { { 0, 0 }, maxArc dir } ] },
      { AbsoluteThickness[ 1.5 ], $BondiColors[ "Bob" ], Opacity[ 0.4 ],
        Line[ { mirrorOffset, maxArc dir + mirrorOffset } ] },
      { $BondiColors[ "Light" ], AbsoluteThickness[ 1.2 ],
        Line[ #Point & /@ events ] },
      DrawEvent[ #Point, scale ] & /@ Select[ events, #Side === "observer" & ]
    };
    If[ velocity != 0,
      PrependTo[ elements,
        { AbsoluteThickness[ 1.5 ], $BondiColors[ "Alice" ], Opacity[ 0.3 ],
          Line[ { { 0, 0 }, { 0, maxArc } } ] }
      ];
      AppendTo[ elements,
        DrawLabel[ Row[ { "\[Beta] = ", NumberForm[ velocity // N, { 3, 2 } ] } ],
          maxArc dir + 0.05 scale normal, 9 ]
      ]
    ];
    Graphics[ elements,
      AspectRatio -> Automatic,
      ImageSize -> OptionValue[ ImageSize ],
      Background -> $BondiColors[ "Background" ],
      PlotRangePadding -> Scaled[ 0.06 ]
    ]
  ]


(* === Interactive Explorer === *)

BondiExplorer[] :=
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
    { { v2, 0.3, "\[Beta]\[Sub2] (velocity addition)" }, 0.05, 0.85 },
    ControlType -> { SetterBar, Delimiter, Slider, Slider, Slider, Delimiter, Slider },
    TrackedSymbols :> { construction, velocity, lightAngle, bounces, v2 }
  ]
