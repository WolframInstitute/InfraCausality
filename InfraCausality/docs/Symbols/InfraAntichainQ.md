---
Template: Symbol
Name: InfraAntichainQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraAntichainQ
Keywords: [antichain, incomparable, spacelike, achronal, width, Dilworth, predicate]
SeeAlso: [InfraSliceQ, InfraChainQ, UniversalFoliation, RandomInfraSlice, InfraCausalFutureQ]
RelatedGuides: [CausalTime]
---

## Usage

<code>[InfraAntichainQ]()[*g*, *set*]</code> gives `True` if the vertex list *set* is duplicate-free and no two of its elements are comparable in the causal order of *g*.

<code>[InfraAntichainQ]()[*g*, {*set1*, *set2*, …}]</code> tests every set in the list.

<code>[InfraAntichainQ]()[*g*, *density*]</code> tests the keys of a density association.

## Details & Options

Statement: a vertex list *A* is an antichain when its elements are events of *g*, no event is repeated, and for any two distinct *u*, *v* in *A* neither *u* ≼ *v* nor *v* ≼ *u*: no directed path of *g* joins them. The empty list and every single event are antichains.

An antichain is the discrete form of an achronal set, events no signal can connect. It is the opposite of a chain ([InfraChainQ]()): a chain and an antichain share at most one event. Every slice of the universal foliation is an antichain ([InfraSliceQ]() implies it), and so is every subset of an antichain.

The width of an order, the size of its largest antichain, equals by Dilworth's theorem the least number of chains that cover the events, and is the number of events minus a maximum matching of the comparability relation (Fulkerson). A sprinkling of *N* events into a causal diamond of 1 + 1 Minkowski space is a random two-dimensional order, whose width, like its longest chain, grows like 2√*N* (Ulam's problem).

## Basic Examples

On each substrate: the slice at height 3, a two-event chain, and the empty list.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {e = First @ EdgeList[g]},
    {InfraAntichainQ[g, RandomInfraSlice[g, 3]], InfraAntichainQ[g, List @@ e], InfraAntichainQ[g, {}]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

An antichain need not lie in one slice: two events of the sprinkling at heights 1 and 3 that no signal joins, drawn with their causal futures, neither of which contains the other event.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {pair = (SeedRandom[3]; RandomChoice @ Select[Tuples[{RandomInfraSlice[g, 1], RandomInfraSlice[g, 3]}], p |-> InfraAntichainQ[g, p]])},
  Labeled[
    InfraSubstrateHighlight[g, {InfraCausalFuture[First @ pair] -> Red, InfraCausalFuture[Last @ pair] -> StandardBlue, pair -> StandardMagenta}],
    InfraAntichainQ[g, pair]]]
```

A repeated event makes the list fail.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {InfraAntichainQ[g, {{0, 2}, {3, 2}}], InfraAntichainQ[g, {{0, 2}, {3, 2}, {0, 2}}]}]
```

## Properties and Relations

The predicate is pairwise incomparability, checked on every set of at most three events of the sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {comparableQ = {u, v} |-> MemberQ[VertexOutComponent[g, {u}], v] || MemberQ[VertexOutComponent[g, {v}], u]},
  AllTrue[Subsets[VertexList[g], {1, 3}], set |-> InfraAntichainQ[g, set] === NoneTrue[Subsets[set, {2}], Apply[comparableQ]]]]
```

Every slice of the universal foliation is an antichain, every edge is not, and a subset of an antichain is an antichain.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[UniversalFoliation[g], s |-> InfraAntichainQ[g, s] && AllTrue[Subsets[s, {0, 2}], sub |-> InfraAntichainQ[g, sub]]] &&
      NoneTrue[EdgeList[g], e |-> InfraAntichainQ[g, List @@ e]]]]
```

A chain and an antichain share at most one event.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    AllTrue[UniversalFoliation[g], s |-> Length[Intersection[a, s]] <= 1]]]
```

The widest slice is at most the width of the order, the number of events minus a maximum matching of the comparability relation. On the two lattices the widest slice attains it.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {width = VertexCount[g] - Length @ FindIndependentEdgeSet @ Graph[UndirectedEdge[{1, First @ #}, {2, Last @ #}] & /@ EdgeList @ TransitiveClosureGraph[g]]},
    {widest = Max[Length /@ UniversalFoliation[g]]},
    widest <= width && (name === "MinkowskiSprinkling2D" || widest == width)]]
```
