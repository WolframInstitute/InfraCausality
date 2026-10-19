---
Template: Symbol
Name: KFactor
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/KFactor
Keywords: [Bondi k-calculus, k-factor, Doppler factor, special relativity, velocity addition, light angle]
SeeAlso: [VelocityFromK, LorentzGamma, RapidityFromK, OutgoingRatio, IncomingRatio, ProperTimeScale, DopplerConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[KFactor]()[*v*]</code> gives the Bondi factor $k = \sqrt{(1 + v)/(1 - v)}$ of the velocity *v*.

<code>[KFactor]()[*v*, *φ*]</code> gives its angular form $\sqrt{\sin(\varphi + \alpha)/\sin(\varphi - \alpha)}$ in the Euclidean picture with light at angle *φ*, where *α* = <code>[WorldlineAngle]()[*v*, *φ*]</code>.

## Details & Options

Definition: two inertial observers meet at an event. When one emits light signals at proper-time interval *T*, the other receives them at proper-time interval *kT*; the constant *k* is the Bondi factor, and the symmetry of the two observers makes it the same in both directions. Radar then gives $k = \sqrt{(1 + v)/(1 - v)}$ for the relative velocity *v*, in units with the speed of light 1.

In the Euclidean picture of the guide the observer at rest is the time axis, light runs at the angle *φ* to it, and the observer of velocity *v* is the ray at the angle *α* with tan *α* = *v* tan *φ*. The angular form is the k-factor read off this picture, and it does not depend on *φ*: the picture is a family of drawings of one Minkowski plane.

*k* > 1 for a receding observer (0 < *v* < 1), *k* = 1 at rest and *k* < 1 for an approaching one; *k*(−*v*) = 1/*k*(*v*). Velocities compose by multiplying their k-factors.

## Basic Examples

The k-factor of the velocity 3/5 is 2.

```wl
KFactor[3/5]
```

The angular form gives the same value at the light angle π/3.

```wl
FullSimplify @ KFactor[3/5, Pi/3]
```

The k-factor over the velocity, on a logarithmic scale, where *k*(−*v*) = 1/*k*(*v*) is a reflection.

```wl
LogPlot[KFactor[v], {v, -0.95, 0.95}, AxesLabel -> {"v", "k"}, PlotStyle -> StandardBlue]
```

## Properties and Relations

The angular form does not depend on the light angle.

```wl
Simplify[TrigExpand[KFactor[v, phi]^2] == KFactor[v]^2, 0 < v < 1 && 0 < phi < Pi/2]
```

Reversing the velocity inverts the k-factor.

```wl
FullSimplify[KFactor[-v] == 1/KFactor[v], -1 < v < 1]
```

The k-factors of two velocities multiply to the k-factor of their relativistic sum.

```wl
FullSimplify[KFactor[v1] KFactor[v2] == KFactor[(v1 + v2)/(1 + v1 v2)], 0 < v1 < 1 && 0 < v2 < 1]
```

The arc-length ratios of the outgoing and the incoming light multiply to *k*².

```wl
Simplify[TrigExpand[OutgoingRatio[v, phi] IncomingRatio[v, phi]] == KFactor[v]^2, 0 < v < 1 && 0 < phi < Pi/2]
```

The k-factor inverts [VelocityFromK]() and is the exponential of the rapidity.

```wl
FullSimplify[KFactor[VelocityFromK[k]] == k && KFactor[v] == Exp[Rapidity[v]], k > 0 && -1 < v < 1]
```
