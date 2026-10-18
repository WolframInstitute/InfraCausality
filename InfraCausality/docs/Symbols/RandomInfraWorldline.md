---
Template: Symbol
Name: RandomInfraWorldline
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraWorldline
Keywords: [worldline, longest chain, timelike geodesic, uniform sampling, sampler, count contract, NextVertexFunction]
SeeAlso: [InfraWorldline, InfraWorldlineQ, RandomInfraObserver, RandomInfraFutureLightCone, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraWorldline]()[*g*, [InfraWorldline]()[*p*, *q*]]</code> gives one longest chain from *p* to *q* on *g*, drawn uniformly, as a vertex list.

<code>[RandomInfraWorldline]()[*g*, [InfraWorldline]()[*p*, *q*], *n*]</code> gives a `List` of *n* distinct longest chains, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every longest chain.

<code>[RandomInfraWorldline]()[*g*, *p*, *q*, *n*]</code> is the shortcut for <code>[InfraWorldline]()[*p*, *q*]</code>, and <code>[RandomInfraWorldline]()[*g*, *n*]</code> for the longest chains of the whole graph, <code>[InfraWorldline]()[]</code>.

## Details & Options

Definition: the members of a worldline head are its longest chains, the paths from source to sink of <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *w*, "Graph"]</code>. A member is a vertex list *p* = *e*0 ≺ … ≺ *ek* = *q* in causal order, with *k* = τ(*p*, *q*). The same sampler draws every form of [InfraWorldline](): the two-event form, the whole-graph form, and the experimental polyline and from-event forms.

The default draw is uniform over the members. It descends the graph of the head from a source, choosing each next event with probability proportional to the number of members through it, which dynamic programming counts once; so each member is drawn with probability 1/`"Cardinality"`. Seed with `SeedRandom` to reproduce a draw.

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

[InfraWorldlineQ]() recognises a member of some worldline family, and <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, *w*, *chain*]</code> a member of the family *w*.

## Basic Examples

One worldline from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q]])},
    InfraSubstrateHighlight[g, {InfraWalk[member], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The count-less call is one vertex list; a count gives a list of distinct members.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {(SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {1, 2}]), (SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {1, 2}, 2])}]
```

There are three worldlines from {0, 0} to {1, 2}, so a strict count of 4 gives the empty list and `UpTo[4]` gives all three.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {(SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {1, 2}, 4]), (SeedRandom[1]; Length @ RandomInfraWorldline[g, {0, 0}, {1, 2}, UpTo[4]])}]
```

`"NextVertexFunction" -> Identity` gives the first members in sorted order, without randomness.

```wl
RandomInfraWorldline[CausalSubstrate["CylinderLatticeGraph", "Small"], {0, 0}, {2, 4}, 3, "NextVertexFunction" -> Identity]
```

Three of the longest chains of the whole sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {members = (SeedRandom[1]; RandomInfraWorldline[g, 3])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member]}], {member, members}]]
```

## Properties and Relations

`All` gives `"Cardinality"` distinct members, each a chain of τ(*p*, *q*) + 1 events that passes [InfraWorldlineQ]() and [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ).

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
    DuplicateFreeQ[members] && Length[members] == InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"] &&
      Union[Length /@ members] == {InfraMeasurement[g, InfraWorldline[p, q], "Length"] + 1} &&
      InfraWorldlineQ[g, members] && AllTrue[members, InfraMemberQ[g, InfraWorldline[p, q], #] &]]]
```

The default draw is uniform: over 1500 draws each of the three worldlines from {0, 0} to {1, 2} of the diamond lattice appears with frequency within 0.05 of 1/3.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {draws = (SeedRandom[1]; Table[RandomInfraWorldline[g, {0, 0}, {1, 2}], 1500])},
  Sort[Keys @ Counts @ draws] === Sort @ RandomInfraWorldline[g, {0, 0}, {1, 2}, All] &&
    AllTrue[Values @ Counts @ draws, Abs[#/1500 - 1/3] < 0.05 &]]
```

`"NextVertexFunction" -> Identity` takes the members in sorted order, and the same seed gives the same draw.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {n = Min[3, InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"]]},
    RandomInfraWorldline[g, InfraWorldline[p, q], n, "NextVertexFunction" -> Identity] === Take[Sort @ RandomInfraWorldline[g, InfraWorldline[p, q], All], n] &&
      (SeedRandom[7]; RandomInfraWorldline[g, InfraWorldline[p, q], n]) === (SeedRandom[7]; RandomInfraWorldline[g, InfraWorldline[p, q], n])]]
```

Every worldline lies in the causal diamond of its endpoints, and the worldlines of the whole graph run from a source to a sink.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {members = (SeedRandom[1]; RandomInfraWorldline[g, UpTo[20]])},
    AllTrue[members, member |->
      SubsetQ[Keys @ InfraMeasurement[g, InfraCausalDiamond[First @ member, Last @ member], "VertexDensity"], member] &&
        VertexInDegree[g, First @ member] == 0 && VertexOutDegree[g, Last @ member] == 0]]]
```
