---
Template: Symbol
Name: LightZigzag
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LightZigzag
Keywords: [light zigzag, light signal, reflection, radar, Bondi clock, k-factor, geometric growth, bounce count]
SeeAlso: [OutgoingRatio, IncomingRatio, KFactor, BondiRadarCoordinates, RapidityFromK, BondiClock]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[LightZigzag]()[*v*, *s*0, *n*, *φ*]</code> gives the *n* + 1 reflection events of light bouncing between the rest worldline and the worldline of velocity *v*, starting at arc length *s*0 on the rest worldline, as associations.

<code>[LightZigzag]()[*v*, *s*0, *n*]</code> takes *φ* = π/4.

## Details & Options

Definition: the first event is the emission at arc length *s*0 on the rest worldline ("Alice"); each further event is the reception of the previous one's light on the other worldline, rightgoing from Alice to the moving observer ("Bob") and leftgoing back. Each event is an association with the keys:

| Key | Value |
|---|---|
| `"Observer"` | `"Alice"` or `"Bob"`, alternating from `"Alice"` |
| `"ArcLength"` | the Euclidean arc length of the event from the origin on its worldline |
| `"Point"` | the plane point of the event |

The arc length grows by <code>[OutgoingRatio]()[*v*, *φ*]</code> on the way out and by <code>[IncomingRatio]()[*v*, *φ*]</code> on the way back, so Alice's arc lengths grow geometrically by the round-trip factor $k_{out} k_{in} = k^2$. The bounce count up to arc length *s* is therefore $\log(s/s_0)/\log k^2$, logarithmic in *s*, while the proper time ([ProperTimeScale]()) is linear in it. Every reflection on Bob's worldline is the radar event of the emission before it and the return after it.

## Basic Examples

The first four bounces between the rest observer and the observer of velocity 3/5, from arc length 1; Alice's arc lengths are 1, 4, 16, since $k^2 = 4$.

```wl
Lookup[LightZigzag[3/5, 1, 4], {"Observer", "ArcLength"}] // FullSimplify
```

The zigzag of velocity 3/5 at the light angle π/3, drawn from its points.

```wl
With[{points = N @ Lookup[LightZigzag[3/5, 1/10, 6, Pi/3], "Point"]},
  Graphics[{{StandardBlue, AbsoluteThickness[2], Line[{{0, 0}, {0, 1.1 Max[points[[All, 2]]]}}]},
    {StandardRed, AbsoluteThickness[2], Line[{{0, 0}, 1.1 Max[Norm /@ points] WorldlineDirection[3/5, Pi/3]}]},
    {StandardYellow, Line[points]}, {StandardPurple, Disk[#, 0.02] & /@ points}}, ImageSize -> 300]]
```

## Properties and Relations

Alice's arc lengths grow by exactly $k^2$ per round trip, at every light angle.

```wl
AllTrue[Tuples[{{1/5, 3/5, 4/5}, {Pi/6, Pi/4, Pi/3}}], Apply[{v, phi} |->
  With[{arcs = Lookup[Select[LightZigzag[v, 1, 8, phi], #["Observer"] === "Alice" &], "ArcLength"]},
    FullSimplify[Ratios[arcs] - KFactor[v]^2] === ConstantArray[0, 4]]]]
```

The events alternate between the observers and lie at their arc lengths from the origin.

```wl
With[{events = LightZigzag[3/5, 1, 5]},
  Lookup[events, "Observer"] === {"Alice", "Bob", "Alice", "Bob", "Alice", "Bob"} &&
    FullSimplify[(#["Point"] . #["Point"] - #["ArcLength"]^2) & /@ events] === ConstantArray[0, 6]]
```

Each reflection on the moving worldline has its radar emission and return at the neighbouring events of the zigzag.

```wl
With[{events = LightZigzag[3/5, 2, 6, Pi/3]},
  FullSimplify @ Table[With[{r = BondiRadarCoordinates[events[[i]]["Point"], Pi/3]},
    {r["EmitArcLength"] - events[[i - 1]]["ArcLength"], r["ReturnArcLength"] - events[[i + 1]]["ArcLength"]}], {i, {2, 4, 6}}] ===
    ConstantArray[0, {3, 2}]]
```
