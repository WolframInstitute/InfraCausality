---
Template: Symbol
Name: InfraWorldlineQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraWorldlineQ
Keywords: [worldline, saturated chain, covering pair, Hasse diagram, observer, predicate, chain hierarchy]
SeeAlso: [InfraWorldline, RandomInfraWorldline, InfraChainQ, InfraTimelikeGeodesicQ, InfraLightRayQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraWorldlineQ]()[*g*, *chain*]</code> gives `True` if the vertex list *chain* is a saturated chain of *g*, each pair of consecutive events an edge of the Hasse diagram.

<code>[InfraWorldlineQ]()[*g*, {*chain1*, *chain2*, …}]</code> tests every chain in the list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is a worldline when it is nonempty, its elements are events of *g*, and each consecutive pair is a covering pair: *e*<sub>*i*</sub> ≺ *e*<sub>*i*+1</sub> with no event strictly between them, so that the diamond [*e*<sub>*i*</sub>, *e*<sub>*i*+1</sub>] has exactly two events. The covering pairs are the edges of the Hasse diagram, `TransitiveReductionGraph`[*g*]; on a transitively reduced graph, such as every [CausalSubstrate](), they are the edges of *g* itself.

A worldline passes every event it could have passed; read as an observer, it is a clock that ticks at each of them. <code>[InfraWorldlineQ]()[*g*, *c*]</code> is <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, [InfraWorldline]()[First[*c*], Last[*c*]], *c*]</code>. A single event is a worldline; the empty list is not.

The predicate takes a chain, never an object; <code>[InfraWorldlineQ]()[*g*, [InfraWorldline]()[*p*, *q*]]</code> stays unevaluated. A list of chains, the shape [RandomInfraWorldline]() returns with a count, can be passed straight in.

The chain predicates form a hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraTimelikeGeodesicQ]() | *k* = τ(*e*0, *ek*) |
| [InfraWorldlineQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

## Basic Examples

On each substrate: a worldline passes, the same worldline with an inner event removed fails, and so does the worldline read backwards.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[p, q]])},
    {InfraWorldlineQ[g, member], InfraWorldlineQ[g, Delete[member, 2]], InfraWorldlineQ[g, Reverse @ member]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A worldline of the sprinkling and the chain obtained by skipping one of its events.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {member = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[]])},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {InfraWalk[chain]}], {InfraChainQ[g, chain], InfraWorldlineQ[g, chain]}],
    {chain, {member, Delete[member, 2]}}]]
```

## Properties and Relations

On a substrate the covering pairs are the edges, so a list is a worldline exactly when it is a directed path of the graph. Checked on every path between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {chains = Select[Subsets[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], {2, 5}], InfraChainQ[g, #] &]},
    AllTrue[chains, chain |-> InfraWorldlineQ[g, chain] === AllTrue[Partition[chain, 2, 1], EdgeQ[g, DirectedEdge @@ #] &]]]]
```

The predicate is membership in the worldline family of the endpoints.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {chains = Select[Subsets[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], {2, 5}], InfraChainQ[g, #] && First[#] === p && Last[#] === q &]},
    AllTrue[chains, chain |-> InfraWorldlineQ[g, chain] === InfraMemberQ[g, InfraWorldline[p, q], chain]]]]
```

Every timelike geodesic is a worldline, and every worldline is a chain.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    InfraWorldlineQ[g, RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q], All]] && InfraChainQ[g, RandomInfraWorldline[g, InfraWorldline[p, q], All]]]]
```
