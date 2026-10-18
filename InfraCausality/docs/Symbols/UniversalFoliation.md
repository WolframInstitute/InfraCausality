---
Template: Symbol
Name: UniversalFoliation
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/UniversalFoliation
Keywords: [foliation, universal time, slice, antichain, level set, simultaneity, Cauchy surface, layering]
SeeAlso: [UniversalTime, InfraSlice, InfraSliceQ, InfraAntichainQ, FoliationViewer]
RelatedGuides: [CausalTime]
---

## Usage

<code>[UniversalFoliation]()[*g*]</code> gives the level sets of <code>[UniversalTime]()[*g*]</code> as sorted vertex lists, the *k*-th list holding the events of universal time *k* − 1.

## Details & Options

Definition: the universal foliation of a directed acyclic graph is the list of slices *S*(*k*) = {*v* : *t*(*v*) = *k*}, *k* = 0, 1, …, *h*, where *t* is the universal time and *h* its maximum, the number of edges of a longest chain.

Every slice is an antichain: an edge raises the universal time by at least one, so two events of one slice are never comparable. The slices partition the events, and no slice is empty, since a longest chain passes every height. Every event of *S*(*k*), *k* ≥ 1, has a direct predecessor in *S*(*k* − 1). The foliation is the layering of the graph by longest paths, the canonical discrete analogue of a foliation by simultaneity surfaces; it depends on no observer.

The list is the list of supports of the slice heads: part *k* + 1 is <code>Keys @ [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraSlice]()[*k*], "VertexDensity"]</code>. [FoliationViewer]() steps through it.

## Basic Examples

The universal foliations of the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice, every slice in its own colour.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, UniversalFoliation[g]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The foliation of the sprinkling.

```wl
UniversalFoliation @ CausalSubstrate["MinkowskiSprinkling2D", "Small"]
```

The number of events of every slice. On the diamond lattice the slices are the antidiagonals and grow and shrink; on the cylinder lattice they are the rows, of constant width.

```wl
Table[
  Length /@ UniversalFoliation @ CausalSubstrate[name, "Small"],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The slice widths of the three substrates at size "Medium".

```wl
ListLinePlot[
  Table[Length /@ UniversalFoliation @ CausalSubstrate[name, "Medium"], {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}],
  PlotStyle -> {StandardBlue, StandardOrange, StandardGreen}, AxesLabel -> {"height", "events"},
  PlotLegends -> {"diamond lattice", "sprinkling", "cylinder lattice"}]
```

## Properties and Relations

The slices are nonempty antichains that partition the events.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {slices = UniversalFoliation[g]},
    AllTrue[slices, s |-> s =!= {} && InfraAntichainQ[g, s] && InfraSliceQ[g, s]] &&
      Sort[Catenate @ slices] === Sort[VertexList[g]] && Length[Catenate @ slices] == VertexCount[g]]]
```

There is one slice per height, from 0 to the length of a longest chain, and slice *k* + 1 is the support of `InfraSlice[k]`.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {slices = UniversalFoliation[g]},
    Length[slices] == Length[(SeedRandom[1]; RandomInfraWorldline[g])] &&
      slices === Table[Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"], {k, 0, Length[slices] - 1}]]]
```

Every event above the bottom slice has a direct predecessor in the slice below it.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {slices = UniversalFoliation[g]},
    AllTrue[Range[2, Length[slices]], k |->
      AllTrue[slices[[k]], v |-> IntersectingQ[VertexInComponent[g, {v}, {1}], slices[[k - 1]]]]]]]
```

The bottom slice is the set of sources.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    First[UniversalFoliation[g]] === Sort @ Pick[VertexList[g], VertexInDegree[g], 0]]]
```

On the diamond lattice slice *k* is the antidiagonal *i* + *j* = *k*, with min(*k*, 12 − *k*) + 1 events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  MapIndexed[{slice, k} |-> AllTrue[slice, v |-> Total[v] == First[k] - 1] && Length[slice] == Min[First[k] - 1, 13 - First[k]] + 1,
    UniversalFoliation[g]] === ConstantArray[True, 13]]
```
