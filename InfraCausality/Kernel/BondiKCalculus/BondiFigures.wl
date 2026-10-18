Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: BondiKCalculus :: BondiFigures *)

PackageScope[ WorldlineDirection ]

PackageScope[ WorldlinePoint ]

PackageScope[ WorldlineNormal ]

PackageScope[ WorldlinePointAtProperTime ]

PackageScope[ LightDirection ]

PackageScope[ SimultaneityLine ]

PackageScope[ bondiColor ]

PackageScope[ bondiGraphics ]

PackageScope[ drawWorldline ]

PackageScope[ drawLightRay ]

PackageScope[ drawEvent ]

PackageScope[ drawTicks ]

PackageScope[ drawTickLabels ]

PackageScope[ drawLabel ]

PackageScope[ drawZigzag ]

PackageScope[ drawEventLabels ]

WorldlineDirection[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Sin[ alpha ], Cos[ alpha ] }
  ]

WorldlinePoint[ velocity_, arcLength_, lightAngle_ : Pi/4 ] :=
  arcLength WorldlineDirection[ velocity, lightAngle ]

WorldlineNormal[ velocity_, lightAngle_ : Pi/4 ] :=
  With[ { alpha = WorldlineAngle[ velocity, lightAngle ] },
    { Cos[ alpha ], -Sin[ alpha ] }
  ]

WorldlinePointAtProperTime[ velocity_, properTime_, lightAngle_ : Pi/4 ] :=
  WorldlinePoint[ velocity, properTime / ProperTimeScale[ velocity, lightAngle ], lightAngle ]

LightDirection[ lightAngle_, rightgoing_ : True ] :=
  If[ rightgoing,
    { Sin[ lightAngle ], Cos[ lightAngle ] },
    { -Sin[ lightAngle ], Cos[ lightAngle ] }
  ]

SimultaneityLine[ velocity_, arcLength_, lightAngle_ : Pi/4, extent_ : 1 ] :=
  With[ { base = arcLength WorldlineDirection[ velocity, lightAngle ],
          along = extent Normalize[ { Tan[ lightAngle ], velocity } ] },
    { base - along, base, base + along }
  ]

bondiColor[ name_String ] :=
  Lookup[
    <|
      "Alice" -> StandardBlue,
      "Bob" -> StandardRed,
      "Carol" -> StandardGreen,
      "Light" -> StandardYellow,
      "LightFaded" -> Lighter[ StandardYellow, 0.5 ],
      "Event" -> StandardPurple,
      "Simultaneity" -> StandardOrange,
      "SimAlice" -> Lighter[ StandardBlue, 0.3 ],
      "SimBob" -> Lighter[ StandardRed, 0.3 ],
      "Tick" -> Darker[ StandardGray, 0.3 ],
      "Label" -> Darker[ StandardGray, 0.6 ],
      "Background" -> Lighter[ StandardGray, 0.95 ]
    |>,
    name
  ]

bondiGraphics[ elements_List, size_, padding_ ] :=
  Graphics[ elements,
    AspectRatio -> Automatic,
    ImageSize -> size,
    Background -> bondiColor[ "Background" ],
    PlotRangePadding -> Scaled[ padding ]
  ]

drawWorldline[ velocity_, range_List, lightAngle_ ] :=
  drawWorldline[ velocity, range, lightAngle,
    Which[ velocity == 0, bondiColor[ "Alice" ], velocity > 0, bondiColor[ "Bob" ], True, bondiColor[ "Carol" ] ] ]

drawWorldline[ velocity_, { from_, to_ }, lightAngle_, color_ ] :=
  With[ { dir = WorldlineDirection[ velocity, lightAngle ] },
    { AbsoluteThickness[ 2.5 ], color, Line[ { from dir, to dir } ] }
  ]

drawLightRay[ from_List, to_List ] :=
  drawLightRay[ from, to, bondiColor[ "Light" ] ]

drawLightRay[ from_List, to_List, color_ ] :=
  { color, AbsoluteThickness[ 1.2 ], Line[ { from, to } ] }

