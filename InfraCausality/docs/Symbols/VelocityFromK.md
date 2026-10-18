---
Template: Symbol
Name: VelocityFromK
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/VelocityFromK
Keywords: [Bondi k-calculus, k-factor, velocity, velocity addition, special relativity]
SeeAlso: [KFactor, RapidityFromK, LorentzGamma, VelocityAdditionConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[VelocityFromK]()[*k*]</code> gives the velocity $(k^2 - 1)/(k^2 + 1)$ of the Bondi factor *k*.

## Details & Options

Definition: the velocity *v* with <code>[KFactor]()[*v*]</code> = *k*. Solving $k^2 = (1 + v)/(1 - v)$ for *v* gives $v = (k^2 - 1)/(k^2 + 1)$, a velocity in (−1, 1) for every *k* > 0, in units with the speed of light 1.

Radar reads the velocity this way: an observer who sends a signal at proper time *T* and receives its echo at $k^2 T$ assigns the reflecting observer the radar distance $(k^2 - 1)T/2$ at the radar time $(k^2 + 1)T/2$, whose ratio is the velocity.

The relativistic sum of two velocities is <code>[VelocityFromK]()[[KFactor]()[*v*1] [KFactor]()[*v*2]]</code>, since k-factors multiply.

## Basic Examples

The k-factor 2 is the velocity 3/5, and its inverse the velocity −3/5.

```wl
{VelocityFromK[2], VelocityFromK[1/2]}
```

The velocity over the k-factor: it tends to the speed of light as *k* grows.

```wl
Plot[VelocityFromK[k], {k, 0, 6}, AxesLabel -> {"k", "v"}, PlotRange -> {-1, 1}, PlotStyle -> StandardBlue]
```

## Properties and Relations

`VelocityFromK` inverts [KFactor]().

```wl
FullSimplify[VelocityFromK[KFactor[v]] == v && KFactor[VelocityFromK[k]] == k, -1 < v < 1 && k > 0]
```

Inverting the k-factor reverses the velocity.

```wl
FullSimplify[VelocityFromK[1/k] == -VelocityFromK[k]]
```

The velocity of the product of two k-factors is the relativistic sum of their velocities.

```wl
FullSimplify[VelocityFromK[KFactor[v1] KFactor[v2]] == (v1 + v2)/(1 + v1 v2), -1 < v1 < 1 && -1 < v2 < 1]
```

The radar distance and the radar time of the echo at $k^2 T$ have the ratio `VelocityFromK[k]`.

```wl
FullSimplify[((k^2 - 1) T/2)/((k^2 + 1) T/2) == VelocityFromK[k], k > 0 && T > 0]
```
