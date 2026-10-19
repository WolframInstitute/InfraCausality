---
Template: Symbol
Name: InfraTimelikeGeodesicQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraTimelikeGeodesicQ
Keywords: [timelike geodesic, longest chain, proper time, predicate, chain hierarchy]
SeeAlso: [InfraTimelikeGeodesic, RandomInfraTimelikeGeodesic, InfraWorldlineQ, InfraChainQ, InfraLightRayQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraTimelikeGeodesicQ]()[*g*, *chain*]</code> gives `True` if the vertex list *chain* is a longest chain of *g* between its first and its last event.

<code>[InfraTimelikeGeodesicQ]()[*g*, {*chain1*, *chain2*, …}]</code> tests every chain in the list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is a timelike geodesic when it is a saturated chain of *g*, as [InfraWorldlineQ]() tests, and its number of edges *k* equals the proper time τ(*e*0, *ek*), the number of edges of a longest chain from *e*0 to *ek*. No chain between the same two events is longer.

The saturation condition is implied by the length: a chain that skipped an event between two of its consecutive events could be lengthened by inserting it. So a timelike geodesic is any chain, in the sense of [InfraChainQ](), of maximal length between its endpoints, and <code>[InfraTimelikeGeodesicQ]()[*g*, *c*]</code> is <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, [InfraTimelikeGeodesic]()[First[*c*], Last[*c*]], *c*]</code>. A single event is a timelike geodesic, the only member of [InfraTimelikeGeodesic]()[*v*, *v*]; the empty list is not.

The predicate takes a chain, never an object; <code>[InfraTimelikeGeodesicQ]()[*g*, [InfraTimelikeGeodesic]()[*p*, *q*]]</code> stays unevaluated. A list of chains is the shape [RandomInfraTimelikeGeodesic]() returns with a count, so it can be passed straight in. A member of a piecewise geodesic <code>[InfraTimelikeGeodesic]()[*p*1, …, *pk*]</code> passes only when it happens to be as long as a timelike geodesic from *p*1 to *pk*; <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)</code> on the polyline head recognises its members.

The chain predicates form a hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraTimelikeGeodesicQ]() | *k* = τ(*e*0, *ek*) |
| [InfraWorldlineQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

## Basic Examples

On each substrate, a timelike geodesic passes, and the same chain with one inner event removed fails: it is still a chain, but one edge short.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q]])},
    {InfraTimelikeGeodesicQ[g, member], InfraTimelikeGeodesicQ[g, Delete[member, 2]], InfraChainQ[g, Delete[member, 2]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the sprinkling the worldlines between two events have different lengths. The shortest one is saturated but is not a timelike geodesic; the longest one is.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {InfraWalk[chain]}], {InfraWorldlineQ[g, chain], InfraTimelikeGeodesicQ[g, chain]}],
    {chain, {First @ MinimalBy[members, Length], First @ MaximalBy[members, Length]}}]]
```

A list of chains is tested chain by chain, and a single event is a timelike geodesic.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {InfraTimelikeGeodesicQ[g, (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, {0, 0}, {3, 6}, 5])], InfraTimelikeGeodesicQ[g, {{0, 0}}]}]
```

## Properties and Relations

The predicate is membership in the timelike-geodesic family of the endpoints. Checked on every worldline between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    AllTrue[RandomInfraWorldline[g, InfraWorldline[p, q], All], chain |->
      InfraTimelikeGeodesicQ[g, chain] === InfraMemberQ[g, InfraTimelikeGeodesic[p, q], chain] ===
        (Length[chain] - 1 == InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Length"])]]]
```

The hierarchy: every light ray is a timelike geodesic, every timelike geodesic a worldline, every worldline a chain. Checked on every path of the graph between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    AllTrue[FindPath[g, p, q, Infinity, All], chain |->
      Implies[InfraLightRayQ[g, chain], InfraTimelikeGeodesicQ[g, chain]] && Implies[InfraTimelikeGeodesicQ[g, chain], InfraWorldlineQ[g, chain]] &&
        Implies[InfraWorldlineQ[g, chain], InfraChainQ[g, chain]]]]]
```

On the two lattices every worldline is a timelike geodesic; on the sprinkling there are worldlines that are not.

```wl
With[
  {counts = Table[
    With[
      {g = CausalSubstrate[name, "Small"]},
      {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
      {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
      Count[RandomInfraWorldline[g, InfraWorldline[p, q], All], chain_ /; ! InfraTimelikeGeodesicQ[g, chain]]],
    {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]},
  First[counts] == Last[counts] == 0 < counts[[2]]]
```
