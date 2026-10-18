---
Template: Symbol
Name: LightClockConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LightClockConstruction
Keywords: [light clock, time dilation, mirror, Lorentz factor, figure, Bondi k-calculus, experimental]
SeeAlso: [ProperTimeScale, LorentzGamma, TimeDilationConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LightClockConstruction]()[*v*, *n*]</code> draws a transverse light clock carried by the observer of velocity *v*, with *n* bounces between the observer and a mirror.

<code>[LightClockConstruction]()[*v*]</code> draws 8 bounces.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: the observer of velocity *v* (red) carries a mirror on the parallel worldline (faint red) at the Euclidean distance `"ClockLength"` along the unit normal $(\cos\alpha, -\sin\alpha)$ of the worldline, α = <code>[WorldlineAngle]()[*v*, *φ*]</code>. Light leaves the observer at arc length `"StartArcLength"`, runs along the light direction $(\sin\varphi, \cos\varphi)$ to the mirror and back along $(-\sin\varphi, \cos\varphi)$, *n* segments in all; each return to the observer (purple) is one tick. Because the two worldlines are parallel, every round trip is the same translate along the worldline, so the ticks are equally spaced in the observer's proper time; the rest observer (faint blue) sees the period γ times longer in radar time. At *v* = 0 the figure is the clock at rest.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"ClockLength"` | 0.12 | the Euclidean distance of the mirror |
| `"StartArcLength"` | 0.1 | the arc length of the first emission |
| `ImageSize` | 550 | |

## Basic Examples

The light clock of the observer of velocity 0.4.

```wl
LightClockConstruction[0.4]
```

The light clock at the velocity 0.7 with light at the angle 1 and six segments.

```wl
LightClockConstruction[0.7, 6, "LightAngle" -> 1.0]
```

## Properties and Relations

The light segments run along the two light directions alternately.

```wl
AllTrue[Tuples[{{0, 0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{ray = First @ Cases[LightClockConstruction[v, 8, "LightAngle" -> phi], Line[pts_ /; Length[pts] > 3] :> pts, Infinity]},
    Max[Abs[Map[Normalize, Differences[ray]] - Map[i |-> {If[OddQ[i], 1, -1] Sin[phi], Cos[phi]}, Range[8]]]] < 10^-9]]]
```

The ticks lie on the moving worldline at equal steps of its proper time, and the rest observer's radar time between ticks is γ times that step.

```wl
AllTrue[Tuples[{{0.3, 0.7}, {Pi/4, 1.1}}], Apply[{v, phi} |->
  With[{ticks = First[Cases[LightClockConstruction[v, 8, "LightAngle" -> phi], Line[pts_ /; Length[pts] > 3] :> pts, Infinity]][[1 ;; -1 ;; 2]]},
    {steps = Differences[ProperTimeScale[v, phi] Map[Norm, ticks]]},
    Max[Abs[ticks - Map[Norm, ticks] Table[Through[{Sin, Cos}[WorldlineAngle[v, phi]]], Length[ticks]]]] < 10^-9 &&
      Max[Abs[steps - First[steps]]] < 10^-9 && Max[Abs[Differences[ticks[[All, 2]]]/steps - LorentzGamma[v]]] < 10^-9]]]
```
