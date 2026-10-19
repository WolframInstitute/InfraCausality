---
Template: Symbol
Name: SimultaneityConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/SimultaneityConstruction
Keywords: [relativity of simultaneity, simultaneity line, radar time, Einstein synchronisation, figure, Bondi k-calculus, experimental]
SeeAlso: [BondiRadarCoordinates, TimeDilationConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[SimultaneityConstruction]()[*v*]</code> draws the simultaneity lines of the rest observer and of the observer of velocity *v* at a common arc length, illustrating the relativity of simultaneity.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: on each worldline the figure marks the event at arc length `"ArcLength"` and draws through it the observer's line of simultaneity, the events whose radar emission and return are equally far before and after it on that worldline. For the rest observer ("Alice's now") the line is horizontal; for the observer of velocity *v* ("Bob's now") it runs along $(\tan\varphi, v)$, the slope *v* at *φ* = π/4: the mirror image of the worldline in the light direction. The two observers disagree on which events are simultaneous.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"ArcLength"` | 0.7 | the arc length of the two marked events |
| `"Extent"` | 0.35 | the Euclidean half-length of each line |
| `ImageSize` | 500 | |

## Basic Examples

The two lines of simultaneity at the velocity 0.4.

```wl
SimultaneityConstruction[0.4]
```

The velocity 0.8 with light at the angle 1.2.

```wl
SimultaneityConstruction[0.8, "LightAngle" -> 1.2]
```

## Properties and Relations

Every point of each drawn line has its radar midpoint on that observer's worldline at the marked event: light sent from the worldline to the point and returned to it leaves and arrives equally far before and after the event.

```wl
AllTrue[Tuples[{{0, 0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{lines = Cases[SimultaneityConstruction[v, "LightAngle" -> phi], Line[pts : {_, _, _}] :> pts, Infinity]},
    {midpoint = {p, u} |-> Mean[Map[right |-> First @ LinearSolve[Transpose[{Through[{Sin, Cos}[WorldlineAngle[u, phi]]], {If[right, 1, -1] Sin[phi], Cos[phi]}}], p], {True, False}]]},
    Length[lines] == 2 && AllTrue[Transpose[{lines, {0, v}}], Apply[{pts, u} |->
      AllTrue[pts, p |-> Abs[midpoint[p, u] - 0.7] < 10^-9]]]]]]
```

At the light angle π/4, Alice's line is horizontal and Bob's has slope *v*.

```wl
AllTrue[{0.2, 0.5, 0.8}, v |->
  With[{lines = Cases[SimultaneityConstruction[v], Line[pts : {_, _, _}] :> pts, Infinity]},
    Max[Abs[Map[pts |-> (pts[[3, 2]] - pts[[1, 2]])/(pts[[3, 1]] - pts[[1, 1]]), lines] - {0, v}]] < 10^-9]]
```
