---
Template: Symbol
Name: InfraCausalDiamond
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalDiamond
Keywords: [causal diamond, Alexandrov interval, causal interval, order interval, causal hull, convex set, interval volume, symbolic object]
SeeAlso: [RandomInfraCausalDiamond, InfraCausalDiamondQ, InfraCausalFuture, InfraCausalPast, InfraWorldline, InfraObserver, InfraRadarChart]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalDiamond]()[*p*, *q*]</code> is the causal diamond of the events *p* and *q*: every event that lies after *p* and before *q*.

<code>[InfraCausalDiamond]()[{*v1*, *v2*, …}]</code> is the causal hull of a set of events: every event that lies after one of them and before one of them.

## Details & Options

Definition: the causal diamond of two events *p* and *q* of a directed acyclic graph is [*p*, *q*] = *J*⁺(*p*) ∩ *J*⁻(*q*) = {*e* : *p* ≼ *e* ≼ *q*}, the Alexandrov interval of the causal order.

It is empty unless *p* ≼ *q*, and it is the single event *p* when *p* = *q*. It is convex: with two of its events *u* ≼ *w* it contains every event between them. Every causal chain from *p* to *q* runs inside it, so it carries the worldlines and the observers between its tips, and it is the radar domain of an observer from *p* to *q*.

The causal hull of a set *S* is *J*⁺(*S*) ∩ *J*⁻(*S*), the smallest convex set containing *S*. The hull of a chain from *p* to *q* is the diamond [*p*, *q*].

The head holds its tips and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on every event of the diamond, keys sorted |
| `"EdgeDensity"` | 1 on every edge between two events of the diamond |
| `"Subgraph"` | the subgraph induced on the diamond |
| `"CountingMeasure"` | the interval volume, the number of events of the diamond |
| `"Cardinality"` | 1: the diamond is a set, and its support is its only member |
| `"Faithful"` | `True` |

The interval volume is the quantity causal-set theory reads proper time and dimension from: in a sprinkling of density ρ into *d*-dimensional Minkowski space the expected number of events of [*p*, *q*] is ρ times the spacetime volume of the diamond, which is proportional to the *d*-th power of the proper time between the tips.

[RandomInfraCausalDiamond]() returns the support as a sorted vertex list, and [InfraCausalDiamondQ]() recognises a vertex set that is the diamond of its least and greatest events.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Causal diamond | The intersection *J*⁺(*p*) ∩ *J*⁻(*q*) of the future of *p* and the past of *q*, a double cone. |
| Causal sets | Order interval | The interval [*p*, *q*] = {*x* : *p* ≼ *x* ≼ *q*}; its cardinality estimates the spacetime volume between *p* and *q*. |
| Alexandrov topology | Alexandrov interval | The open intervals *I*⁺(*p*) ∩ *I*⁻(*q*) form the base of the Alexandrov topology, which equals the manifold topology in a strongly causal spacetime. |

## Basic Examples

The causal diamond between an event at height 1 and an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[Max[UniversalTime[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraCausalDiamond[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The diamond is the overlap of the causal future of its lower tip and the causal past of its upper tip.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[6]]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCausalFuture[p], InfraCausalPast[q]}],
    InfraSubstrateHighlight[g, {InfraCausalDiamond[p, q], p, q}]}]]
```

The causal hull of three events of the diamond lattice, the smallest convex set that contains them: the union of the diamonds between the comparable pairs. The two upper events are incomparable, so the hull has two arms.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {s = {{0, 3}, {3, 4}, {1, 6}}},
  InfraSubstrateHighlight[g, {InfraCausalDiamond[s], s}]]
```

The interval volume of the diamonds from the bottom event of the diamond lattice to every event of the slice at height 6.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  Table[InfraMeasurement[g, InfraCausalDiamond[{0, 0}, q], "CountingMeasure"], {q, RandomInfraSlice[g, InfraSlice[6]]}]]
```

## Properties and Relations

The diamond is the intersection of the causal future of *p* and the causal past of *q*, for every pair of events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Tuples[VertexList[g], 2], Apply[{p, q} |->
      RandomInfraCausalDiamond[g, p, q] === Intersection[RandomInfraCausalFuture[g, p], RandomInfraCausalPast[g, q]]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice the diamond of {*i*, *j*} ≼ {*k*, *l*} is a rectangle of (*k* − *i* + 1)(*l* − *j* + 1) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> And @@ Thread[p <= q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraCausalDiamond[p, q], "CountingMeasure"] == Times @@ (q - p + 1)]]]
```

The diamond is convex: an event between two of its events is one of its events.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[6]]])},
  {diamond = RandomInfraCausalDiamond[g, p, q]},
  AllTrue[Tuples[diamond, 2], Apply[{u, w} |-> SubsetQ[diamond, RandomInfraCausalDiamond[g, u, w]]]]]
```

The causal hull of every worldline from *p* to *q* is the diamond of its tips.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {p = (SeedRandom[2]; RandomChoice @ RandomInfraSlice[g, InfraSlice[0]])},
  {q = (SeedRandom[2]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[5]]])},
  AllTrue[RandomInfraWorldline[g, InfraWorldline[p, q], All], chain |->
    RandomInfraCausalDiamond[g, InfraCausalDiamond[chain]] === RandomInfraCausalDiamond[g, p, q]]]
```
