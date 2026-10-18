---
Template: Symbol
Name: IncomingRatio
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/IncomingRatio
Keywords: [arc-length ratio, incoming light, Euclidean picture, Bondi k-calculus, sine rule, light zigzag]
SeeAlso: [OutgoingRatio, ProperTimeScale, KFactor, WorldlineAngle, LightZigzag]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[IncomingRatio]()[*v*, *φ*]</code> gives the arc-length ratio $k_{in} = \sin(\varphi + \alpha)/\sin\varphi$ from an emission on the worldline of velocity *v* to its reception on the rest worldline, with *α* = <code>[WorldlineAngle]()[*v*, *φ*]</code>.

<code>[IncomingRatio]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Definition: light emitted at Euclidean arc length *s* on the worldline of velocity *v* and running to the left at the angle *φ* meets the rest worldline at arc length $k_{in}\, s$. In the triangle of the origin, the emission and the reception the angle at the origin is *α* and the angle at the reception is *φ*, so the angle at the emission is $\pi - \varphi - \alpha$ and the sine rule gives $k_{in} = \sin(\varphi + \alpha)/\sin\varphi$.

As with [OutgoingRatio](), $k_{in}$ compares Euclidean arc lengths. In proper times, the reception on the rest worldline is *k* times the emission's proper time <code>[ProperTimeScale]()[*v*, *φ*] *s*</code>: $k_{in} = k \cdot$ `ProperTimeScale`, the symmetry of the two observers that defines the k-factor.

## Basic Examples

The incoming ratio of the velocity 3/5 at the default light angle and at the light angle π/3.

```wl
FullSimplify @ {IncomingRatio[3/5], IncomingRatio[3/5, Pi/3]}
```

The incoming ratio over the velocity for three light angles.

```wl
Plot[Evaluate @ Table[IncomingRatio[v, phi], {phi, {Pi/6, Pi/4, Pi/3}}], {v, 0, 1},
  AxesLabel -> {"v", Subscript["k", "in"]}, PlotStyle -> {StandardBlue, StandardRed, StandardGreen}]
```

## Properties and Relations

The reception at arc length $k_{in}\, s$ lies on the leftgoing light ray from the emission on the moving worldline.

```wl
FullSimplify[With[{e = s Through[{Sin, Cos}[WorldlineAngle[v, phi]]], r = {0, s IncomingRatio[v, phi]}},
  Det[{r - e, {-Sin[phi], Cos[phi]}}] == 0], 0 < v < 1 && 0 < phi < Pi/2 && s > 0]
```

In proper times the incoming light is the k-factor again.

```wl
Simplify[TrigExpand[IncomingRatio[v, phi]^2 == (KFactor[v] ProperTimeScale[v, phi])^2], 0 < v < 1 && 0 < phi < Pi/2]
```

The two ratios multiply to *k*² at every light angle.

```wl
Simplify[TrigExpand[OutgoingRatio[v, phi] IncomingRatio[v, phi]] == KFactor[v]^2, 0 < v < 1 && 0 < phi < Pi/2]
```
