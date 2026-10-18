---
Template: Symbol
Name: RandomInfraObserver
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraObserver
Keywords: [observer, saturated chain, clock, uniform sampling, sampler, count contract, NextVertexFunction]
SeeAlso: [InfraObserver, InfraObserverQ, RandomInfraWorldline, InfraMessageFunction, InfraRadarChart, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraObserver]()[*g*, [InfraObserver]()[*p*, *q*]]</code> gives one saturated chain from *p* to *q* on *g*, drawn uniformly, as a vertex list.

<code>[RandomInfraObserver]()[*g*, [InfraObserver]()[*p*, *q*], *n*]</code> gives a `List` of *n* distinct saturated chains, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every one.

<code>[RandomInfraObserver]()[*g*, *p*, *q*, *n*]</code> is the shortcut for <code>[InfraObserver]()[*p*, *q*]</code>, and <code>[RandomInfraObserver]()[*g*, *n*]</code> for the inextendible observers of the whole graph, <code>[InfraObserver]()[]</code>.

## Details & Options

Definition: the members of an observer head are its saturated chains, the paths from source to sink of <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *o*, "Graph"]</code>, the Hasse diagram on the diamond [*p*, *q*]. A member is a vertex list in causal order whose consecutive events are covering pairs; its positions are the ticks of the observer's clock. For <code>[InfraObserver]()[]</code> the members are the saturated chains from a source of the graph to a sink, the observers that cannot be extended at either end.

The default draw is uniform over the members: each next event is chosen with probability proportional to the number of members through it, counted once by dynamic programming. Observers between the same events can have different numbers of ticks, and the draw is uniform over observers, not over lengths. Seed with `SeedRandom` to reproduce a draw.

The count contract is the one every `RandomInfra…` sampler shares:

| Count | Result |
|---|---|
| omitted or `Automatic` | one member, a vertex list; `{}` when the family is empty |
| *n* | a `List` of exactly *n* distinct members, or `{}` when there are fewer |
| `UpTo[n]` | a `List` of min(*n*, `"Cardinality"`) distinct members |
| `All` | every member, enumerated without drawing |

The option `"NextVertexFunction"` replaces the uniform descent:

| Value | Draw |
|---|---|
| `Automatic` | uniform, as above |
| `Identity` | depth-first enumeration with the next events in sorted order: the first *n* members in sorted order, deterministic |
| `RandomSample` | depth-first enumeration with the next events shuffled: *n* distinct members, not uniform |
| `RandomChoice` | independent random walks, each next event chosen with equal probability: distinct members, not uniform; not combined with `All` |
| *f* | *f* is applied to the sorted list of next events; a list sets the order of the search, a single event prunes the search to it |

The members are the observers that [InfraMessageFunction]() and [InfraRadarChart]() take as arguments. [InfraObserverQ]() recognises one.

## Basic Examples

One observer from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraObserver[g, InfraObserver[p, q]])},
    InfraSubstrateHighlight[g, {InfraWalk[member], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Five observers between two events of the sprinkling, and their numbers of ticks.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = (SeedRandom[1]; RandomInfraObserver[g, InfraObserver[p, q], 5])},
  {members, Length /@ members}]
```

A strict count above the number of observers gives the empty list; `UpTo` gives them all.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {(SeedRandom[1]; RandomInfraObserver[g, {0, 0}, {1, 2}, 3]), (SeedRandom[1]; RandomInfraObserver[g, {0, 0}, {1, 2}, UpTo[3]])}]
```

Three inextendible observers of the cylinder lattice, from its bottom row to its top row.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {members = (SeedRandom[1]; RandomInfraObserver[g, 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

## Properties and Relations

`All` gives `"Cardinality"` distinct members, each passing [InfraObserverQ](), and the worldlines between the same events are among them.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {members = RandomInfraObserver[g, InfraObserver[p, q], All]},
    DuplicateFreeQ[members] && Length[members] == InfraMeasurement[g, InfraObserver[p, q], "Cardinality"] &&
      InfraObserverQ[g, members] && SubsetQ[members, RandomInfraWorldline[g, InfraWorldline[p, q], All]]]]
```

The distinct numbers of edges of the members are the `"Length"` reading of the head.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    Replace[Union[Length /@ RandomInfraObserver[g, InfraObserver[p, q], All] - 1], {one_} :> one] ===
      InfraMeasurement[g, InfraObserver[p, q], "Length"]]]
```

The default draw is uniform over observers: over 1500 draws each of the observers from {0, 0} to {1, 2} of the cylinder lattice appears with frequency within 0.05 of 1/2.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {draws = (SeedRandom[1]; Table[RandomInfraObserver[g, {0, 0}, {1, 2}], 1500])},
  Sort[Keys @ Counts @ draws] === Sort @ RandomInfraObserver[g, {0, 0}, {1, 2}, All] &&
    AllTrue[Values @ Counts @ draws, Abs[#/1500 - 1/2] < 0.05 &]]
```

The inextendible observers run from a source to a sink, and each one is an observer between its own two ends.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {members = (SeedRandom[1]; RandomInfraObserver[g, UpTo[20]])},
    AllTrue[members, member |->
      VertexInDegree[g, First @ member] == 0 && VertexOutDegree[g, Last @ member] == 0 &&
        InfraMemberQ[g, InfraObserver[First @ member, Last @ member], member]]]]
```
