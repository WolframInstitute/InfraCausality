---
Template: Symbol
Name: InfraChainQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraChainQ
Keywords: [chain, totally ordered subset, causal order, predicate, chain hierarchy]
SeeAlso: [InfraWorldlineQ, InfraTimelikeGeodesicQ, InfraLightRayQ, InfraCausalDiamond, RandomInfraWorldline, InfraAntichainQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraChainQ]()[*g*, *list*]</code> gives `True` if the vertex list *list* is a chain of *g*: duplicate-free, with each event preceding the next in the causal order.

<code>[InfraChainQ]()[*g*, {*list1*, *list2*, …}]</code> tests every list.

## Details & Options

Statement: a vertex list *e*0, …, *ek* is a chain when it is nonempty, its elements are distinct events of *g*, and *e*<sub>*i*</sub> ≺ *e*<sub>*i*+1</sub> for every *i*: a directed path of *g* leads from each event to the next.

Since the causal order is transitive, a chain is a totally ordered set of events listed in causal order: any two of its events are comparable, and the earlier one comes first. The consecutive events need not be adjacent, so a chain may skip events that lie between them; the chain predicates above it in the hierarchy forbid that. A single event is a chain; the empty list is not.

The chain predicates form a hierarchy, each condition stronger than the next:

| Predicate | A chain *e*0 ≺ … ≺ *ek* such that |
|---|---|
| [InfraLightRayQ]() | the diamond [*e*0, *ek*] is the chain itself |
| [InfraTimelikeGeodesicQ]() | *k* = τ(*e*0, *ek*) |
| [InfraWorldlineQ]() | each consecutive pair is a covering pair |
| [InfraChainQ]() | each event precedes the next |

[InfraAntichainQ]() is the opposite notion: a set of pairwise incomparable events. A chain and an antichain share at most one event.

## Basic Examples

On each substrate: every second event of a longest chain of the graph, the same events in reverse order, and the same events with the last one repeated.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {member = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    {chain = member[[1 ;; -1 ;; 2]]},
    {InfraChainQ[g, chain], InfraChainQ[g, Reverse @ chain], InfraChainQ[g, Append[chain, Last @ chain]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A chain on the diamond lattice that steps diagonally: it skips events, so it is a chain but not a worldline.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {chain = Table[{i, i}, {i, 0, 6, 2}]},
  Labeled[InfraSubstrateHighlight[g, {chain, InfraCausalDiamond[First @ chain, Last @ chain]}], {InfraChainQ[g, chain], InfraWorldlineQ[g, chain]}]]
```

A list of chains is tested chain by chain; a single event is a chain.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {InfraChainQ[g, (SeedRandom[1]; RandomInfraWorldline[g, {0, 0}, {2, 3}, 3])], InfraChainQ[g, {{2, 3}}], InfraChainQ[g, {}]}]
```

## Properties and Relations

A list is a chain exactly when its events are pairwise comparable and listed in causal order, so every sublist of a chain is a chain. Checked on every subset of a timelike geodesic of each substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {member = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    AllTrue[Subsets[Take[member, UpTo[8]], {1, Infinity}], InfraChainQ[g, #] &] &&
      AllTrue[Subsets[Take[member, UpTo[8]], {2}], pair |-> ! InfraChainQ[g, Reverse @ pair]]]]
```

The causal hull of a chain is the diamond of its first and last events.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {members = (SeedRandom[1]; RandomInfraWorldline[g, UpTo[10]])},
    AllTrue[members, chain |->
      InfraChainQ[g, chain] &&
        Keys @ InfraMeasurement[g, InfraCausalDiamond[chain], "VertexDensity"] === Keys @ InfraMeasurement[g, InfraCausalDiamond[First @ chain, Last @ chain], "VertexDensity"]]]]
```

A chain and an antichain share at most one event: every slice of the height foliation meets a chain at most once.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {members = (SeedRandom[1]; RandomInfraWorldline[g, UpTo[10]])},
    AllTrue[Tuples[{members, CausalHeightFoliation[g]}], Apply[{chain, slice} |->
      InfraChainQ[g, chain] && InfraAntichainQ[g, slice] && Length[Intersection[chain, slice]] <= 1]]]]
```
