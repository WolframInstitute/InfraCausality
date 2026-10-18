---
Template: Symbol
Name: LengthContractionConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LengthContractionConstruction
Keywords: [length contraction, Lorentz factor, radar measurement, rod, figure, Bondi k-calculus, experimental]
SeeAlso: [LorentzGamma, BondiRadarCoordinates, SimultaneityLine, WorldlineNormal, TimeDilationConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LengthContractionConstruction]()[*v*]</code> draws the radar measurement of a rod moving at velocity *v* by the rest observer, illustrating the contracted length $L/\gamma$.

## Details & Options

Experimental: figure. The figure's layout and options may change, and its printed value is not yet a reading of the drawing (below).

Definition: the rod's front end moves on the worldline of velocity *v* ("Bob", red) and its back end on the parallel worldline (dashed) at the Euclidean distance `"RodRestLength"` *L* along <code>[WorldlineNormal]()[*v*, *φ*]</code>. At the front event at arc length `"MeasureArcLength"` the rod is drawn as a thick segment to the back end; the rest observer ("Alice", blue) radar-locates both ends (four faded light rays), and the orange bar on her worldline spans the radar times of the two ends. The label prints $L/\gamma$ with γ = <code>[LorentzGamma]()[*v*]</code>.

Length contraction holds for the drawn rod: Alice's length of it, the difference of the radar distances of its two worldlines at one radar time, is its rest length (the Minkowski length across the two worldlines along Bob's [SimultaneityLine]()) divided by γ. But the Euclidean normal is not Bob's line of simultaneity, so the drawn rod's rest length is $\gamma L v / \sin\alpha$ (*α* = [WorldlineAngle]()), not *L*, and Alice's length of it is $L v / \sin\alpha$; at *φ* = π/4 that is $L\sqrt{1 + v^2}$. The printed $L/\gamma$ is the contraction of a rod of rest length *L*, not a measurement read off the drawing, and the orange bar is a difference of radar times, not a length.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"RodRestLength"` | 0.15 | the Euclidean offset *L* of the back end |
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

The faded light rays are the radar rays of the two ends: they leave and return to Alice's worldline at the emission and return arc lengths of the ends.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{g = LengthContractionConstruction[v, "LightAngle" -> phi]},
    {ends = Select[Cases[g, Disk[c_, _] :> c, Infinity], c |-> c[[1]] > 0],
     axis = Union @ Select[Flatten[Cases[g, Line[pts_] :> pts, Infinity], 1], c |-> c[[1]] == 0 && c[[2]] != 0]},
    AllTrue[ends, e |-> With[{r = BondiRadarCoordinates[e, phi]},
      Min[Abs[axis[[All, 2]] - r["EmitArcLength"]]] < 10^-9 && Min[Abs[axis[[All, 2]] - r["ReturnArcLength"]]] < 10^-9]]]]]
```

Length contraction on the drawn rod: Alice's length, the difference of the radar distances of the two end worldlines at one radar time, is the rest length along Bob's line of simultaneity divided by γ; the rest length is $\gamma L v / \sin\alpha$.

```wl
AllTrue[Tuples[{{1/5, 3/5, 4/5}, {Pi/6, Pi/4, Pi/3}}], Apply[{v, phi} |->
  With[{len = 3/20, d = WorldlineDirection[v, phi], u = {Tan[phi], v}},
    {n = len WorldlineNormal[v, phi], radar = p |-> Values @ KeyTake[BondiRadarCoordinates[p, phi], {"RadarTime", "RadarDistance"}]},
    {alice = radar[n][[2]] - v radar[n][[1]],
     across = radar[First @ LinearSolve[Transpose[{u, -d}], n] u]},
    {rest = Sqrt[across[[2]]^2 - across[[1]]^2]},
    FullSimplify[{alice == rest/LorentzGamma[v], rest == LorentzGamma[v] len v/Sin[WorldlineAngle[v, phi]]}] === {True, True}]]]
```
