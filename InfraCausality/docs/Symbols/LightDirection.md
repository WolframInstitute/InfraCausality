---
Template: Symbol
Name: LightDirection
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LightDirection
Keywords: [light ray, light angle, direction, Euclidean picture, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [WorldlineDirection, WorldlineAngle, BondiRadarCoordinates, LightClockConstruction, SimultaneityLine]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LightDirection]()[*φ*, *right*]</code> gives the unit direction of a light ray at angle *φ* to the time axis, pointing to positive *x* when *right* is `True`.

<code>[LightDirection]()[*φ*]</code> gives the rightgoing direction.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: $(\sin\varphi, \cos\varphi)$ when *right* is `True` and $(-\sin\varphi, \cos\varphi)$ otherwise. The two directions span the light cone of the drawing: every worldline of velocity |*v*| < 1 lies between them.

Along a rightgoing ray the emission arc length of <code>[BondiRadarCoordinates]()</code> is constant, along a leftgoing ray the return arc length: radar coordinates are light-cone coordinates.

## Basic Examples

The two light directions at the light angle π/4, and the leftgoing one at π/3.

```wl
{LightDirection[Pi/4], LightDirection[Pi/4, False], LightDirection[Pi/3, False]}
```

## Properties and Relations

The light directions are unit vectors at the angle *φ* to the time axis, mirror images in it.

```wl
FullSimplify[Norm[LightDirection[phi, True]] == 1 && LightDirection[phi, True] . {0, 1} == Cos[phi] &&
  LightDirection[phi, False] == {-1, 1} LightDirection[phi, True], 0 < phi < Pi/2]
```

Rightgoing rays keep the emission arc length and leftgoing rays the return arc length.

```wl
FullSimplify[BondiRadarCoordinates[{x, y} + l LightDirection[phi, True], phi]["EmitArcLength"] == BondiRadarCoordinates[{x, y}, phi]["EmitArcLength"] &&
  BondiRadarCoordinates[{x, y} + l LightDirection[phi, False], phi]["ReturnArcLength"] == BondiRadarCoordinates[{x, y}, phi]["ReturnArcLength"], 0 < phi < Pi/2]
```

Every worldline of velocity 0 < *v* < 1 lies strictly between the time axis and the rightgoing light direction.

```wl
FullSimplify[Det[{WorldlineDirection[v, phi], {0, 1}}] > 0 && Det[{LightDirection[phi, True], WorldlineDirection[v, phi]}] > 0, 0 < v < 1 && 0 < phi < Pi/2]
```
