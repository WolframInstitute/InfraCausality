---
Template: Symbol
Name: RandomInfraFutureLightCone
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraFutureLightCone
Keywords: [light ray, outgoing light ray, future light cone, null geodesic, uniform sampling, sampler, count contract]
SeeAlso: [InfraFutureLightCone, RandomInfraPastLightCone, InfraLightRayQ, RandomInfraTimelikeGeodesic, ChainLightReach, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraFutureLightCone]()[*g*, [InfraFutureLightCone]()[*v*]]</code> gives one outgoing light ray of *v* on *g*, drawn uniformly, as a vertex list starting at *v*.

<code>[RandomInfraFutureLightCone]()[*g*, [InfraFutureLightCone]()[*v*], *n*]</code> gives a `List` of *n* distinct rays, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every ray.

<code>[RandomInfraFutureLightCone]()[*g*, *v*, *n*]</code> is the shortcut for <code>[InfraFutureLightCone]()[*v*]</code>.

## Details & Options

Definition: the members of a future light cone are the outgoing light rays of *v*, the root-to-leaf paths of its tree <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraFutureLightCone]()[*v*], "Graph"]</code>. A ray is a chain *v* = *e*0 ≺ *e*1 ≺ … ≺ *ek* whose diamond [*v*, *ek*] is the ray itself, and which cannot be continued: every event after *ek* is reached from *v* by a second route. The events of the rays are the light cone *E*⁺(*v*).

The default draw is uniform over the rays: each next event is chosen with probability proportional to the number of rays through it. Since the graph is a tree, a ray is determined by its last event, and the draw is the uniform choice of a leaf. Seed with `SeedRandom` to reproduce a draw.

The count contract is the one every `RandomInfra…` sampler shares:

| Count | Result |
|---|---|
| omitted or `Automatic` | one ray, a vertex list |
| *n* | a `List` of exactly *n* distinct rays, or `{}` when there are fewer |
| `UpTo[n]` | a `List` of min(*n*, `"Cardinality"`) distinct rays |
| `All` | every ray, enumerated without drawing |

The option `"NextVertexFunction"` replaces the uniform descent as it does for [RandomInfraTimelikeGeodesic](): `Identity` enumerates the rays in sorted order, `RandomSample` in shuffled order, `RandomChoice` draws random walks (not combined with `All`), and a function *f* of the sorted next events sets or prunes the search.

[InfraLightRayQ]() recognises a ray.

## Basic Examples

One outgoing light ray of an event at height 1, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[5]; RandomInfraPoint[g, InfraSlice[1]])},
    {ray = (SeedRandom[5]; RandomInfraFutureLightCone[g, InfraFutureLightCone[v]])},
    InfraSubstrateHighlight[g, {InfraWalk[ray], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice an event has two outgoing light rays, along the two null lines through it.

```wl
RandomInfraFutureLightCone[CausalSubstrate["DiamondLatticeGraph", "Small"], {2, 1}, All]
```

Every outgoing light ray of the first event of the sprinkling. Most of them are single links.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = First @ Keys @ InfraMeasurement[g, InfraSlice[0], "VertexDensity"]},
  RandomInfraFutureLightCone[g, v, All]]
```

A strict count above the number of rays gives the empty list.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {(SeedRandom[1]; RandomInfraFutureLightCone[g, {0, 0}, 2]), (SeedRandom[1]; RandomInfraFutureLightCone[g, {0, 0}, 3])}]
```

## Properties and Relations

`All` gives `"Cardinality"` rays; each starts at *v*, passes [InfraLightRayQ]() and [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ), and together they cover the light cone.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{rays = RandomInfraFutureLightCone[g, v, All]},
        Length[rays] == InfraMeasurement[g, InfraFutureLightCone[v], "Cardinality"] &&
          AllTrue[rays, First[#] === v &] && InfraLightRayQ[g, rays] &&
          AllTrue[rays, InfraMemberQ[g, InfraFutureLightCone[v], #] &] &&
          Union @@ rays === Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"]]]]]
```

A ray cannot be continued along the light cone: every out-neighbour of its last event lies off the light cone of *v*.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{cone = Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"]},
        AllTrue[RandomInfraFutureLightCone[g, v, All], ray |-> ! IntersectingQ[VertexOutComponent[g, Last @ ray, {1}], cone]]]]]]
```

Every initial segment of a ray is a light ray, and the last event of every ray is a leaf of the tree.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{tree = InfraMeasurement[g, InfraFutureLightCone[v], "Graph"]},
        AllTrue[RandomInfraFutureLightCone[g, v, All], ray |->
          AllTrue[Range @ Length @ ray, k |-> InfraLightRayQ[g, Take[ray, k]]] && VertexOutDegree[tree, Last @ ray] == 0]]]]]
```
