---
Template: Symbol
Name: WorldlinePoint
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/WorldlinePoint
Keywords: [worldline, arc length, point, Euclidean picture, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [WorldlineDirection, WorldlinePointAtProperTime, ProperTimeScale, BondiRadarCoordinates]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[WorldlinePoint]()[*v*, *s*, *φ*]</code> gives the point at Euclidean arc length *s* from the origin on the worldline of velocity *v*.

<code>[WorldlinePoint]()[*v*, *s*]</code> takes *φ* = π/4.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: *s* <code>[WorldlineDirection]()[*v*, *φ*]</code>. Arc length is a Euclidean quantity of the drawing; the proper time of the point is <code>[ProperTimeScale]()[*v*, *φ*]</code> *s*, and <code>[WorldlinePointAtProperTime]()</code> takes the proper time instead.

## Basic Examples

The point at arc length 2 on the worldline of velocity 3/5.

```wl
WorldlinePoint[3/5, 2]
```

## Properties and Relations

The point is at distance *s* from the origin, and its radar interval is its proper time.

```wl
FullSimplify[With[{p = WorldlinePoint[3/5, s, Pi/3]}, {r = BondiRadarCoordinates[p, Pi/3]},
  Norm[p] == s && Sqrt[r["RadarTime"]^2 - r["RadarDistance"]^2] == ProperTimeScale[3/5, Pi/3] s], s > 0]
```

On the rest worldline it is the point {0, *s*}.

```wl
WorldlinePoint[0, s, phi] === {0, s}
```
