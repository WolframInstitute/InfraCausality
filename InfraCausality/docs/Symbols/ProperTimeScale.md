---
Template: Symbol
Name: ProperTimeScale
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/ProperTimeScale
Keywords: [proper time, arc length, Euclidean picture, Bondi k-calculus, Minkowski interval, radar coordinates]
SeeAlso: [OutgoingRatio, IncomingRatio, KFactor, BondiRadarCoordinates, WorldlinePointAtProperTime, LorentzGamma, TimeDilationConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[ProperTimeScale]()[*v*, *φ*]</code> gives the ratio of proper time to Euclidean arc length on the worldline of velocity *v* for light at angle *φ*, $k / k_{out} = \sqrt{\sin(\varphi + \alpha)\sin(\varphi - \alpha)}/\sin\varphi$.

<code>[ProperTimeScale]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Definition: <code>[KFactor]()[*v*, *φ*] / [OutgoingRatio]()[*v*, *φ*]</code>. Proper time is the Minkowski length $\sqrt{t^2 - x^2}$ of the radar coordinates ([BondiRadarCoordinates]()), and on a straight worldline through the origin it is linear in Euclidean arc length: the event at arc length *s* on the worldline of velocity *v* has proper time `ProperTimeScale[v, phi]` *s* exactly.

So proper-time ticks are evenly spaced along each worldline; the rest worldline has scale 1, and the scale of a moving worldline is $\sqrt{1 - \sin^2\alpha / \sin^2\varphi} < 1$, equal to $\sqrt{(1 - v^2)/(1 + v^2)}$ at *φ* = π/4. What grows logarithmically with arc length is the bounce count of a [LightZigzag](), not the proper time.

## Basic Examples

The proper-time scale of the velocity 3/5 at the default light angle.

```wl
FullSimplify @ ProperTimeScale[3/5]
```

The proper-time scale over the velocity for three light angles: it is 1 at rest and falls to 0 at the speed of light.

```wl
Plot[Evaluate @ Table[ProperTimeScale[v, phi], {phi, {Pi/6, Pi/4, Pi/3}}], {v, 0, 1},
  AxesLabel -> {"v", "\[Tau]/s"}, PlotStyle -> {StandardBlue, StandardRed, StandardGreen}]
```

## Properties and Relations

The radar interval of the event at arc length *s* on the worldline of velocity *v* is `ProperTimeScale` times *s*: proper time is linear in arc length.

```wl
With[{interval = {v, phi, s} |-> With[{r = BondiRadarCoordinates[s WorldlineDirection[v, phi], phi]}, r["RadarTime"]^2 - r["RadarDistance"]^2]},
  FullSimplify[Sqrt[interval[3/5, Pi/3, s]] == ProperTimeScale[3/5, Pi/3] s, s > 0] &&
    Simplify[TrigExpand[interval[v, phi, s] == ProperTimeScale[v, phi]^2 s^2], 0 < v < 1 && 0 < phi < Pi/2]]
```

Arc length is proper time on the rest worldline at every light angle.

```wl
FullSimplify[ProperTimeScale[0, phi] == 1, 0 < phi < Pi/2]
```

At the light angle π/4 the scale is $\sqrt{(1 - v^2)/(1 + v^2)}$, and at every light angle it is $\sqrt{1 - \sin^2\alpha/\sin^2\varphi}$.

```wl
FullSimplify[TrigExpand[ProperTimeScale[v, Pi/4]] == Sqrt[(1 - v^2)/(1 + v^2)], 0 < v < 1] &&
  Simplify[TrigExpand[ProperTimeScale[v, phi]^2 == 1 - Sin[WorldlineAngle[v, phi]]^2/Sin[phi]^2], 0 < v < 1 && 0 < phi < Pi/2]
```

The scale converts both arc-length ratios to the k-factor: $k_{out} \cdot$ scale $= k$ and $k_{in} = k \cdot$ scale.

```wl
Simplify[TrigExpand[{(OutgoingRatio[v, phi] ProperTimeScale[v, phi])^2 == KFactor[v]^2,
  IncomingRatio[v, phi]^2 == (KFactor[v] ProperTimeScale[v, phi])^2}], 0 < v < 1 && 0 < phi < Pi/2] === {True, True}
```
