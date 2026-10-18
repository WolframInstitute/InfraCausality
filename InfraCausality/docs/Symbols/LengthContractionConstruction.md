---
Template: Symbol
Name: LengthContractionConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LengthContractionConstruction
Keywords: [length contraction, Lorentz factor, radar measurement, rod, figure, Bondi k-calculus, experimental]
SeeAlso: [LorentzGamma, BondiRadarCoordinates, TimeDilationConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LengthContractionConstruction]()[*v*]</code> draws the radar measurement of a rod moving at velocity *v* by the rest observer, illustrating the contracted length $L/\gamma$.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: the rod's front end moves on the worldline of velocity *v* ("Bob", red) and its back end on the parallel worldline (dashed) at the Minkowski distance `"RodRestLength"` *L* along Bob's line of simultaneity, the direction $(\tan\varphi, v)$ of his line of simultaneity: the Euclidean offset is $\gamma L\,(\tan\varphi, v)$ with γ = <code>[LorentzGamma]()[*v*]</code>. At the front event *F* at arc length `"MeasureArcLength"` the rod is drawn as a thick red segment from *F* to its back end, of rest length *L*. The rest observer ("Alice", blue) measures the rod at one radar time, the radar time $\tau_{radar}$ of *F*: the orange bar is her line of simultaneity through *F* (horizontal) to the back end's worldline, and the four faded light rays are her radar rays to the two ends of the bar. In her radar coordinates the two worldlines are $X = v\,T$ and $X = v\,T + L/\gamma$, so the bar has length $L/\gamma$, which the label prints.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"RodRestLength"` | 0.15 | the rest length *L* of the rod |
| `"MeasureArcLength"` | 0.6 | the arc length of the front event |
| `ImageSize` | 500 | |

## Basic Examples

The rod at the velocity 0.4.

```wl
LengthContractionConstruction[0.4]
```

The rod at the velocity 0.7 with light at the angle 1.

```wl
LengthContractionConstruction[0.7, "LightAngle" -> 1.0]
```

## Properties and Relations

The two ends of the orange bar have the same radar time, and the faded light rays are their radar rays: they leave and return to Alice's worldline at the emission and return arc lengths of the ends.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{lines = Cases[LengthContractionConstruction[v, "LightAngle" -> phi], Line[pq : {_, _}] :> pq, Infinity]},
    {bar = First @ Select[lines, pq |-> Abs[pq[[2, 2]] - pq[[1, 2]]] < 10^-9],
     axis = Union @ Select[Flatten[lines, 1], c |-> c[[1]] == 0 && c[[2]] != 0]},
    AllTrue[bar, e |-> With[{r = BondiRadarCoordinates[e, phi]},
      Min[Abs[axis[[All, 2]] - r["EmitArcLength"]]] < 10^-9 && Min[Abs[axis[[All, 2]] - r["ReturnArcLength"]]] < 10^-9]]]]]
```

Read off the drawing, with the Minkowski length of a spacelike Euclidean vector $(x, y)$ being $\sqrt{(x/\tan\varphi)^2 - y^2}$: the rod, the segment along $(\tan\varphi, v)$, has rest length *L*, and the orange bar, the horizontal segment, has length $L/\gamma$, and both start at the front event.

```wl
AllTrue[Tuples[{{1/5, 3/5, 4/5}, {Pi/6, Pi/4, Pi/3}}], Apply[{v, phi} |->
  With[{len = 3/20, length = pq |-> Sqrt[((pq[[2, 1]] - pq[[1, 1]])/Tan[phi])^2 - (pq[[2, 2]] - pq[[1, 2]])^2]},
    {lines = Cases[LengthContractionConstruction[v, "LightAngle" -> phi, "RodRestLength" -> len, "MeasureArcLength" -> 3/5], Line[pq : {_, _}] :> pq, Infinity]},
    {rod = First @ Select[lines, pq |-> Abs[N @ Det[{pq[[2]] - pq[[1]], {Tan[phi], v}}]] < 10^-9],
     bar = First @ Select[lines, pq |-> Abs[N[pq[[2, 2]] - pq[[1, 2]]]] < 10^-9]},
    rod[[1]] == bar[[1]] && FullSimplify[{length[rod] == len, length[bar] == len/LorentzGamma[v]}] === {True, True}]]]
```
