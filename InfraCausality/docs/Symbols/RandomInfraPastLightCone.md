---
Template: Symbol
Name: RandomInfraPastLightCone
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraPastLightCone
Keywords: [light ray, incoming light ray, past light cone, null geodesic, uniform sampling, sampler, count contract]
SeeAlso: [InfraPastLightCone, RandomInfraFutureLightCone, InfraLightRayQ, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraPastLightCone]()[*g*, [InfraPastLightCone]()[*v*]]</code> gives one incoming light ray of *v* on *g*, drawn uniformly, as a vertex list in causal order ending at *v*.

<code>[RandomInfraPastLightCone]()[*g*, [InfraPastLightCone]()[*v*], *n*]</code> gives a `List` of *n* distinct rays, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every ray.

<code>[RandomInfraPastLightCone]()[*g*, *v*, *n*]</code> is the shortcut for <code>[InfraPastLightCone]()[*v*]</code>.

## Details & Options

Definition: the members of a past light cone are the incoming light rays of *v*: chains *e*0 ≺ … ≺ *ek* = *v* whose diamond [*e*0, *v*] is the ray itself and which cannot be continued into the past. They are the paths of the in-tree <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraPastLightCone]()[*v*], "Graph"]</code> from its leaves to *v*, listed in causal order, so a ray ends at *v*. Their events are the past light cone *E*⁻(*v*).

An incoming ray of *v* on *g* is an outgoing ray of *v* on the time-reversed graph, read backwards.

The default draw is uniform over the rays. The count contract is the one every `RandomInfra…` sampler shares:

| Count | Result |
|---|---|
| omitted or `Automatic` | one ray, a vertex list ending at *v* |
| *n* | a `List` of exactly *n* distinct rays, or `{}` when there are fewer |
| `UpTo[n]` | a `List` of min(*n*, `"Cardinality"`) distinct rays |
| `All` | every ray, enumerated without drawing |

The option `"NextVertexFunction"` replaces the uniform descent as it does for [RandomInfraWorldline](): `Identity` enumerates the rays in sorted order, `RandomSample` in shuffled order, `RandomChoice` draws random walks (not combined with `All`), and a function *f* of the sorted next events sets or prunes the search.

[InfraLightRayQ]() recognises a ray in either direction.

## Basic Examples

One incoming light ray of an event at height 4, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[5]; RandomInfraPoint[g, InfraSlice[4]])},
    {ray = (SeedRandom[5]; RandomInfraPastLightCone[g, InfraPastLightCone[v]])},
    InfraSubstrateHighlight[g, {InfraWalk[ray], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice an event has two incoming light rays, along the two null lines through it back to the boundary of the lattice.

```wl
RandomInfraPastLightCone[CausalSubstrate["DiamondLatticeGraph", "Small"], {2, 1}, All]
```

Every incoming light ray of the last event of the sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = First @ Keys @ InfraMeasurement[g, InfraSlice[Max @ UniversalTime @ g], "VertexDensity"]},
  RandomInfraPastLightCone[g, v, All]]
```

## Properties and Relations

`All` gives `"Cardinality"` rays; each ends at *v*, passes [InfraLightRayQ]() and [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ), and together they cover the past light cone.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{rays = RandomInfraPastLightCone[g, v, All]},
        Length[rays] == InfraMeasurement[g, InfraPastLightCone[v], "Cardinality"] &&
          AllTrue[rays, Last[#] === v &] && InfraLightRayQ[g, rays] &&
          AllTrue[rays, InfraMemberQ[g, InfraPastLightCone[v], #] &] &&
          Union @@ rays === Keys @ InfraMeasurement[g, InfraPastLightCone[v], "VertexDensity"]]]]]
```

The incoming rays of *v* are the outgoing rays of *v* on the reversed graph, read backwards.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      Sort @ RandomInfraPastLightCone[g, v, All] === Sort[Reverse /@ RandomInfraFutureLightCone[ReverseGraph[g], v, All]]]]]
```

An event *u* lies on the past light cone of *v* exactly when *v* lies on the future light cone of *u*.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {past = AssociationMap[v |-> Union @@ RandomInfraPastLightCone[g, v, All], VertexList[g]],
     future = AssociationMap[v |-> Union @@ RandomInfraFutureLightCone[g, v, All], VertexList[g]]},
    AllTrue[Tuples[VertexList[g], 2], Apply[{u, v} |-> MemberQ[past[v], u] === MemberQ[future[u], v]]]]]
```
