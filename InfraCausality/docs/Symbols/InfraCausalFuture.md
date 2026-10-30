---
Template: Symbol
Name: InfraCausalFuture
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalFuture
Keywords: [causal future, future cone, J+, up-set, causal volume, proper time, symbolic object]
SeeAlso: [InfraCausalPast, InfraCausalFutureQ, InfraCausalDiamond, InfraFutureLightCone, CausalHeight, CausalSubstrate]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalFuture]()[*v*]</code> is the causal future of the event *v*: every event that *v* can reach, *v* included.

<code>[InfraCausalFuture]()[{*v1*, *v2*, …}]</code> is the causal future of a set of events, the union of their causal futures.

<code>[InfraCausalFuture]()[*v*, *t*]</code> keeps the events of the causal future within proper time *t* of *v*.

## Details & Options

Definition: the causal future of an event *v* of a directed acyclic graph is *J*⁺(*v*) = {*e* : *v* ≼ *e*}, the events *e* joined to *v* by a directed path, *v* itself included.

The causal order *u* ≼ *e* is reachability, so the causal future is the out-component of *v*. It is an up-set: with every event it contains every event the event can reach. On a light-cone lattice it is the quadrant above *v*; on a sprinkling into Minkowski space it is the set of sprinkled points inside the future light cone of *v*.

The cut <code>[InfraCausalFuture]()[*v*, *t*]</code> keeps the events *e* of *J*⁺(*v*) whose longest chain from *v* has at most *t* edges. The number of edges of a longest chain is the proper time of the graph, so the cut is the cone of proper-time height *t*: the events of the causal future that *v* reaches within proper time *t*. On the diamond lattice the longest chain from {*i*, *j*} to {*i'*, *j'*} has (*i'* − *i*) + (*j'* − *j*) edges, and the cut is a triangle.

The head holds its anchor and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph, and the anchor is read through its vertex density, <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *anchor*, "VertexDensity"]</code>, so a vertex, a vertex list or a chain all serve:

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on every event of the causal future, keys sorted |
| `"EdgeDensity"` | 1 on every edge between two events of the causal future |
| `"Subgraph"` | the subgraph induced on the causal future |
| `"CountingMeasure"` | the causal volume, the number of events of the causal future |
| `"Cardinality"` | 1: the causal future is a set, and its support is its only member |
| `"Faithful"` | `True` |

A set head has one member, its support, so no sampler draws it. The three readings of the causal future on a graph are <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalFuture]()[*v*], "Subgraph"]</code> (InfraGeometry), the induced subgraph; <code>Keys @ [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalFuture]()[*v*], "VertexDensity"]</code>, the sorted vertex list; and <code>[`RandomInfraPoint`](paclet:WolframInstitute/InfraGeometry/ref/RandomInfraPoint)[*g*, [InfraCausalFuture]()[*v*], *n*]</code> (InfraGeometry), *n* distinct random events of it. [InfraCausalFutureQ]() recognises a vertex set that is the causal future of one of its events.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Causal future *J*⁺(*p*) | The events reached from *p* by future-directed causal curves: the closed future light cone and its interior. |
| Causal sets | Future of an element | The up-set {*x* : *p* ≼ *x*} of the element *p* in the partial order. |

## Basic Examples

The causal future of an event at height 3, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[3]])},
    InfraSubstrateHighlight[g, {InfraCausalFuture[v], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The proper-time cuts of the causal future of one event of the diamond lattice, at *t* = 2, 4 and 6.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {v = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[3]])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraCausalFuture[v, t], v}], {t, {2, 4, 6}}]]
```

The causal future of two events of the sprinkling is the union of their causal futures.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {s = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2], 2])},
  InfraSubstrateHighlight[g, {InfraCausalFuture[s], InfraWalk[{First @ s}], InfraWalk[{Last @ s}]}]]
```

The causal volume of the future of every event of the bottom row of the cylinder lattice. It is the same for all of them: the cylinder is homogeneous in space.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  Normal @ AssociationMap[v |-> InfraMeasurement[g, InfraCausalFuture[v], "CountingMeasure"], Keys @ InfraMeasurement[g, InfraSlice[0], "VertexDensity"]]]
```

## Properties and Relations

The causal future is an up-set containing its anchor: every out-neighbour of one of its events is one of its events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{future = Keys @ InfraMeasurement[g, InfraCausalFuture[v], "VertexDensity"]},
        MemberQ[future, v] && SubsetQ[future, Union @@ (VertexOutComponent[g, #, {1}] & /@ future)]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice of size 6 the causal future of the event {*i*, *j*} is a rectangle of (7 − *i*)(7 − *j*) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[VertexList[g], v |-> InfraMeasurement[g, InfraCausalFuture[v], "CountingMeasure"] == (7 - First[v]) (7 - Last[v])]]
```

The causal future on a graph is the causal past on the reversed graph.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[VertexList[g], v |->
    Keys @ InfraMeasurement[g, InfraCausalFuture[v], "VertexDensity"] === Keys @ InfraMeasurement[ReverseGraph[g], InfraCausalPast[v], "VertexDensity"]]]
```

Every event of the proper-time cut lies at causal height at most *t* in the subgraph of the causal future, and the cut grows to the whole causal future.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {v = (SeedRandom[3]; RandomInfraPoint[g, InfraSlice[1]])},
  {time = CausalHeight @ InfraMeasurement[g, InfraCausalFuture[v], "Subgraph"]},
  And @@ Table[
    AllTrue[Keys @ InfraMeasurement[g, InfraCausalFuture[v, t], "VertexDensity"], e |-> time[e] <= t],
    {t, 0, Max @ time}] && Keys @ InfraMeasurement[g, InfraCausalFuture[v, Max @ time], "VertexDensity"] === Keys @ InfraMeasurement[g, InfraCausalFuture[v], "VertexDensity"]]
```