drawEvent[ point_List, scale_ ] :=
  { bondiColor[ "Event" ], EdgeForm[ { Darker[ StandardGray, 0.4 ], AbsoluteThickness[ 0.8 ] } ], Disk[ point, 0.01 scale ] }

drawTicks[ velocity_, { from_, to_ }, lightAngle_, scale_ ] :=
  drawTicks[ velocity, { from, to }, lightAngle, scale, 1 ]

drawTicks[ velocity_, { from_, to_ }, lightAngle_, scale_, spacing_ ] :=
  With[ { pScale = ProperTimeScale[ velocity, lightAngle ],
          dir = WorldlineDirection[ velocity, lightAngle ],
          normal = WorldlineNormal[ velocity, lightAngle ] },
    { bondiColor[ "Tick" ], AbsoluteThickness[ 1 ],
      Map[
        n |-> With[ { point = ( n spacing / pScale ) dir },
          Line[ { point - 0.02 scale normal, point + 0.02 scale normal } ] ],
        Range[ from, to ] ] }
  ]

drawTickLabels[ velocity_, { from_, to_ }, lightAngle_, scale_, side_ ] :=
  With[ { pScale = ProperTimeScale[ velocity, lightAngle ],
          dir = WorldlineDirection[ velocity, lightAngle ],
          normal = WorldlineNormal[ velocity, lightAngle ] },
    Map[
      tau |-> Text[ Style[ tau, 9, bondiColor[ "Label" ] ], ( tau / pScale ) dir + side 0.04 scale normal ],
      Range[ from, to ] ]
  ]

drawLabel[ text_, point_List ] :=
  drawLabel[ text, point, 10 ]

drawLabel[ text_, point_List, fontSize_ ] :=
  Text[ Style[ text, fontSize, bondiColor[ "Label" ] ], point ]

drawZigzag[ velocity_, emitArc_, nBounces_, lightAngle_, scale_ ] :=
  With[ { points = Lookup[ LightZigzag[ velocity, emitArc, nBounces, lightAngle ], "Point" ] },
    { { bondiColor[ "Light" ], AbsoluteThickness[ 1.2 ], Line[ points ] },
      Map[ point |-> drawEvent[ point, scale ], points ] }
  ]

drawEventLabels[ events_List, offset_ ] :=
  MapThread[
    { event, n } |-> Text[
      Style[ Superscript[ "k", n ], 8, bondiColor[ "Label" ] ],
      event[ "Point" ] + If[ event[ "Observer" ] === "Alice", -1, 1 ] { offset, 0 } ],
    { events, Range[ 0, Length[ events ] - 1 ] }
  ]

Options[ BondiClock ] = {
  "LightAngle" -> Pi/4,
  "EmitArcLength" -> Automatic,
  "ShowTicks" -> True,
  "ShowTickLabels" -> False,
  "ShowEventLabels" -> False,
  ImageSize -> 500
}

BondiClock[ velocity_, nBounces_ : 8, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          ticks = TrueQ @ OptionValue[ "ShowTicks" ],
          tickLabels = TrueQ @ OptionValue[ "ShowTickLabels" ] },
    { k = N @ BondiKFactor[ velocity, phi ] },
    { emitArc = Replace[ OptionValue[ "EmitArcLength" ], Automatic -> Max[ 0.05, 1.0 / k^( nBounces / 2 ) ] ] },
    { events = LightZigzag[ velocity, emitArc, nBounces, phi ] },
    { maxArc = 1.1 Max[ Lookup[ events, "ArcLength" ] ] },
    { maxTauAlice = Floor[ maxArc ProperTimeScale[ 0, phi ] ],
      maxTauBob = Floor[ maxArc ProperTimeScale[ velocity, phi ] ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi ],
        drawWorldline[ velocity, { 0, maxArc }, phi ],
        drawZigzag[ velocity, emitArc, nBounces, phi, maxArc ],
        If[ ticks && maxTauAlice >= 1, drawTicks[ 0, { 1, maxTauAlice }, phi, maxArc ], Nothing ],
        If[ ticks && maxTauBob >= 1, drawTicks[ velocity, { 1, maxTauBob }, phi, maxArc ], Nothing ],
        If[ ticks && tickLabels && maxTauAlice >= 1, drawTickLabels[ 0, { 1, maxTauAlice }, phi, maxArc, -1 ], Nothing ],
        If[ ticks && tickLabels && maxTauBob >= 1, drawTickLabels[ velocity, { 1, maxTauBob }, phi, maxArc, 1 ], Nothing ],
        If[ TrueQ @ OptionValue[ "ShowEventLabels" ], drawEventLabels[ events, 0.05 maxArc ], Nothing ]
      },
      OptionValue[ ImageSize ],
      0.06
    ]
  ]

