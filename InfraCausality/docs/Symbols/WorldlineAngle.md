---
Template: Symbol
Name: WorldlineAngle
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/WorldlineAngle
Keywords: [worldline, Euclidean picture, light angle, Bondi k-calculus, velocity]
SeeAlso: [BondiKFactor, OutgoingRatio, IncomingRatio]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[WorldlineAngle]()[*v*, *φ*]</code> gives the Euclidean angle $\alpha = \arctan(v \tan\varphi)$ between the worldline of velocity *v* and the time axis, for light at angle *φ*.

<code>[WorldlineAngle]()[*v*]</code> takes *φ* = π/4.

## Details & Options

Definition: in the Euclidean picture the observer at rest is the time axis and light runs at the angle *φ* to it. The worldline of velocity *v* through the origin is the ray along which the radar distance is *v* times the radar time; since radar distance is $x \cot\varphi$ and radar time is *y* ([BondiRadarCoordinates]()), the ray has $x / y = v \tan\varphi$, the angle $\arctan(v \tan\varphi)$.

For 0 < *v* < 1 the angle lies strictly between 0 and *φ*: the worldline lies inside the light cone. The light angle is a choice of drawing: *φ* = π/4 is the familiar Minkowski diagram, and every other *φ* draws the same Minkowski plane with the space axis rescaled by $\tan\varphi$.

## Basic Examples

The worldline angle of the velocity 3/5 at the default light angle, and the angle as a function of *v* at the light angle π/3.

```wl
{WorldlineAngle[3/5], WorldlineAngle[v, Pi/3]}
```

The worldline angle over the velocity for three light angles; each curve tends to its light angle as *v* tends to 1.

```wl
Plot[Evaluate @ Table[WorldlineAngle[v, phi], {phi, {Pi/6, Pi/4, Pi/3}}], {v, 0, 1},
  AxesLabel -> {"v", "\[Alpha]"}, PlotStyle -> {StandardBlue, StandardRed, StandardGreen}]
```

## Properties and Relations

The tangent of the worldline angle is the velocity times the tangent of the light angle.

```wl
FullSimplify[Tan[WorldlineAngle[v, phi]] == v Tan[phi], 0 < v < 1 && 0 < phi < Pi/2] && WorldlineAngle[v] == ArcTan[v]
```

Every point of the worldline of velocity *v* has radar distance *v* times its radar time.

```wl
FullSimplify[With[{r = BondiRadarCoordinates[s {Sin[WorldlineAngle[v, phi]], Cos[WorldlineAngle[v, phi]]}, phi]},
  r["RadarDistance"] == v r["RadarTime"]], 0 < v < 1 && 0 < phi < Pi/2 && s > 0]
```
