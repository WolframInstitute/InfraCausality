---
Template: Symbol
Name: Rapidity
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/Rapidity
Keywords: [rapidity, ArcTanh, velocity addition, Bondi k-calculus, k-factor, hyperbolic angle]
SeeAlso: [BondiKFactor, LorentzFactor]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[Rapidity]()[*v*]</code> gives the rapidity $\theta = \operatorname{artanh} v$ of the velocity *v*.

## Details & Options

Definition: the rapidity is the hyperbolic angle $\theta$ with $v = \tanh\theta$. It is the logarithm of the k-factor, $\theta = \log k$, so rapidities add where k-factors multiply: the rapidity is the additive parameter of the boosts of the Minkowski plane.

The result is `ArcTanh[v]`, exact for exact *v*.

## Basic Examples

The rapidity of the velocity 3/5 is log 2, the logarithm of its k-factor 2.

```wl
{Rapidity[3/5], FullSimplify[Rapidity[3/5] == Log[2]]}
```

The rapidity over the velocity; it diverges at the speed of light.

```wl
Plot[Rapidity[v], {v, -0.99, 0.99}, AxesLabel -> {"v", "\[Theta]"}, PlotStyle -> StandardBlue]
```

## Properties and Relations

The rapidity of the relativistic sum of two velocities is the sum of their rapidities.

```wl
FullSimplify[Rapidity[(v1 + v2)/(1 + v1 v2)] == Rapidity[v1] + Rapidity[v2], -1 < v1 < 1 && -1 < v2 < 1]
```

The rapidity is the logarithm of the k-factor, and its hyperbolic tangent is the velocity.

```wl
FullSimplify[Log[BondiKFactor[v]] == Rapidity[v] && Tanh[Rapidity[v]] == v, 0 < v < 1]
```