Options[ DopplerConstruction ] = {
  "LightAngle" -> Pi/4,
  "EmitStart" -> 0.15,
  "PulseSpacing" -> 0.12,
  ImageSize -> 500
}

DopplerConstruction[ velocity_, nPulses_ : 6, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          emitStart = OptionValue[ "EmitStart" ],
          spacing = OptionValue[ "PulseSpacing" ] },
    { kOut = OutgoingRatio[ velocity, phi ],
      dir = WorldlineDirection[ velocity, phi ],
      normal = WorldlineNormal[ velocity, phi ],
      emitArcs = Map[ n |-> emitStart + n spacing, Range[ 0, nPulses - 1 ] ] },
    { receiveArcs = kOut emitArcs },
    { maxArc = 1.15 Max[ receiveArcs ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi ],
        drawWorldline[ velocity, { 0, maxArc }, phi ],
        MapThread[ { emit, receive } |-> drawLightRay[ { 0, emit }, receive dir ], { emitArcs, receiveArcs } ],
        Map[ emit |-> drawEvent[ { 0, emit }, maxArc ], emitArcs ],
        Map[ receive |-> drawEvent[ receive dir, maxArc ], receiveArcs ],
        { bondiColor[ "Alice" ], AbsoluteThickness[ 2 ],
          Line[ { { 0, emitArcs[[ 1 ]] }, { 0, emitArcs[[ 2 ]] } } ] },
        { bondiColor[ "Bob" ], AbsoluteThickness[ 2 ],
          Line[ { receiveArcs[[ 1 ]] dir, receiveArcs[[ 2 ]] dir } ] },
        drawLabel[ "\[CapitalDelta]\[Tau]",
          { -0.05 maxArc, ( emitArcs[[ 1 ]] + emitArcs[[ 2 ]] ) / 2 } ],
        drawLabel[ "k \[CapitalDelta]\[Tau]",
          ( receiveArcs[[ 1 ]] + receiveArcs[[ 2 ]] ) / 2 dir + 0.06 maxArc normal ]
      },
      OptionValue[ ImageSize ],
      0.06
    ]
  ]

Options[ TimeDilationConstruction ] = {
  "LightAngle" -> Pi/4,
  "EventArcLength" -> 0.6,
  "TickSpacing" -> Automatic,
  ImageSize -> 500
}

