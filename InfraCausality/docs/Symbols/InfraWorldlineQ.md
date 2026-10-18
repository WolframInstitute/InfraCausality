---
Template: Symbol
Name: InfraWorldlineQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraWorldlineQ
Keywords: [worldline, longest chain, timelike geodesic, proper time, predicate, chain hierarchy]
SeeAlso: [InfraWorldline, RandomInfraWorldline, InfraObserverQ, InfraChainQ, InfraLightRayQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraWorldlineQ]()[*g*, *chain*]</code> gives `True` if the vertex list *chain* is a longest chain of *g* between its first and its last event.

<code>[InfraWorldlineQ]()[*g*, {*chain1*, *chain2*, …}]</code> tests every chain in the list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is a worldline when it is a saturated chain of *g*, as [InfraObserverQ]() tests, and its number of edges *k* equals the proper time τ(*e*0, *ek*), the number of edges of a longest chain from *e*0 to *ek*. No chain between the same two events is longer.

The saturation condition is implied by the length: a chain that skipped an event between two of its consecutive events could be lengthened by inserting it. So a worldline is any chain, in the sense of [InfraChainQ](), of maximal length between its endpoints, and <code>[InfraWorldlineQ]()[*g*, *c*]</code> is <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, [InfraWorldline]()[First[*c*], Last[*c*]], *c*]</code>. A single event is a worldline, the only member of [InfraWorldline]()[*v*, *v*]; the empty list is not.

The predicate takes a chain, never an object; <code>[InfraWorldlineQ]()[*g*, [InfraWorldline]()[*p*, *q*]]</code> stays unevaluated. A list of chains is the shape [RandomInfraWorldline]() returns with a count, so it can be passed straight in. A member of a polyline worldline <code>[InfraWorldline]()[*p*1, …, *pk*]</code> passes only when it happens to be as long as a worldline from *p*1 to *pk*; <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)</code> on the polyline head recognises its members.

The chain predicates form a hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraWorldlineQ]() | *k* = τ(*e*0, *ek*) |
| [InfraObserverQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

## Basic Examples

On each substrate, a worldline passes, and the same worldline with one inner event removed fails: it is still a chain, but one edge short.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q]])},
    {InfraWorldlineQ[g, member], InfraWorldlineQ[g, Delete[member, 2]], InfraChainQ[g, Delete[member, 2]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the sprinkling the observers between two events have clocks of different lengths. The shortest one is saturated but is not a worldline; the longest one is.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = RandomInfraObserver[g, InfraObserver[p, q], All]},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {InfraWalk[chain]}], {InfraObserverQ[g, chain], InfraWorldlineQ[g, chain]}],
    {chain, {First @ MinimalBy[members, Length], First @ MaximalBy[members, Length]}}]]
```

A list of chains is tested chain by chain, and a single event is a worldline.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {InfraWorldlineQ[g, (SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {3, 6}, 5])], InfraWorldlineQ[g, {{0, 0}}]}]
```

## Properties and Relations

The predicate is membership in the worldline family of the endpoints. Checked on every observer between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    AllTrue[RandomInfraObserver[g, InfraObserver[p, q], All], chain |->
      InfraWorldlineQ[g, chain] === InfraMemberQ[g, InfraWorldline[p, q], chain] ===
        (Length[chain] - 1 == InfraMeasurement[g, InfraWorldline[p, q], "Length"])]]]
```

The hierarchy: every light ray is a worldline, every worldline an observer, every observer a chain. Checked on every path of the graph between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    AllTrue[FindPath[g, p, q, Infinity, All], chain |->
      Implies[InfraLightRayQ[g, chain], InfraWorldlineQ[g, chain]] && Implies[InfraWorldlineQ[g, chain], InfraObserverQ[g, chain]] &&
        Implies[InfraObserverQ[g, chain], InfraChainQ[g, chain]]]]]
```

On the two lattices every observer is a worldline; on the sprinkling there are observers that are not.

```wl
With[
  {counts = Table[
    With[
      {g = CausalSubstrate[name, "Small"]},
      {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
      {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
      Count[RandomInfraObserver[g, InfraObserver[p, q], All], chain_ /; ! InfraWorldlineQ[g, chain]]],
    {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]},
  First[counts] == Last[counts] == 0 < counts[[2]]]
```
