---
Template: Symbol
Name: WorldlineNormal
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/WorldlineNormal
Keywords: [worldline, normal, Euclidean picture, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [WorldlineDirection, SimultaneityLine, LightClockConstruction, LengthContractionConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[WorldlineNormal]()[*v*, *φ*]</code> gives the unit normal $(\cos\alpha, -\sin\alpha)$ to the worldline of velocity *v*, with *α* = <code>[WorldlineAngle]()[*v*, *φ*]</code>.

<code>[WorldlineNormal]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: the Euclidean unit vector perpendicular to <code>[WorldlineDirection]()[*v*, *φ*]</code>, pointing to the right. The figures use it to place ticks and labels and the mirror of [LightClockConstruction]().

The Euclidean normal is a property of the drawing, not of the Minkowski plane: the observer's line of simultaneity is <code>[SimultaneityLine]()</code>, along $(\tan\varphi, v)$, and the two agree only at rest. A length at rest for the moving observer, such as the rod of [LengthContractionConstruction](), is laid along the line of simultaneity, not along the normal.

## Basic Examples

The normal to the worldline of velocity 3/5.

```wl
WorldlineNormal[3/5]
```

## Properties and Relations

The normal is a unit vector perpendicular to the worldline.

```wl
FullSimplify[WorldlineNormal[v, phi] . WorldlineDirection[v, phi] == 0 && Norm[WorldlineNormal[v, phi]] == 1, 0 < v < 1 && 0 < phi < Pi/2]
```

It points along the line of simultaneity only at rest.

```wl
Det[{WorldlineNormal[0, Pi/3], {Tan[Pi/3], 0}}] == 0 && FullSimplify[Det[{WorldlineNormal[3/5, Pi/3], {Tan[Pi/3], 3/5}}]] != 0
```
