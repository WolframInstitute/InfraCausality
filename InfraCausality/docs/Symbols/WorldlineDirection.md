---
Template: Symbol
Name: WorldlineDirection
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/WorldlineDirection
Keywords: [worldline, direction, unit vector, Euclidean picture, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [WorldlineAngle, WorldlinePoint, WorldlineNormal, LightDirection, BondiRadarCoordinates]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[WorldlineDirection]()[*v*, *φ*]</code> gives the unit direction $(\sin\alpha, \cos\alpha)$ of the worldline of velocity *v*, with *α* = <code>[WorldlineAngle]()[*v*, *φ*]</code>.

<code>[WorldlineDirection]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: the Euclidean unit vector along the worldline of velocity *v* through the origin, in the picture where the rest observer is the time axis {0, 1} and light runs at the angle *φ* to it. A negative *v* points to the left.

## Basic Examples

The direction of the rest worldline and of the worldline of velocity 3/5.

```wl
{WorldlineDirection[0], WorldlineDirection[3/5]}
```

The directions of the velocities 0, 0.2, …, 0.8 at the light angle π/4, with the two light directions dashed.

```wl
Graphics[{Table[{Hue[0.6 - 0.6 v], Arrow[{{0, 0}, WorldlineDirection[v]}]}, {v, 0, 0.8, 0.2}],
  {StandardYellow, Dashed, Line[{{0, 0}, LightDirection[Pi/4, True]}], Line[{{0, 0}, LightDirection[Pi/4, False]}]}}, ImageSize -> 250]
```

## Properties and Relations

The direction is a unit vector, at the worldline angle from the time axis.

```wl
FullSimplify[Norm[WorldlineDirection[v, phi]] == 1 && WorldlineDirection[v, phi] . {0, 1} == Cos[WorldlineAngle[v, phi]], 0 < v < 1 && 0 < phi < Pi/2]
```

Along the direction the radar distance is *v* times the radar time.

```wl
FullSimplify[With[{r = BondiRadarCoordinates[WorldlineDirection[v, phi], phi]}, r["RadarDistance"] == v r["RadarTime"]], 0 < v < 1 && 0 < phi < Pi/2]
```
