---
Template: Symbol
Name: InfraLightRayQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraLightRayQ
Keywords: [light ray, null geodesic, null separation, light cone, predicate, chain hierarchy]
SeeAlso: [InfraFutureLightCone, InfraPastLightCone, RandomInfraFutureLightCone, RandomInfraPastLightCone, InfraWorldlineQ, InfraObserverQ, InfraChainQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraLightRayQ]()[*g*, *chain*]</code> gives `True` if the vertex list *chain* is a saturated chain of *g* equal to the causal diamond of its first and last events.

<code>[InfraLightRayQ]()[*g*, {*chain1*, *chain2*, …}]</code> tests every chain in the list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is a light ray when it is a saturated chain of *g*, as [InfraObserverQ]() tests, and the diamond [*e*0, *ek*] has exactly *k* + 1 events: no event lies between *e*0 and *ek* off the chain, so the chain is the only route from *e*0 to *ek*.

This is the discrete analogue of null separation: there is no room beside the ray for a second path. Equivalently, the chain is saturated and *ek* lies on the future light cone *E*⁺(*e*0); then every event of the chain lies on *E*⁺(*e*0) and on the past light cone *E*⁻(*ek*). A light ray need not be inextendible: an initial segment of a member of [InfraFutureLightCone]() is a light ray too.

The condition is symmetric in time, so the predicate accepts the outgoing rays of [RandomInfraFutureLightCone](), listed from *v*, and the incoming rays of [RandomInfraPastLightCone](), listed in causal order up to *v*. A single event is a light ray; the empty list is not. The predicate takes a chain, never an object.

A light ray is the strongest condition of the chain hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraWorldlineQ]() | *k* = τ(*e*0, *ek*) |
| [InfraObserverQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

## Basic Examples

On each substrate: an outgoing light ray passes, and a worldline from the same event to the event four slices up with the largest diamond fails, since the diamond of its ends is larger than the chain.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[5]; RandomInfraPoint[g, InfraSlice[1]])},
    {w = First @ MaximalBy[Intersection[Keys @ InfraMeasurement[g, InfraCausalFuture[v], "VertexDensity"], Keys @ InfraMeasurement[g, InfraSlice[5], "VertexDensity"]], e |-> Length @ Keys @ InfraMeasurement[g, InfraCausalDiamond[v, e], "VertexDensity"]]},
    {ray = (SeedRandom[5]; RandomInfraFutureLightCone[g, v])},
    {member = (SeedRandom[5]; RandomInfraWorldline[g, v, w])},
    {InfraLightRayQ[g, ray], InfraLightRayQ[g, member], Length[Keys @ InfraMeasurement[g, InfraCausalDiamond[v, w], "VertexDensity"]] == Length[member]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice a null line is a light ray; a staircase between the same rows is a worldline but not a light ray, since its diamond is a rectangle.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {null = Table[{0, j}, {j, 0, 4}], stair = {{0, 0}, {1, 0}, {1, 1}, {2, 1}, {2, 2}}},
  GraphicsRow @ Table[
    Labeled[
      InfraSubstrateHighlight[g, {InfraCausalDiamond[First @ chain, Last @ chain], InfraWalk[chain]}],
      {InfraWorldlineQ[g, chain], InfraLightRayQ[g, chain]}],
    {chain, {null, stair}}]]
```

Incoming and outgoing rays both pass.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {InfraLightRayQ[g, RandomInfraFutureLightCone[g, 2, All]], InfraLightRayQ[g, RandomInfraPastLightCone[g, 22, All]]}]
```

## Properties and Relations

A saturated chain is a light ray exactly when its last event lies on the future light cone of its first. Checked on every path of the graph between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Keys @ InfraMeasurement[g, InfraSlice[1], "VertexDensity"], v |->
      AllTrue[Intersection[Keys @ InfraMeasurement[g, InfraCausalFuture[v], "VertexDensity"], Keys @ InfraMeasurement[g, InfraSlice[4], "VertexDensity"]], w |->
        AllTrue[FindPath[g, v, w, Infinity, All], chain |->
          InfraLightRayQ[g, chain] === MemberQ[Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"], w]]]]]]
```

Every light ray is a worldline: the only chain between its ends is also the longest.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      AllTrue[RandomInfraFutureLightCone[g, v, All], ray |->
        InfraWorldlineQ[g, ray] && InfraMeasurement[g, InfraWorldline[First @ ray, Last @ ray], "Cardinality"] == 1]]]]
```

The events of a light ray form a causal diamond.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      AllTrue[Join[RandomInfraFutureLightCone[g, v, All], RandomInfraPastLightCone[g, v, All]], ray |->
        Keys @ InfraMeasurement[g, InfraCausalDiamond[First @ ray, Last @ ray], "VertexDensity"] === Sort[ray] && InfraCausalDiamondQ[g, ray]]]]]
```