TimeDilationConstruction[ velocity_, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          eventArc = OptionValue[ "EventArcLength" ] },
    { k = N @ BondiKFactor[ velocity, phi ],
      pScale = ProperTimeScale[ velocity, phi ],
      dir = WorldlineDirection[ velocity, phi ],
      normal = WorldlineNormal[ velocity, phi ],
      emitArc = eventArc / OutgoingRatio[ velocity, phi ],
      returnArc = eventArc IncomingRatio[ velocity, phi ] },
    { bobPoint = eventArc dir,
      radarArc = ( emitArc + returnArc ) / 2,
      maxArc = 1.15 Max[ returnArc, eventArc ],
      spacing = Replace[ OptionValue[ "TickSpacing" ], Automatic -> eventArc pScale / 4 ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi ],
        drawWorldline[ velocity, { 0, maxArc }, phi ],
        drawLightRay[ { 0, emitArc }, bobPoint ],
        drawLightRay[ bobPoint, { 0, returnArc } ],
        { Dashed, AbsoluteThickness[ 1.5 ], bondiColor[ "Simultaneity" ],
          Line[ Rest @ SimultaneityLine[ 0, radarArc, phi, First[ bobPoint ] + 0.1 maxArc ] ] },
        { AbsoluteThickness[ 2.5 ], bondiColor[ "Simultaneity" ],
          Line[ { { 0, radarArc }, { 0, radarArc } + 0.01 { 1, 0 } } ] },
        drawEvent[ { 0, emitArc }, maxArc ],
        drawEvent[ bobPoint, maxArc ],
        drawEvent[ { 0, returnArc }, maxArc ],
        drawEvent[ { 0, radarArc }, maxArc ],
        drawLabel[ Subscript[ "\[Tau]", "emit" ], { -0.06 maxArc, emitArc } ],
        drawLabel[ Subscript[ "\[Tau]", "B" ], bobPoint + 0.05 maxArc normal ],
        drawLabel[ Subscript[ "\[Tau]", "return" ], { -0.06 maxArc, returnArc } ],
        drawLabel[ Subscript[ "\[Tau]", "radar" ], { -0.06 maxArc, radarArc } ],
        drawLabel[ Row[ { "\[Gamma] = ", NumberForm[ ( k + 1/k ) / 2, { 3, 2 } ] } ], { -0.1 maxArc, maxArc 0.95 }, 9 ],
        drawTicks[ 0, { 1, Floor[ maxArc / spacing ] }, phi, maxArc, spacing ],
        drawTicks[ velocity, { 1, Floor[ maxArc pScale / spacing ] }, phi, maxArc, spacing ]
      },
      OptionValue[ ImageSize ],
      0.08
    ]
  ]

Options[ SimultaneityConstruction ] = {
  "LightAngle" -> Pi/4,
  "ArcLength" -> 0.7,
  "Extent" -> 0.35,
  ImageSize -> 500
}

SimultaneityConstruction[ velocity_, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          arcLen = OptionValue[ "ArcLength" ],
          extent = OptionValue[ "Extent" ] },
    { maxArc = arcLen + extent + 0.3,
      aliceSim = SimultaneityLine[ 0, arcLen, phi, extent ],
      bobSim = SimultaneityLine[ velocity, arcLen, phi, extent ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi ],
        drawWorldline[ velocity, { 0, maxArc }, phi ],
        { AbsoluteThickness[ 2 ], Dashing[ { 0.015, 0.008 } ], bondiColor[ "SimAlice" ], Line[ aliceSim ] },
        { AbsoluteThickness[ 2 ], Dashing[ { 0.015, 0.008 } ], bondiColor[ "SimBob" ], Line[ bobSim ] },
        drawEvent[ { 0, arcLen }, maxArc ],
        drawEvent[ arcLen WorldlineDirection[ velocity, phi ], maxArc ],
        drawLabel[ "Alice's now", aliceSim[[ 3 ]] + { 0.04 maxArc, 0 }, 9 ],
        drawLabel[ "Bob's now", bobSim[[ 3 ]] + { 0.04 maxArc, 0 }, 9 ]
      },
      OptionValue[ ImageSize ],
      0.08
    ]
  ]

Options[ LengthContractionConstruction ] = {
  "LightAngle" -> Pi/4,
  "RodRestLength" -> 0.15,
  "MeasureArcLength" -> 0.6,
  ImageSize -> 500
}

