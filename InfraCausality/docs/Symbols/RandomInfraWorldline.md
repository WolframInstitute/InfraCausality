---
Template: Symbol
Name: RandomInfraWorldline
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraWorldline
Keywords: [worldline, saturated chain, observer, uniform sampling, sampler, count contract, NextVertexFunction]
SeeAlso: [InfraWorldline, InfraWorldlineQ, RandomInfraTimelikeGeodesic, InfraMessageFunction, InfraRadarCoordinates, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraWorldline]()[*g*, [InfraWorldline]()[*p*, *q*]]</code> gives one saturated chain from *p* to *q* on *g*, drawn uniformly, as a vertex list.

<code>[RandomInfraWorldline]()[*g*, [InfraWorldline]()[*p*, *q*], *n*]</code> gives a `List` of *n* distinct saturated chains, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every one.

<code>[RandomInfraWorldline]()[*g*, *p*, *q*, *n*]</code> is the shortcut for <code>[InfraWorldline]()[*p*, *q*]</code>, and <code>[RandomInfraWorldline]()[*g*, *n*]</code> for the inextendible worldlines of the whole graph, <code>[InfraWorldline]()[]</code>.

## Details & Options

Definition: the members of a worldline head are its saturated chains, the paths from source to sink of <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *w*, "Graph"]</code>, the Hasse diagram on the diamond [*p*, *q*]. A member is a vertex list in causal order whose consecutive events are covering pairs; read as an observer, its positions are the ticks of a clock. For <code>[InfraWorldline]()[]</code> the members are the saturated chains from a source of the graph to a sink, the worldlines that cannot be extended at either end.

The default draw is uniform over the members: each next event is chosen with probability proportional to the number of members through it, counted once by dynamic programming. Worldlines between the same events can have different numbers of events, and the draw is uniform over worldlines, not over lengths. Seed with `SeedRandom` to reproduce a draw.

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

The members are the observers that [InfraMessageFunction]() and [InfraRadarCoordinates]() take as arguments, worldlines whose positions are read as clock ticks. [InfraWorldlineQ]() recognises one.

## Basic Examples

One worldline from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q]])},
    InfraSubstrateHighlight[g, {InfraWalk[member], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Five worldlines between two events of the sprinkling, and their numbers of events.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q], 5])},
  {members, Length /@ members}]
```

A strict count above the number of worldlines gives the empty list; `UpTo` gives them all.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {(SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {1, 2}, 3]), (SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {1, 2}, UpTo[3]])}]
```

Three inextendible worldlines of the cylinder lattice, from its bottom row to its top row.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {members = (SeedRandom[1]; RandomInfraWorldline[g, 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

## Properties and Relations

`All` gives `"Cardinality"` distinct members, each passing [InfraWorldlineQ](), and the timelike geodesics between the same events are among them.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
    DuplicateFreeQ[members] && Length[members] == InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"] &&
      InfraWorldlineQ[g, members] && SubsetQ[members, RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q], All]]]]
```

The distinct numbers of edges of the members are the `"Length"` reading of the head.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    Replace[Union[Length /@ RandomInfraWorldline[g, InfraWorldline[p, q], All] - 1], {one_} :> one] ===
      InfraMeasurement[g, InfraWorldline[p, q], "Length"]]]
```

The default draw is uniform over worldlines: over 1500 draws each of the worldlines from {0, 0} to {1, 2} of the cylinder lattice appears with frequency within 0.05 of 1/2.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {draws = (SeedRandom[1]; Table[RandomInfraWorldline[g, {0, 0}, {1, 2}], 1500])},
  Sort[Keys @ Counts @ draws] === Sort @ RandomInfraWorldline[g, {0, 0}, {1, 2}, All] &&
    AllTrue[Values @ Counts @ draws, Abs[#/1500 - 1/2] < 0.05 &]]
```

The inextendible worldlines run from a source to a sink, and each one is a worldline between its own two ends.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {members = (SeedRandom[1]; RandomInfraWorldline[g, UpTo[20]])},
    AllTrue[members, member |->
      VertexInDegree[g, First @ member] == 0 && VertexOutDegree[g, Last @ member] == 0 &&
        InfraMemberQ[g, InfraWorldline[First @ member, Last @ member], member]]]]
```
