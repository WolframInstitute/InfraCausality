---
Template: Symbol
Name: ChainProjection
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/ChainProjection
Keywords: [Knuth kinematics, chain projection, influence, causal future, light cone, experimental]
SeeAlso: [InfraKinematics, ChainLightReach, InfraCausalFuture, InfraFutureLightCone, RandomInfraTimelikeGeodesic, InfraMessageFunction]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[ChainProjection]()[*g*, *a*, *b*]</code> gives the fraction of the events of the chain *a* whose causal future meets the chain *b*.

<code>[ChainProjection]()[*g*, *a*, *b*, Method -> "LightRays"]</code> uses the future light cones of the events of *a* instead.

## Details & Options

Experimental: Knuth kinematics. The projection, and the scalars [InfraKinematics]() builds from it, follow Knuth and Bahreyni (arXiv:1005.4172), who derive relativistic kinematics from the influence of one chain of events on another; the pairing of target chains is not yet principled, and the reading may change.

Definition: for chains *a* = (*a*1, …, *an*) and *b* of *g*, the projection is *P*(*a* → *b*) = #{*i* : *J*⁺(*a*<sub>*i*</sub>) ∩ *b* ≠ ∅} / *n*, the fraction of the events of *a* that can still influence *b*. With `Method -> "LightRays"` the causal future *J*⁺(*a*<sub>*i*</sub>) is replaced by the future light cone *E*⁺(*a*<sub>*i*</sub>), so an event of *a* counts only when a light ray from it reaches *b*.

Along a chain the causal futures shrink, *J*⁺(*a*<sub>*i*+1</sub>) ⊆ *J*⁺(*a*<sub>*i*</sub>), so the events of *a* that reach *b* form an initial segment of *a*, and *n* · *P* is the position of the last event of *a* that can signal *b*. The value lies in [0, 1]; it is 1 when *b* meets the future of the last event of *a*, in particular for *a* onto itself, and the light-ray value never exceeds the cone value.

| Option | Default | Values |
|---|---|---|
| `Method` | `"Cone"` | `"Cone"`, the causal futures; `"LightRays"`, the future light cones; with any other value the call stays unevaluated |

Knuth's projection counts events, an integer; this one divides by the length of *a*, so chains of different lengths compare.

## Basic Examples

A longest chain *a* of the graph and a timelike geodesic *b* that ends halfway up, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice. The label is the projection of *a* onto *b*.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Floor[Max[UniversalTime[g]]/2] + 1]]])},
    {b = (SeedRandom[2]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q]])},
    Labeled[InfraSubstrateHighlight[g, {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}], ChainProjection[g, a, b]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice the four events of the bottom row all reach the events {3, 3} and {3, 4}, but only the last one reaches them along a light ray.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{i, 0}, {i, 0, 3}], b = {{3, 3}, {3, 4}}},
  {ChainProjection[g, a, b], ChainProjection[g, a, b, Method -> "LightRays"]}]
```

A chain projects onto itself with value 1.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
  {ChainProjection[g, a, a], ChainProjection[g, a, a, Method -> "LightRays"]}]
```

## Properties and Relations

The projection lies in [0, 1], the light-ray value is at most the cone value, and both equal the fraction of events counted directly.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[Tuples[chains, 2], Apply[{a, b} |->
      With[{cone = ChainProjection[g, a, b], rays = ChainProjection[g, a, b, Method -> "LightRays"]},
        0 <= rays <= cone <= 1 &&
          cone == Count[a, e_ /; IntersectingQ[Keys @ InfraMeasurement[g, InfraCausalFuture[e], "VertexDensity"], b]]/Length[a] &&
          rays == Count[a, e_ /; IntersectingQ[Keys @ InfraMeasurement[g, InfraFutureLightCone[e], "VertexDensity"], b]]/Length[a]]]]]]
```

The events of *a* that reach *b* form an initial segment of *a*.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[Tuples[chains, 2], Apply[{a, b} |->
      With[{reach = (IntersectingQ[Keys @ InfraMeasurement[g, InfraCausalFuture[#], "VertexDensity"], b] &) /@ a},
        reach === Join[ConstantArray[True, ChainProjection[g, a, b] Length[a]], ConstantArray[False, Length[a] - ChainProjection[g, a, b] Length[a]]]]]]]]
```

A chain projects with value 1 onto itself and onto every chain in the future of its last event.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {chains = (SeedRandom[1]; RandomInfraObserver[g, UpTo[6]])},
    AllTrue[chains, a |->
      ChainProjection[g, a, a] == 1 &&
        AllTrue[Select[chains, b |-> SubsetQ[Keys @ InfraMeasurement[g, InfraCausalFuture[Last @ a], "VertexDensity"], b]], b |-> ChainProjection[g, a, b] == 1]]]]
```