LengthContractionConstruction[ velocity_, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          rodLength = OptionValue[ "RodRestLength" ],
          measureArc = OptionValue[ "MeasureArcLength" ] },
    { gamma = LorentzFactor[ velocity ],
      dir = WorldlineDirection[ velocity, phi ] },
    { rodOffset = rodLength gamma { Tan[ phi ], velocity },
      frontPoint = measureArc dir },
    { backPoint = frontPoint + rodOffset,
      radarTime = frontPoint[[ 2 ]],
      backStart = rodOffset - ( rodOffset[[ 2 ]] / dir[[ 2 ]] ) dir },
    { frontDistance = velocity radarTime,
      backDistance = velocity radarTime + rodLength / gamma },
    { measureBack = { backDistance Tan[ phi ], radarTime },
      maxArc = 1.15 Max[ radarTime + backDistance, Norm[ backPoint - backStart ] ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi ],
        drawWorldline[ velocity, { 0, maxArc }, phi ],
        { AbsoluteThickness[ 1.5 ], bondiColor[ "Bob" ], Opacity[ 0.5 ], Dashing[ { 0.01, 0.006 } ],
          Line[ { backStart, backStart + maxArc dir } ] },
        { AbsoluteThickness[ 3 ], bondiColor[ "Bob" ], Opacity[ 0.6 ],
          Line[ { frontPoint, backPoint } ] },
        drawLightRay[ { 0, radarTime - frontDistance }, frontPoint, bondiColor[ "LightFaded" ] ],
        drawLightRay[ frontPoint, { 0, radarTime + frontDistance }, bondiColor[ "LightFaded" ] ],
        drawLightRay[ { 0, radarTime - backDistance }, measureBack, bondiColor[ "LightFaded" ] ],
        drawLightRay[ measureBack, { 0, radarTime + backDistance }, bondiColor[ "LightFaded" ] ],
        { AbsoluteThickness[ 3 ], bondiColor[ "Simultaneity" ],
          Line[ { frontPoint, measureBack } ] },
        drawEvent[ frontPoint, maxArc ],
        drawEvent[ backPoint, maxArc ],
        drawEvent[ measureBack, maxArc ],
        drawEvent[ { 0, radarTime }, maxArc ],
        drawLabel[ "L", ( frontPoint + backPoint ) / 2 + 0.04 maxArc dir, 10 ],
        drawLabel[ Subscript[ "\[Tau]", "radar" ], { -0.06 maxArc, radarTime } ],
        drawLabel[ Row[ { "L/\[Gamma] = ", NumberForm[ N[ rodLength / gamma ], { 3, 2 } ] } ],
          measureBack + { 0.08 maxArc, 0 }, 9 ]
      },
      OptionValue[ ImageSize ],
      0.08
    ]
  ]

Options[ VelocityAdditionConstruction ] = {
  "LightAngle" -> Pi/4,
  "EmitArcLength" -> 0.2,
  ImageSize -> 550
}

VelocityAdditionConstruction[ v1_, v2_, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ],
          emitArc = OptionValue[ "EmitArcLength" ] },
    { k1 = N @ BondiKFactor[ v1, phi ],
      k2 = N @ BondiKFactor[ v2, phi ] },
    { vTotal = ( ( k1 k2 )^2 - 1 ) / ( ( k1 k2 )^2 + 1 ) },
    { dir1 = WorldlineDirection[ v1, phi ],
      dirTotal = WorldlineDirection[ vTotal, phi ],
      bobArc = emitArc OutgoingRatio[ v1, phi ],
      carolArc = emitArc OutgoingRatio[ vTotal, phi ] },
    { bobPoint = bobArc dir1,
      carolPoint = carolArc dirTotal,
      maxArc = 1.2 Max[ bobArc, carolArc ] },
    bondiGraphics[
      {
        drawWorldline[ 0, { 0, maxArc }, phi, bondiColor[ "Alice" ] ],
        drawWorldline[ v1, { 0, maxArc }, phi, bondiColor[ "Bob" ] ],
        drawWorldline[ vTotal, { 0, maxArc }, phi, bondiColor[ "Carol" ] ],
        drawLightRay[ { 0, emitArc }, bobPoint ],
        drawLightRay[ bobPoint, carolPoint ],
        drawLightRay[ { 0, emitArc }, carolPoint, bondiColor[ "LightFaded" ] ],
        drawEvent[ { 0, emitArc }, maxArc ],
        drawEvent[ bobPoint, maxArc ],
        drawEvent[ carolPoint, maxArc ],
        drawLabel[ "Alice", { -0.05 maxArc, maxArc 0.95 }, 10 ],
        drawLabel[ "Bob", maxArc 0.95 dir1 + 0.04 maxArc WorldlineNormal[ v1, phi ], 10 ],
        drawLabel[ "Carol", maxArc 0.95 dirTotal + 0.04 maxArc WorldlineNormal[ vTotal, phi ], 10 ],
        drawLabel[
          Column[ {
            Row[ { Subscript[ "k", "1" ], " = ", NumberForm[ k1, { 3, 2 } ] } ],
            Row[ { Subscript[ "k", "2" ], " = ", NumberForm[ k2, { 3, 2 } ] } ],
            Row[ { Subscript[ "k", "1" ], Subscript[ "k", "2" ], " = ", NumberForm[ k1 k2, { 3, 2 } ] } ],
            Row[ { Subscript[ "v", "\[CirclePlus]" ], " = ", NumberForm[ N[ vTotal ], { 3, 2 } ] } ]
          }, Spacings -> 0.3 ],
          { -0.12 maxArc, maxArc 0.5 }, 9 ]
      },
      OptionValue[ ImageSize ],
      0.1
    ]
  ]

