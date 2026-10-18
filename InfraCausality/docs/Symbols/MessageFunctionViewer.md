---
Template: Symbol
Name: MessageFunctionViewer
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/MessageFunctionViewer
Keywords: [viewer, message function, EPS, light ray, observer, interactive, Manipulate, experimental]
SeeAlso: [InfraMessageFunction, InfraEchoFunction, InfraFutureLightCone, RandomInfraObserver, LightConeViewer, FoliationViewer]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[MessageFunctionViewer]()[*g*, *a*, *b*]</code> gives a `Manipulate` drawing the observers *a* and *b* on *g* in which choosing a tick of *a* highlights its message images on *b* and the light rays carrying them.

## Details & Options

Experimental: viewer. The interface of the viewers may change.

Definition: the frame at the tick *v* = *a*<sub>*k*</sub> draws, with <code>[`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight)</code>, the observer *a* in blue, the observer *b* in red, the message images *M*<sub>*ab*</sub>(*v*) = *E*⁺(*v*) ∩ *b* of [InfraMessageFunction]() in green, the light rays from *v* to them in orange and *v* in magenta. The label names the tick and its images.

The tick is chosen with the slider or by clicking near it; a click selects the tick of *a* nearest to the click, even far from *a*. The observers are vertex lists in causal order, such as the members [RandomInfraObserver]() and [RandomInfraTimelikeGeodesic]() draw. The result is a `Manipulate` with `SaveDefinitions -> True`; clicking needs the Wolfram notebook front end.

## Basic Examples

The messages between two parallel null lines of the diamond lattice. Each tick of the left line reaches the right line at the same row.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  MessageFunctionViewer[g, Table[{0, j}, {j, 0, 6}], Table[{2, j}, {j, 0, 6}]]]
```

The frame at the fourth tick of a timelike geodesic, sending to a second one, drawn without the viewer on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]]), b = (SeedRandom[4]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    {images = Lookup[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], Key @ a[[4]]]},
    InfraSubstrateHighlight[g, {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed,
      Map[w |-> InfraWalk[First @ RandomInfraTimelikeGeodesic[g, a[[4]], w, All]], images] -> StandardOrange,
      images -> StandardGreen, {a[[4]]} -> StandardMagenta}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Properties and Relations

Every image drawn lies on *b* and on the future light cone of its tick, and the light ray to it is the only chain from the tick to the image.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]]), b = (SeedRandom[4]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    AllTrue[Normal @ InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], Apply[{v, images} |->
      SubsetQ[b, images] && SubsetQ[Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"], images] &&
        AllTrue[images, w |-> InfraLightRayQ[g, RandomInfraTimelikeGeodesic[g, v, w, All]] && InfraMeasurement[g, InfraTimelikeGeodesic[v, w], "Cardinality"] == 1]]]]]
```

On the two parallel null lines of the diamond lattice each tick has exactly one image, the tick of the same row.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  InfraMeasurement[g, InfraMessageFunction[Table[{0, j}, {j, 0, 6}], Table[{2, j}, {j, 0, 6}]], "Relation"] ===
    AssociationThread[Table[{0, j}, {j, 0, 6}], Table[{{2, j}}, {j, 0, 6}]]]
```

The viewer is a `Manipulate`.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  Head @ MessageFunctionViewer[g, (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]]), (SeedRandom[4]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])] === Manipulate]
```
