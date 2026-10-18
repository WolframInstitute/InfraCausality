---
Template: Symbol
Name: OutgoingRatio
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/OutgoingRatio
Keywords: [arc-length ratio, outgoing light, Euclidean picture, Bondi k-calculus, sine rule, light zigzag]
SeeAlso: [IncomingRatio, ProperTimeScale, KFactor, WorldlineAngle, LightZigzag, DopplerConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[OutgoingRatio]()[*v*, *φ*]</code> gives the arc-length ratio $k_{out} = \sin\varphi / \sin(\varphi - \alpha)$ from an emission on the rest worldline to its reception on the worldline of velocity *v*, with *α* = <code>[WorldlineAngle]()[*v*, *φ*]</code>.

<code>[OutgoingRatio]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Definition: light emitted at Euclidean arc length *s* on the rest worldline (the point $(0, s)$) and running to the right at the angle *φ* meets the worldline of velocity *v* at arc length $k_{out}\, s$. In the triangle of the origin, the emission and the reception the angle at the origin is *α* and the angle at the reception is $\varphi - \alpha$, so the sine rule gives $k_{out} = \sin\varphi / \sin(\varphi - \alpha)$.

$k_{out}$ is a ratio of Euclidean arc lengths, not of proper times. The proper time on the moving worldline is <code>[ProperTimeScale]()[*v*, *φ*]</code> times arc length, so the ratio of proper times is $k_{out} \cdot$ `ProperTimeScale` $= k$, the k-factor, at every light angle.

## Basic Examples

The outgoing ratio of the velocity 3/5 at the default light angle and at the light angle π/3: arc-length ratios depend on the drawing.

```wl
FullSimplify @ {OutgoingRatio[3/5], OutgoingRatio[3/5, Pi/3]}
```

The outgoing ratio over the velocity for three light angles.

```wl
Plot[Evaluate @ Table[OutgoingRatio[v, phi], {phi, {Pi/6, Pi/4, Pi/3}}], {v, 0, 0.8},
  AxesLabel -> {"v", Subscript["k", "out"]}, PlotStyle -> {StandardBlue, StandardRed, StandardGreen}]
```

## Properties and Relations

The reception at arc length $k_{out}\, s$ lies on the rightgoing light ray from the emission $(0, s)$.

```wl
AllTrue[Tuples[{{1/5, 3/5, 4/5}, {Pi/6, Pi/4, Pi/3}}], Apply[{v, phi} |->
  With[{e = {0, s}, r = s OutgoingRatio[v, phi] Through[{Sin, Cos}[WorldlineAngle[v, phi]]]},
    FullSimplify[Det[{r - e, {Sin[phi], Cos[phi]}}]] === 0]]]
```

The ratio of proper times is the k-factor at every light angle.

```wl
Simplify[TrigExpand[(OutgoingRatio[v, phi] ProperTimeScale[v, phi])^2 == KFactor[v]^2], 0 < v < 1 && 0 < phi < Pi/2]
```

The outgoing and incoming ratios multiply to *k*², the round-trip factor.

```wl
FullSimplify[OutgoingRatio[v] IncomingRatio[v] == KFactor[v]^2, 0 < v < 1]
```
