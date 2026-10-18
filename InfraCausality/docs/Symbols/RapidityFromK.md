---
Template: Symbol
Name: RapidityFromK
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RapidityFromK
Keywords: [rapidity, k-factor, logarithm, Bondi k-calculus, light zigzag, bounce count]
SeeAlso: [Rapidity, KFactor, VelocityFromK, LightZigzag, BondiClock]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[RapidityFromK]()[*k*]</code> gives the rapidity $\log k$ of the Bondi factor *k*.

## Details & Options

Definition: the rapidity of the velocity <code>[VelocityFromK]()[*k*]</code>, which is $\log k$. The logarithm turns the multiplication of k-factors under velocity addition into the addition of rapidities.

It also counts bounces: the emission arc lengths of a light zigzag between the observer at rest and the observer with k-factor *k* grow by $k^2$ per round trip ([LightZigzag]()), so from the arc length $s_0$ the zigzag needs $\log(s/s_0) / (2 \log k)$ round trips to reach the arc length *s*.

## Basic Examples

The rapidity of the k-factor 2.

```wl
RapidityFromK[2]
```

The number of round trips of a light zigzag from arc length 1 to arc length 64 between the observers with k-factor 2.

```wl
FullSimplify[Log[64]/(2 RapidityFromK[2])]
```

## Properties and Relations

Rapidities add when k-factors multiply.

```wl
FullSimplify[RapidityFromK[k1 k2] == RapidityFromK[k1] + RapidityFromK[k2], k1 > 0 && k2 > 0]
```

`RapidityFromK` is the [Rapidity]() of the velocity of the k-factor.

```wl
FullSimplify[Rapidity[VelocityFromK[k]] == RapidityFromK[k], k > 0]
```

The round trips of the zigzag of velocity 3/5 from arc length 1 reach the arc lengths $4^n$, so their count is a logarithm of the arc length.

```wl
With[{arcs = Lookup[Select[LightZigzag[3/5, 1, 8, Pi/3], #["Observer"] === "Alice" &], "ArcLength"]},
  FullSimplify[Log[arcs]/(2 RapidityFromK[KFactor[3/5]])] == Range[0, 4]]
```
