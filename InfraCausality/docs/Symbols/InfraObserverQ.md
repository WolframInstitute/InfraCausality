---
Template: Symbol
Name: InfraObserverQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraObserverQ
Keywords: [observer, saturated chain, covering pair, Hasse diagram, clock, predicate, chain hierarchy]
SeeAlso: [InfraObserver, RandomInfraObserver, InfraChainQ, InfraWorldlineQ, InfraLightRayQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraObserverQ]()[*g*, *chain*]</code> gives `True` if the vertex list *chain* is a saturated chain of *g*, each pair of consecutive events an edge of the Hasse diagram.

<code>[InfraObserverQ]()[*g*, {*chain1*, *chain2*, …}]</code> tests every chain in the list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is an observer when it is nonempty, its elements are events of *g*, and each consecutive pair is a covering pair: *e*<sub>*i*</sub> ≺ *e*<sub>*i*+1</sub> with no event strictly between them, so that the diamond [*e*<sub>*i*</sub>, *e*<sub>*i*+1</sub>] has exactly two events. The covering pairs are the edges of the Hasse diagram, `TransitiveReductionGraph`[*g*]; on a transitively reduced graph, such as every [CausalSubstrate](), they are the edges of *g* itself.

An observer is a clock: it ticks at every event it passes and skips none it could have passed. <code>[InfraObserverQ]()[*g*, *c*]</code> is <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, [InfraObserver]()[First[*c*], Last[*c*]], *c*]</code>. A single event is an observer; the empty list is not.

The predicate takes a chain, never an object; <code>[InfraObserverQ]()[*g*, [InfraObserver]()[*p*, *q*]]</code> stays unevaluated. A list of chains, the shape [RandomInfraObserver]() returns with a count, can be passed straight in.

The chain predicates form a hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraWorldlineQ]() | *k* = τ(*e*0, *ek*) |
| [InfraObserverQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

## Basic Examples

On each substrate: an observer passes, the same observer with an inner tick removed fails, and so does the observer read backwards.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {member = (SeedRandom[1]; RandomInfraObserver[g, InfraObserver[p, q]])},
    {InfraObserverQ[g, member], InfraObserverQ[g, Delete[member, 2]], InfraObserverQ[g, Reverse @ member]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

An observer of the sprinkling and the chain obtained by skipping one of its ticks.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {member = (SeedRandom[1]; RandomInfraObserver[g, InfraObserver[]])},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {InfraWalk[chain]}], {InfraChainQ[g, chain], InfraObserverQ[g, chain]}],
    {chain, {member, Delete[member, 2]}}]]
```

## Properties and Relations

On a substrate the covering pairs are the edges, so a list is an observer exactly when it is a directed path of the graph. Checked on every path between two events of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {chains = Select[Subsets[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], {2, 5}], InfraChainQ[g, #] &]},
    AllTrue[chains, chain |-> InfraObserverQ[g, chain] === AllTrue[Partition[chain, 2, 1], EdgeQ[g, DirectedEdge @@ #] &]]]]
```

The predicate is membership in the observer family of the endpoints.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[2]])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {chains = Select[Subsets[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], {2, 5}], InfraChainQ[g, #] && First[#] === p && Last[#] === q &]},
    AllTrue[chains, chain |-> InfraObserverQ[g, chain] === InfraMemberQ[g, InfraObserver[p, q], chain]]]]
```

Every worldline is an observer, and every observer is a chain.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
    InfraObserverQ[g, RandomInfraWorldline[g, InfraWorldline[p, q], All]] && InfraChainQ[g, RandomInfraObserver[g, InfraObserver[p, q], All]]]]
```