Options[ LightClockConstruction ] = {
  "LightAngle" -> Pi/4,
  "ClockLength" -> 0.12,
  "StartArcLength" -> 0.1,
  ImageSize -> 550
}

LightClockConstruction[ velocity_, nBounces_ : 8, opts : OptionsPattern[] ] :=
  With[ { phi = OptionValue[ "LightAngle" ] },
    { dir = WorldlineDirection[ velocity, phi ],
      normal = WorldlineNormal[ velocity, phi ],
      mirrorOffset = OptionValue[ "ClockLength" ] WorldlineNormal[ velocity, phi ] },
    { bounce = event |-> With[
        { lightDir = LightDirection[ phi, event[ "Side" ] === "observer" ],
          offset = If[ event[ "Side" ] === "observer", mirrorOffset, -mirrorOffset ] },
        { t = ( offset[[ 1 ]] dir[[ 2 ]] - offset[[ 2 ]] dir[[ 1 ]] ) / ( lightDir[[ 1 ]] dir[[ 2 ]] - lightDir[[ 2 ]] dir[[ 1 ]] ) },
        <| "Point" -> event[ "Point" ] + t lightDir,
           "Side" -> If[ event[ "Side" ] === "observer", "mirror", "observer" ] |> ] },
    { events = NestList[ bounce, <| "Point" -> OptionValue[ "StartArcLength" ] dir, "Side" -> "observer" |>, nBounces ] },
    { maxArc = 1.1 Max[ Map[ Norm, Lookup[ events, "Point" ] ] ] },
    bondiGraphics[
      {
        If[ velocity != 0,
          { AbsoluteThickness[ 1.5 ], bondiColor[ "Alice" ], Opacity[ 0.3 ], Line[ { { 0, 0 }, { 0, maxArc } } ] },
          Nothing ],
        { AbsoluteThickness[ 2.5 ], bondiColor[ "Bob" ], Line[ { { 0, 0 }, maxArc dir } ] },
        { AbsoluteThickness[ 1.5 ], bondiColor[ "Bob" ], Opacity[ 0.4 ], Line[ { mirrorOffset, maxArc dir + mirrorOffset } ] },
        { bondiColor[ "Light" ], AbsoluteThickness[ 1.2 ], Line[ Lookup[ events, "Point" ] ] },
        Map[ point |-> drawEvent[ point, maxArc ], Lookup[ Select[ events, event |-> event[ "Side" ] === "observer" ], "Point" ] ],
        If[ velocity != 0,
          drawLabel[ Row[ { "\[Beta] = ", NumberForm[ N @ velocity, { 3, 2 } ] } ], maxArc dir + 0.05 maxArc normal, 9 ],
          Nothing ]
      },
      OptionValue[ ImageSize ],
      0.06
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
        "Length Contraction", "Velocity Addition", "Light Clock" },
      ControlType -> SetterBar },
    Delimiter,
    { { velocity, 0.4, "\[Beta]" }, 0.05, 0.9 },
    { { lightAngle, Pi/4, "\[Phi] (light angle)" }, 0.15, Pi/2 - 0.05 },
    { { bounces, 8, "Bounces / Pulses" }, 3, 15, 1 },
    Delimiter,
    { { v2, 0.3, Subscript[ "\[Beta]", "2" ] }, 0.05, 0.85 },
    TrackedSymbols :> { construction, velocity, lightAngle, bounces, v2 },
    SaveDefinitions -> True
  ]
