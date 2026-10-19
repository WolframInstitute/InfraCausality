---
Template: Symbol
Name: LorentzFactor
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LorentzFactor
Keywords: [Lorentz factor, time dilation, length contraction, Bondi k-calculus, k-factor, rapidity]
SeeAlso: [BondiKFactor, Rapidity, ProperTimeScale, BondiRadarCoordinates, TimeDilationConstruction, LightClockConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LorentzFactor]()[*v*]</code> gives the Lorentz factor $\gamma = (k + 1/k)/2$ of the velocity *v*, with *k* = <code>[BondiKFactor]()[*v*]</code>.

## Details & Options

Definition: an observer at rest sends a signal at proper time *T* to an observer of velocity *v* who left the same event; it is reflected at the moving observer's proper time *kT* and returns at $k^2 T$. The rest observer's radar time of the reflection is the midpoint $(T + k^2 T)/2$, so the ratio of radar time to the moving observer's proper time is $(k + 1/k)/2$. This is time dilation, and it equals $1/\sqrt{1 - v^2}$.

The Lorentz factor is the hyperbolic cosine of the [Rapidity](), and it is even in *v*, since $k(-v) = 1/k(v)$.

## Basic Examples

The Lorentz factors of the velocities 3/5 and 4/5, whose k-factors are 2 and 3.

```wl
{LorentzFactor[3/5], LorentzFactor[4/5]}
```

The Lorentz factor over the velocity.

```wl
Plot[LorentzFactor[v], {v, -0.95, 0.95}, AxesLabel -> {"v", "\[Gamma]"}, PlotStyle -> StandardBlue]
```

## Properties and Relations

The k-factor form equals the familiar one.

```wl
FullSimplify[LorentzFactor[v] == 1/Sqrt[1 - v^2], 0 < v < 1]
```

The Lorentz factor is the hyperbolic cosine of the rapidity.

```wl
FullSimplify[LorentzFactor[v] == Cosh[Rapidity[v]], -1 < v < 1]
```

On the worldline of velocity *v*, drawn with light at any angle *φ*, the radar time of the event at arc length *s* is γ times its proper time <code>[ProperTimeScale]()[*v*, *φ*] *s*</code>.

```wl
Simplify[TrigExpand[With[{r = BondiRadarCoordinates[s Through[{Sin, Cos}[WorldlineAngle[v, phi]]], phi]},
  (r["RadarTime"]/(ProperTimeScale[v, phi] s))^2 == LorentzFactor[v]^2]], 0 < v < 1 && 0 < phi < Pi/2 && s > 0]
```
