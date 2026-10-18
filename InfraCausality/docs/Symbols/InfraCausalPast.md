---
Template: Symbol
Name: InfraCausalPast
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalPast
Keywords: [causal past, past cone, J-, down-set, causal volume, proper time, symbolic object]
SeeAlso: [InfraCausalFuture, InfraCausalPastQ, InfraCausalDiamond, InfraPastLightCone, UniversalTime, CausalSubstrate]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalPast]()[*v*]</code> is the causal past of the event *v*: every event that can reach *v*, *v* included.

<code>[InfraCausalPast]()[{*v1*, *v2*, …}]</code> is the causal past of a set of events, the union of their causal pasts.

<code>[InfraCausalPast]()[*v*, *t*]</code> keeps the events of the causal past within proper time *t* of *v*.

## Details & Options

Definition: the causal past of an event *v* of a directed acyclic graph is *J*⁻(*v*) = {*e* : *e* ≼ *v*}, the events *e* joined to *v* by a directed path from *e* to *v*, *v* itself included.

The causal past is the in-component of *v*, and a down-set: with every event it contains every event that can reach it. It is the time reverse of the causal future: [InfraCausalPast]() on a graph is [InfraCausalFuture]() on the graph with every edge reversed, and every reading below is the reversed reading of the causal future. The events of the causal past are the events that can send a signal to *v*; on a sprinkling into Minkowski space they are the sprinkled points inside the past light cone of *v*.

The cut <code>[InfraCausalPast]()[*v*, *t*]</code> keeps the events whose longest chain to *v* has at most *t* edges.

The head holds its anchor and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on every event of the causal past, keys sorted |
| `"EdgeDensity"` | 1 on every edge between two events of the causal past |
| `"Subgraph"` | the subgraph induced on the causal past |
| `"CountingMeasure"` | the causal volume, the number of events of the causal past |
| `"Cardinality"` | 1: the causal past is a set, and its support is its only member |
| `"Faithful"` | `True` |

A set head has one member, its support, so no sampler draws it. The three readings of the causal past on a graph are <code>[`InfraSubgraph`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubgraph)[*g*, [InfraCausalPast]()[*v*]]</code> (InfraGeometry), the induced subgraph; <code>Keys @ [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalPast]()[*v*], "VertexDensity"]</code>, the sorted vertex list; and <code>[`RandomInfraPoint`](paclet:WolframInstitute/InfraGeometry/ref/RandomInfraPoint)[*g*, [InfraCausalPast]()[*v*], *n*]</code> (InfraGeometry), *n* distinct random events of it. [InfraCausalPastQ]() recognises a vertex set that is the causal past of one of its events.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Causal past *J*⁻(*p*) | The events from which *p* is reached by future-directed causal curves: the closed past light cone and its interior. |
| Causal sets | Past of an element | The down-set {*x* : *x* ≼ *p*} of the element *p* in the partial order. |

## Basic Examples

The causal past of an event at height 5, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[5]])},
    InfraSubstrateHighlight[g, {InfraCausalPast[v], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The causal past and the causal future of the same event of the sprinkling meet only in the event itself.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[3]])},
  InfraSubstrateHighlight[g, {InfraCausalFuture[v], InfraCausalPast[v], v}]]
```

On the cylinder lattice the causal past of an event of the top row widens downward until it wraps around the cylinder.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {v = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[6]])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraCausalPast[v, t], v}], {t, {1, 3, 6}}]]
```

## Properties and Relations

The causal past is a down-set containing its anchor: every in-neighbour of one of its events is one of its events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{past = Keys @ InfraMeasurement[g, InfraCausalPast[v], "VertexDensity"]},
        MemberQ[past, v] && SubsetQ[past, Union @@ (VertexInComponent[g, #, {1}] & /@ past)]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

*u* lies in the causal past of *v* exactly when *v* lies in the causal future of *u*.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[Tuples[VertexList[g], 2], Apply[{u, v} |->
    MemberQ[Keys @ InfraMeasurement[g, InfraCausalPast[v], "VertexDensity"], u] === MemberQ[Keys @ InfraMeasurement[g, InfraCausalFuture[u], "VertexDensity"], v]]]]
```

On the diamond lattice the causal past of {*i*, *j*} is a rectangle of (*i* + 1)(*j* + 1) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[VertexList[g], v |-> InfraMeasurement[g, InfraCausalPast[v], "CountingMeasure"] == (First[v] + 1) (Last[v] + 1)]]
```
