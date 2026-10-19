---
Template: Symbol
Name: WorldlinePointAtProperTime
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/WorldlinePointAtProperTime
Keywords: [worldline, proper time, point, Euclidean picture, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [WorldlinePoint, ProperTimeScale, BondiRadarCoordinates, TimeDilationConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[WorldlinePointAtProperTime]()[*v*, *τ*, *φ*]</code> gives the point at proper time *τ* on the worldline of velocity *v*.

<code>[WorldlinePointAtProperTime]()[*v*, *τ*]</code> takes *φ* = π/4.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: <code>[WorldlinePoint]()[*v*, *τ* / [ProperTimeScale]()[*v*, *φ*], *φ*]</code>, the point whose radar interval $\sqrt{t^2 - x^2}$ for the rest observer is *τ*. Points at equal proper-time steps are equally spaced along the worldline.

## Basic Examples

The point at proper time 1 on the worldline of velocity 3/5.

```wl
FullSimplify @ WorldlinePointAtProperTime[3/5, 1]
```

## Properties and Relations

The radar interval of the point is its proper time, at every velocity and light angle.

```wl
Simplify[TrigExpand[With[{r = BondiRadarCoordinates[WorldlinePointAtProperTime[v, tau, phi], phi]},
  r["RadarTime"]^2 - r["RadarDistance"]^2 == tau^2]], 0 < v < 1 && 0 < phi < Pi/2 && tau > 0]
```

The radar time of the point is γ *τ*: time dilation.

```wl
FullSimplify[BondiRadarCoordinates[WorldlinePointAtProperTime[3/5, tau, Pi/3], Pi/3]["RadarTime"] == LorentzGamma[3/5] tau, tau > 0]
```
