---
Template: Symbol
Name: InfraSlice
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraSlice
Keywords: [slice, universal time, foliation, antichain, simultaneity, Cauchy surface, band, symbolic object]
SeeAlso: [InfraSliceQ, UniversalTime, UniversalFoliation, InfraAntichainQ, FoliationViewer, InfraCausalPast]
RelatedGuides: [CausalTime]
---

## Usage

<code>[InfraSlice]()[*k*]</code> is the slice of the universal time at height *k*: the events whose longest chain from a source has *k* edges.

<code>[InfraSlice]()[{*k1*, *k2*}]</code> is the band of the slices from height *k1* to height *k2*.

## Details & Options

Definition: the slice at height *k* of a directed acyclic graph is {*v* : *t*(*v*) = *k*}, where *t* = [UniversalTime]() is the height, the number of edges of a longest chain from a source to *v*. The band {*k1*, *k2*} is {*v* : *k1* ≤ *t*(*v*) ≤ *k2*}.

The height increases by at least one along every edge, so no two events of a slice are comparable: every slice is an antichain, the discrete analogue of a spacelike hypersurface, and the slices of all heights partition the events. They are the leaves of the universal foliation, [UniversalFoliation](). A slice is the set of events an observer who counts the longest chains from the beginning would call simultaneous.

The head holds its height and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on every event of the slice or band, keys sorted |
| `"EdgeDensity"` | 1 on every edge between two events of the band; a single slice spans no edge |
| `"Subgraph"` | the subgraph induced on the slice or band |
| `"CountingMeasure"` | the number of events of the slice or band |
| `"Cardinality"` | 1: the slice is a set, and its support is its only member |
| `"Faithful"` | `True` |

A set head has one member, its support, so no sampler draws it. The three readings of the slice on a graph are <code>[`InfraSubgraph`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubgraph)[*g*, [InfraSlice]()[*k*]]</code> (InfraGeometry), the induced subgraph; <code>Keys @ [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraSlice]()[*k*], "VertexDensity"]</code>, the sorted vertex list; and <code>[`RandomInfraPoint`](paclet:WolframInstitute/InfraGeometry/ref/RandomInfraPoint)[*g*, [InfraSlice]()[*k*], *n*]</code> (InfraGeometry), *n* distinct random events of it. [InfraSliceQ]() recognises a nonempty level set of the universal time.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Simultaneity hypersurface | The hyperplane *t* = const of an inertial frame, a spacelike Cauchy surface. |
| Causal sets | Antichain | A set of mutually unrelated elements; a maximal antichain is the discrete analogue of a Cauchy surface. |

## Basic Examples

The slice at height 3 on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, {InfraSlice[3]}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The universal foliation of the sprinkling, every slice in its own colour.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, Table[InfraSlice[k], {k, 0, Max @ UniversalTime @ g}]]]
```

The band of the slices from height 2 to height 4 on the cylinder lattice, beside the slice at height 3.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraSlice[{2, 4}]}], InfraSubstrateHighlight[g, {InfraSlice[3]}]}]]
```

The number of events of every slice of the diamond lattice.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  Table[InfraMeasurement[g, InfraSlice[k], "CountingMeasure"], {k, 0, Max @ UniversalTime @ g}]]
```

## Properties and Relations

The slices are antichains that partition the events, and they are the leaves of the universal foliation.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {slices = Table[Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"], {k, 0, Max @ UniversalTime @ g}]},
    slices === UniversalFoliation[g] && AllTrue[slices, s |-> InfraAntichainQ[g, s] && InfraSliceQ[g, s]] &&
      Sort[Join @@ slices] === Sort[VertexList[g]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A band is the union of its slices.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[Subsets[Range[0, Max @ UniversalTime @ g], {2}], Apply[{k1, k2} |->
    Keys @ InfraMeasurement[g, InfraSlice[{k1, k2}], "VertexDensity"] === Union @@ Table[Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"], {k, k1, k2}]]]]
```

On the diamond lattice the slice at height *k* is the antidiagonal *i* + *j* = *k*, and on the cylinder lattice it is the row *k*.

```wl
{
  With[{g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
    AllTrue[Range[0, 12], k |-> Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"] === Sort @ Select[VertexList[g], v |-> Total[v] == k]]],
  With[{g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
    AllTrue[Range[0, 6], k |-> Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"] === Sort @ Select[VertexList[g], v |-> Last[v] == k]]]}
```

A slice spans no edge.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[0, Max @ UniversalTime @ g], k |-> InfraMeasurement[g, InfraSlice[k], "EdgeDensity"] === <||>]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```
