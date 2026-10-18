---
Template: Symbol
Name: ChainLightReach
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/ChainLightReach
Keywords: [Knuth kinematics, light reach, light cone, light ray, chain, experimental]
SeeAlso: [ChainProjection, InfraKinematics, InfraFutureLightCone, RandomInfraFutureLightCone, InfraCausalFuture]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[ChainLightReach]()[*g*, *c*]</code> gives the union of the future light cones of the events of the chain *c*, as a sorted vertex list.

## Details & Options

Experimental: Knuth kinematics. The light reach is the set on which the `"LightRays"` method of [ChainProjection]() reads its targets; it belongs to the experimental Knuth thread.

Definition: for a chain *c* = (*c*1, …, *cn*) of *g* the light reach is *E*⁺(*c*1) ∪ … ∪ *E*⁺(*cn*), the events reached from some event of *c* along a light ray, the vertex sets of the outgoing light rays of the events of *c*.

The light reach contains *c*, since every event lies on its own light cone, and it lies in the causal future *J*⁺(*c*1) of the first event, since each light cone lies in the causal future of its apex and the futures shrink along the chain. A chain *b* meets the light reach of *a* exactly when <code>[ChainProjection]()[*g*, *a*, *b*, "Method" -> "LightRays"]</code> is positive.

## Basic Examples

The light reach of a worldline from an event at height 1 to an event at height 5, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {c = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q]])},
    InfraSubstrateHighlight[g, {ChainLightReach[g, c], InfraWalk[c]}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice the light reach of a piece of the null line {2, *j*} is the null line above it together with the rows of the chain to the right.

```wl
ChainLightReach[CausalSubstrate["DiamondLatticeGraph", "Small"], Table[{2, j}, {j, 0, 2}]]
```

## Properties and Relations

The light reach is the union of the vertex sets of the outgoing light rays of the events of the chain.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[chains, c |-> ChainLightReach[g, c] === Union @@ Catenate[RandomInfraFutureLightCone[g, #, All] & /@ c]]]]
```

The light reach contains the chain and lies in the causal future of its first event.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[chains, c |-> SubsetQ[ChainLightReach[g, c], c] && SubsetQ[Keys @ InfraMeasurement[g, InfraCausalFuture[First @ c], "VertexDensity"], ChainLightReach[g, c]]]]]
```

A chain meets the light reach of another exactly when the light-ray projection onto it is positive.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[Tuples[chains, 2], Apply[{a, b} |->
      IntersectingQ[ChainLightReach[g, a], b] === (ChainProjection[g, a, b, "Method" -> "LightRays"] > 0)]]]]
```
