---
Template: Symbol
Name: InfraTimelikeGeodesic
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraTimelikeGeodesic
Keywords: [timelike geodesic, longest chain, proper time, maximal chain, twin paradox, piecewise geodesic, polyline, symbolic object]
SeeAlso: [RandomInfraTimelikeGeodesic, InfraTimelikeGeodesicQ, InfraObserver, InfraCausalDiamond, InfraFutureLightCone, UniversalTime, InfraChainQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraTimelikeGeodesic]()[*p*, *q*]</code> is the family of timelike geodesics from *p* to *q*: every longest chain from *p* to *q* at once.

<code>[InfraTimelikeGeodesic]()[]</code> is the family of longest chains of the whole graph.

<code>[InfraTimelikeGeodesic]()[*p*1, …, *pk*]</code> is the family of piecewise geodesics through the knots *p*1 ≺ … ≺ *pk*: a longest chain from each knot to the next, concatenated.

<code>[InfraTimelikeGeodesic]()[*p*]</code> is the family of longest chains starting at *p*.

## Details & Options

Definition: a timelike geodesic from *p* to *q* is a chain *p* = *e*0 ≺ *e*1 ≺ … ≺ *ek* = *q* of maximal length *k*. The maximal length is the proper time τ(*p*, *q*), the number of edges of a longest directed path from *p* to *q*.

The proper time is the discrete analogue of the length of a timelike curve, and a longest chain is the analogue of a timelike geodesic: in Minkowski space the straight worldline between two events maximises the proper time, and every other route is shorter. On a graph the longest chain is rarely unique. The head carries all of them, equally admissible, so nothing distinguishes one.

The head holds its two events and computes nothing. Its graph, <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *geo*, "Graph"]</code>, keeps the events *v* of the diamond [*p*, *q*] with τ(*p*, *v*) + τ(*v*, *q*) = τ(*p*, *q*) and the edges along which τ(*p*, ·) rises by one. Its paths from *p* to *q* are exactly the longest chains, each once, so `"Faithful"` is `True`, and every count is read off that graph by dynamic programming, never by enumeration.

| Property | Value |
|---|---|
| `"Graph"` | the directed acyclic graph whose *p*-to-*q* paths are the longest chains |
| `"Length"` | the proper time τ(*p*, *q*); `-Infinity` when *q* does not follow *p* |
| `"Cardinality"` | the number of longest chains |
| `"VertexDensity"` | for each event, the number of longest chains through it |
| `"EdgeDensity"` | for each edge, the number of longest chains through it |
| `"Faithful"` | `True` |

<code>[InfraTimelikeGeodesic]()[]</code> is the same construction on the whole graph: the chains from a source to a sink whose length is the height of the graph, the maximum of [UniversalTime]().

A member is a vertex list in causal order; [RandomInfraTimelikeGeodesic]() draws members uniformly, and [InfraTimelikeGeodesicQ]() recognises one. Every timelike geodesic is an observer, a saturated chain; see [InfraObserver]().

Experimental: the two further call forms are the same construction on other graphs. <code>[InfraTimelikeGeodesic]()[*p*1, …, *pk*]</code>, with *k* ≥ 3, is the polyline whose legs are the timelike geodesics from *p*<sub>*i*</sub> to *p*<sub>*i*+1</sub>; its `"Graph"` is the union of the legs' graphs, which meet only at the knots, so every path from *p*1 to *pk* passes every knot and is a member, `"Length"` is the sum τ(*p*1, *p*2) + … + τ(*p*<sub>*k*−1</sub>, *pk*) of the legs' proper times and `"Cardinality"` the product of their cardinalities. A member is a piecewise geodesic, the discrete twin who turns at the knots; between the same endpoints it is at most as long as a timelike geodesic. When some knot does not precede the next the family is empty. <code>[InfraTimelikeGeodesic]()[*p*]</code> is the family of longest chains that start at *p*: with *h* the largest proper time τ(*p*, *e*) over the causal future of *p*, its `"Graph"` keeps the events *v* of *J*⁺(*p*) with τ(*p*, *v*) + τ⁻(*v*) = *h*, where τ⁻(*v*) is the longest chain from *v* inside *J*⁺(*p*), and the edges along which τ(*p*, ·) rises by one; its `"Length"` is *h*. Both forms are sampled by [RandomInfraTimelikeGeodesic]() and recognised by <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)</code> like the two-event form.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Timelike geodesic | Between two timelike-separated events the straight worldline is the unique causal curve of maximal proper time. |
| Causal sets | Longest chain | The length of a longest chain between two elements of a sprinkling estimates the proper time between them. |
| EPS | Free particle | The worldlines of freely falling particles are the geodesics of the projective structure. |

## Basic Examples

