---
Template: Symbol
Name: BondiClock
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/BondiClock
Keywords: [Bondi clock, light zigzag, k-factor, proper time, figure, Bondi k-calculus, experimental]
SeeAlso: [LightZigzag, BondiKFactor, ProperTimeScale, OutgoingRatio, IncomingRatio, DopplerConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[BondiClock]()[*v*, *n*]</code> draws the rest worldline and the worldline of velocity *v* with a light signal bouncing *n* times between them, and their proper-time ticks.

<code>[BondiClock]()[*v*]</code> draws 8 bounces.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: the figure draws the [LightZigzag]() of velocity *v* from the emission arc length `"EmitArcLength"`: the rest worldline ("Alice", blue), the worldline of velocity *v* ("Bob", red), the light (yellow) and its reflection events (purple). The proper times of the successive events are $s_0, k s_0, k^2 s_0, \dots$, each reception *k* times the emission before it; on Alice's worldline, where proper time is arc length, the reflections are spaced by the factor $k^2$, so the number of bounces is logarithmic in the drawn length. The ticks mark the integer proper times on each worldline, at arc lengths *τ* / <code>[ProperTimeScale]()[*v*, *φ*]</code>, so they are evenly spaced on each worldline and farther apart on the moving one.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"EmitArcLength"` | `Automatic` | the first emission $s_0$; `Automatic` is $\max(0.05, k^{-n/2})$, so the zigzag ends near arc length 1 |
| `"ShowTicks"` | `True` | the integer proper-time ticks |
| `"ShowTickLabels"` | `False` | the tick values |
| `"ShowEventLabels"` | `False` | the label $k^m$ of the *m*-th event, its proper time in units of $s_0$ |
| `ImageSize` | 500 | |

## Basic Examples

The Bondi clock of the velocity 0.4.

```wl
BondiClock[0.4]
```

The velocity 0.7 with six bounces, light at the angle 1, and the tick and event labels.

```wl
BondiClock[0.7, 6, "LightAngle" -> 1.0, "ShowTickLabels" -> True, "ShowEventLabels" -> True]
```

## Properties and Relations

The reflections lie on the moving worldline, and their arc lengths grow by $k^2$ per round trip.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{bob = Select[Cases[BondiClock[v, 8, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity], c |-> c[[1]] > 0]},
    Length[bob] == 4 && Max[Abs[bob - Map[Norm, bob] Table[Through[{Sin, Cos}[WorldlineAngle[v, phi]]], 4]]] < 10^-9 &&
      Max[Abs[Ratios[Map[Norm, bob]] - BondiKFactor[v, phi]^2]] < 10^-9]]]
```

Read in proper time, every event of the zigzag is *k* times the one before, the labels $k^m$.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{taus = Sort @ Map[c |-> If[c[[1]] == 0, c[[2]], ProperTimeScale[v, phi] Norm[c]],
      Cases[BondiClock[v, 8, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity]]},
    Max[Abs[Ratios[taus] - BondiKFactor[v]]] < 10^-9]]]
```

The figure draws the events of [LightZigzag]().

```wl
With[{g = BondiClock[0.4, 8]},
  Max[Abs[Sort[Cases[g, Disk[c_, _] :> c, Infinity]] - Sort[Lookup[LightZigzag[0.4, Max[0.05, BondiKFactor[0.4]^-4], 8], "Point"]]]] < 10^-9]
```
