---
Template: Symbol
Name: InfraWorldline
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraWorldline
Keywords: [worldline, timelike geodesic, longest chain, proper time, maximal chain, twin paradox, symbolic object]
SeeAlso: [RandomInfraWorldline, InfraWorldlineQ, InfraObserver, InfraCausalDiamond, InfraFutureLightCone, UniversalTime, InfraChainQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraWorldline]()[*p*, *q*]</code> is the family of timelike geodesics from *p* to *q*: every longest chain from *p* to *q* at once.

<code>[InfraWorldline]()[]</code> is the family of longest chains of the whole graph.

## Details & Options

Definition: a worldline from *p* to *q* is a chain *p* = *e*0 ≺ *e*1 ≺ … ≺ *ek* = *q* of maximal length *k*. The maximal length is the proper time τ(*p*, *q*), the number of edges of a longest directed path from *p* to *q*.

The proper time is the discrete analogue of the length of a timelike curve, and a longest chain is the analogue of a timelike geodesic: in Minkowski space the straight worldline between two events maximises the proper time, and every other route is shorter. On a graph the longest chain is rarely unique. The head carries all of them, equally admissible, so nothing distinguishes one.

The head holds its two events and computes nothing. Its graph, <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *w*, "Graph"]</code>, keeps the events *v* of the diamond [*p*, *q*] with τ(*p*, *v*) + τ(*v*, *q*) = τ(*p*, *q*) and the edges along which τ(*p*, ·) rises by one. Its paths from *p* to *q* are exactly the longest chains, each once, so `"Faithful"` is `True`, and every count is read off that graph by dynamic programming, never by enumeration.

| Property | Value |
|---|---|
| `"Graph"` | the directed acyclic graph whose *p*-to-*q* paths are the longest chains |
| `"Length"` | the proper time τ(*p*, *q*); `-Infinity` when *q* does not follow *p* |
| `"Cardinality"` | the number of longest chains |
| `"VertexDensity"` | for each event, the number of longest chains through it |
| `"EdgeDensity"` | for each edge, the number of longest chains through it |
| `"Faithful"` | `True` |

<code>[InfraWorldline]()[]</code> is the same construction on the whole graph: the chains from a source to a sink whose length is the height of the graph, the maximum of [UniversalTime]().

A member is a vertex list in causal order; [RandomInfraWorldline]() draws members uniformly, and [InfraWorldlineQ]() recognises one. Every worldline is an observer, a saturated chain; see [InfraObserver]().

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Timelike geodesic | Between two timelike-separated events the straight worldline is the unique causal curve of maximal proper time. |
| Causal sets | Longest chain | The length of a longest chain between two elements of a sprinkling estimates the proper time between them. |
| EPS | Free particle | The worldlines of freely falling particles are the geodesics of the projective structure. |

## Basic Examples

The worldlines from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice. An edge is drawn as strongly as the number of longest chains through it.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[Max[UniversalTime[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraWorldline[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The proper time and the number of worldlines between the same events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[Max[UniversalTime[g]] - 1]]])},
    Values @ InfraMeasurement[g, InfraWorldline[p, q], {"Length", "Cardinality"}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The graph of the worldlines on the sprinkling. Every longest chain is a path through it from its source to its sink.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[6]]])},
  Graph[InfraMeasurement[g, InfraWorldline[p, q], "Graph"], VertexLabels -> Automatic]]
```

The members are vertex lists. Three of the 20 worldlines from the bottom row to the top row of the cylinder lattice, each drawn as a walk.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {members = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[{0, 0}, {3, 6}], 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

The longest chains of the whole sprinkling run from a source to a sink through every slice of the universal foliation.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, {InfraWorldline[]}]]
```

## Properties and Relations

The cardinality is the number of members, and every member is a chain of τ(*p*, *q*) + 1 events that passes [InfraWorldlineQ]().

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
    Length[members] == InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"] &&
      Union[Length /@ members] == {InfraMeasurement[g, InfraWorldline[p, q], "Length"] + 1} &&
      InfraWorldlineQ[g, members]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice every maximal chain from {*i*, *j*} to {*k*, *l*} is longest, and there are Binomial[(*k* − *i*) + (*l* − *j*), *k* − *i*] of them.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> And @@ Thread[p <= q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"] == Binomial[Total[q - p], First[q - p]]]]]
```

The proper time is the universal time of *q* in the diamond [*p*, *q*], whose only source is *p*.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> MemberQ[RandomInfraCausalFuture[g, p], q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraWorldline[p, q], "Length"] == UniversalTime[InfraMeasurement[g, InfraCausalDiamond[p, q], "Subgraph"]][q]]]]
```