The timelike geodesics from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice. An edge is drawn as strongly as the number of longest chains through it.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The proper time and the number of timelike geodesics between the same events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    Values @ InfraMeasurement[g, InfraTimelikeGeodesic[p, q], {"Length", "Cardinality"}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The graph of the timelike geodesics on the sprinkling. Every longest chain is a path through it from its source to its sink.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  Graph[InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Graph"], VertexLabels -> Automatic]]
```

The members are vertex lists. Three of the 20 timelike geodesics from the bottom row to the top row of the cylinder lattice, each drawn as a walk.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {members = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {3, 6}], 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

The longest chains of the whole sprinkling run from a source to a sink through every slice of the universal foliation.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[]}]]
```

## Scope

### Experimental: piecewise geodesics

The piecewise geodesics through three knots of the diamond lattice: a timelike geodesic from the first knot to the second, then from the second to the third. Every member passes the middle knot.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[{0, 0}, {4, 1}, {6, 6}], {0, 0}, {4, 1}, {6, 6}}]]
```

The proper time of the polyline is the sum of its legs' proper times, and its cardinality is their product, 5 times 21.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  Values @ InfraMeasurement[g, InfraTimelikeGeodesic[{0, 0}, {4, 1}, {6, 6}], {"Length", "Cardinality"}]]
```

Three members drawn as walks. Each one turns at the middle knot.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {members = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {4, 1}, {6, 6}], 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

A polyline on the sprinkling, through an event of the first slice, an event of its future and an event of that one's future.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[4]]])},
  {r = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[q], InfraSlice[7]]])},
  InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[p, q, r], p, q, r}]]
```

The longest chains starting at an event of the diamond lattice all end at the top corner; their proper time is the height of the event's future.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[{2, 1}], {2, 1}}]]
```

The longest chains starting at an event of the sprinkling, and their proper time.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {InfraSubstrateHighlight[g, {InfraTimelikeGeodesic[p], p}], InfraMeasurement[g, InfraTimelikeGeodesic[p], "Length"]}]
```

## Properties and Relations

The cardinality is the number of members, and every member is a chain of τ(*p*, *q*) + 1 events that passes [InfraTimelikeGeodesicQ]().

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {members = RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q], All]},
    Length[members] == InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Cardinality"] &&
      Union[Length /@ members] == {InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Length"] + 1} &&
      InfraTimelikeGeodesicQ[g, members]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice every maximal chain from {*i*, *j*} to {*k*, *l*} is longest, and there are Binomial[(*k* − *i*) + (*l* − *j*), *k* − *i*] of them.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> And @@ Thread[p <= q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Cardinality"] == Binomial[Total[q - p], First[q - p]]]]]
```

The proper time is the universal time of *q* in the diamond [*p*, *q*], whose only source is *p*.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> MemberQ[Keys @ InfraMeasurement[g, InfraCausalFuture[p], "VertexDensity"], q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Length"] == UniversalTime[InfraMeasurement[g, InfraCausalDiamond[p, q], "Subgraph"]][q]]]]
```

The members of a polyline are the concatenations of one timelike geodesic per leg: the cardinality is the product of the legs' cardinalities, the proper time their sum, and splitting a member at the knots gives a timelike geodesic on each leg.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[3]]])},
    {r = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[q], InfraSlice[5]]])},
    {members = RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q, r], All],
     cuts = Accumulate @ {1, InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Length"], InfraMeasurement[g, InfraTimelikeGeodesic[q, r], "Length"]}},
    Length[members] == InfraMeasurement[g, InfraTimelikeGeodesic[p, q, r], "Cardinality"] ==
        InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Cardinality"] InfraMeasurement[g, InfraTimelikeGeodesic[q, r], "Cardinality"] &&
      InfraMeasurement[g, InfraTimelikeGeodesic[p, q, r], "Length"] == Last[cuts] - 1 &&
      AllTrue[members, member |-> InfraTimelikeGeodesicQ[g, Take[member, cuts[[{1, 2}]]]] && InfraTimelikeGeodesicQ[g, Take[member, cuts[[{2, 3}]]]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The longest chains starting at *p* are timelike geodesics from *p* to events of its future at the largest proper time from *p*.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {members = RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p], All],
     height = Max[InfraMeasurement[g, InfraTimelikeGeodesic[p, #], "Length"] & /@ Keys @ InfraMeasurement[g, InfraCausalFuture[p], "VertexDensity"]]},
    InfraMeasurement[g, InfraTimelikeGeodesic[p], "Length"] == height &&
      Union[Length /@ members] == {height + 1} && InfraTimelikeGeodesicQ[g, members] &&
      AllTrue[members, InfraMemberQ[g, InfraTimelikeGeodesic[p], #] &]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```
