---
Template: Symbol
Name: UniversalTime
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/UniversalTime
Keywords: [universal time, height, time function, longest chain, rank, topological sort, proper time]
SeeAlso: [UniversalFoliation, InfraSlice, InfraSliceQ, InfraTimelikeGeodesic, InfraRadarCoordinates, FoliationViewer]
RelatedGuides: [CausalTime]
---

## Usage

<code>[UniversalTime]()[*g*]</code> gives the height of every event of the directed acyclic graph *g*: the number of edges of a longest chain from a source to it, zero exactly on the sources.

## Details & Options

Definition: the universal time of an event *v* is *t*(*v*) = max over the sources *s* below *v* of τ(*s*, *v*), the number of edges of a longest chain from *s* to *v*; on a source *t* = 0. Equivalently *t*(*v*) = 1 + max *t*(*u*) over the direct predecessors *u* of *v*, which is how it is computed, in one pass over a topological order.

A time function on a causal graph is an integer function that increases along every edge. The universal time is the least one that is nonnegative: any other such function *f* satisfies *f*(*v*) ≥ *t*(*v*), by induction along a longest chain. It needs no observer and no choice; its level sets are the slices [InfraSlice]() of the universal foliation [UniversalFoliation]().

The result is an association *v* → *t*(*v*) over the events of *g*, in the order of `VertexList[g]`. It is a density in the sense of InfraGeometry: [`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws it, a source with value 0 left plain.

The longest chain from a source is the discrete proper time of the observer that started at the beginning: on a geodesic observer from a source, the universal time of the *m*-th tick is *m* − 1. On the diamond lattice the universal time of (*i*, *j*) is *i* + *j*, twice the coordinate time; on the cylinder lattice it is the row.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Cosmic time | The proper time since the initial surface along the longest timelike curve, maximal for the geodesic normal to the surface. |
| Causal sets | Height | The length of a longest chain ending at an element, the rank function of a graded order. |

## Basic Examples

The universal time on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice, drawn as a density.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, {UniversalTime[g]}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The universal times of the first events of the sprinkling, numbered in a linear extension of the order.

```wl
Take[UniversalTime @ CausalSubstrate["MinkowskiSprinkling2D", "Small"], 12]
```

The largest universal time of each substrate: the number of edges of its longest chain.

```wl
Table[
  Max @ UniversalTime @ CausalSubstrate[name, "Small"],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the sprinkling the universal time grows with the coordinate time of the event, but not monotonically: an event near the edge of the diamond has a short past.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Medium", "KeepCoordinates" -> True]},
  ListPlot[Transpose[{Last /@ GraphEmbedding[g], Values @ UniversalTime[g]}],
    AxesLabel -> {"coordinate time", "universal time"}, PlotStyle -> StandardBlue]]
```

## Properties and Relations

The universal time increases along every edge and vanishes exactly on the sources.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {t = UniversalTime[g]},
    AllTrue[EdgeList[g], e |-> t[First @ e] < t[Last @ e]] &&
      Sort[Keys @ Select[t, EqualTo[0]]] === Sort @ Pick[VertexList[g], VertexInDegree[g], 0]]]
```

It is the length of a longest chain from a source, by brute force over all paths.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {t = UniversalTime[g], sources = Pick[VertexList[g], VertexInDegree[g], 0]},
    AllTrue[VertexList[g], v |->
      t[v] == Max[0, Length /@ Catenate[FindPath[g, #, v, Infinity, All] & /@ sources] - 1]]]]
```

Every event off the sources has a direct predecessor exactly one slice below it.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {t = UniversalTime[g]},
    AllTrue[Select[VertexList[g], v |-> t[v] > 0], v |-> t[v] == 1 + Max[t /@ VertexInComponent[g, {v}, {1}]]]]]
```

With the universal time of the reversed graph, the depth below the sinks, the sum is at most the length *h* of a longest chain, with equality exactly on the events of the longest chains. On the two lattices every event lies on one; on the sprinkling some do not.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sum = Merge[{UniversalTime[g], UniversalTime[ReverseGraph[g]]}, Total], h = Max @ UniversalTime[g]},
    Max[sum] == h && Sort[Keys @ Select[sum, EqualTo[h]]] === Union @@ RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[], All]]]
```

On the diamond lattice the universal time of (*i*, *j*) is *i* + *j*, and on the cylinder lattice it is the row.

```wl
With[
  {diamond = CausalSubstrate["DiamondLatticeGraph", "Small"], cylinder = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  UniversalTime[diamond] === AssociationMap[Total, VertexList[diamond]] &&
    UniversalTime[cylinder] === AssociationMap[Last, VertexList[cylinder]]]
```

On a timelike geodesic from a source the universal time of the *m*-th tick is *m* − 1: the ticks of a geodesic observer from the beginning count universal time.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    UniversalTime[g] /@ a === Range[0, Length[a] - 1]]]
```
