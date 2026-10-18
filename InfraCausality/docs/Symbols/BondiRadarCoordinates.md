---
Template: Symbol
Name: BondiRadarCoordinates
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/BondiRadarCoordinates
Keywords: [radar coordinates, radar time, radar distance, Bondi k-calculus, Einstein synchronisation, Euclidean picture]
SeeAlso: [ProperTimeScale, WorldlineAngle, LightZigzag, KFactor, SimultaneityLine, InfraRadarChart]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[BondiRadarCoordinates]()[{*x*, *y*}, *φ*]</code> gives the radar time, the radar distance and the emission and return arc lengths of the plane event {*x*, *y*} for the observer at rest, with light at angle *φ*.

<code>[BondiRadarCoordinates]()[{*x*, *y*}]</code> takes *φ* = π/4.

## Details & Options

Definition: the observer at rest, the time axis, sends light at arc length *e* that reaches the event and receives its echo at arc length *r*. The radar time is the midpoint $(e + r)/2$ and the radar distance the half-difference $(r - e)/2$: Einstein's synchronisation with the speed of light 1. Since light runs at the angle *φ*, $e = y - x \cot\varphi$ and $r = y + x \cot\varphi$, so the radar time is *y* and the radar distance $x \cot\varphi$.

The result is an association:

| Key | Value |
|---|---|
| `"RadarTime"` | $(e + r)/2 = y$ |
| `"RadarDistance"` | $(r - e)/2 = x \cot\varphi$ |
| `"EmitArcLength"` | *e* |
| `"ReturnArcLength"` | *r* |

A negative *x* gives a negative radar distance, the event on the left. The graph counterpart is the radar chart <code>[InfraRadarChart]()</code> of the Infra Observers guide, which reads the same two numbers off the emission and reception ticks of an observer chain.

## Basic Examples

The event {1, 3} is reached by light sent at arc length 2 and echoed back at 4.

```wl
BondiRadarCoordinates[{1, 3}]
```

At the light angle π/3 the radar time is the same and the radar distance shrinks by $\cot\varphi$.

```wl
BondiRadarCoordinates[{1, 3}, Pi/3]
```

## Properties and Relations

Radar time and radar distance are the half-sum and the half-difference of the emission and return arc lengths, and the radar distance is $x \cot\varphi$.

```wl
With[{r = BondiRadarCoordinates[{x, y}, phi]},
  FullSimplify[{r["EmitArcLength"] + r["ReturnArcLength"] == 2 r["RadarTime"],
    r["ReturnArcLength"] - r["EmitArcLength"] == 2 r["RadarDistance"], r["RadarDistance"] == x Cot[phi]}]] === {True, True, True}
```

The rest worldline is at radar distance 0, and its radar time is its arc length.

```wl
AllTrue[Tuples[{{0, 1, 7/2}, {Pi/6, Pi/4, Pi/3}}], Apply[{y, phi} |->
  With[{r = BondiRadarCoordinates[{0, y}, phi]}, r["RadarDistance"] == 0 && r["RadarTime"] == y]]]
```

The worldline of velocity *v* has radar distance *v* times radar time, and its radar interval is its proper time.

```wl
FullSimplify[With[{r = BondiRadarCoordinates[s WorldlineDirection[3/5, Pi/3], Pi/3]},
  {r["RadarDistance"] == 3/5 r["RadarTime"], Sqrt[r["RadarTime"]^2 - r["RadarDistance"]^2] == ProperTimeScale[3/5, Pi/3] s}], s > 0] === {True, True}
```

Moving along a rightgoing light ray keeps the emission arc length, and along a leftgoing one the return arc length.

```wl
FullSimplify[{BondiRadarCoordinates[{x, y} + l LightDirection[phi, True], phi]["EmitArcLength"] == BondiRadarCoordinates[{x, y}, phi]["EmitArcLength"],
  BondiRadarCoordinates[{x, y} + l LightDirection[phi, False], phi]["ReturnArcLength"] == BondiRadarCoordinates[{x, y}, phi]["ReturnArcLength"]}, 0 < phi < Pi/2] === {True, True}
```
