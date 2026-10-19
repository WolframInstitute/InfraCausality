---
Template: Symbol
Name: InfraCausalFutureQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalFutureQ
Keywords: [causal future, up-set, least element, predicate]
SeeAlso: [InfraCausalFuture, RandomInfraCausalFuture, InfraCausalPastQ, InfraCausalDiamondQ, InfraChainQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalFutureQ]()[*g*, *set*]</code> gives `True` if the vertex list *set* is the causal future *J*⁺(*v*) on *g* of one of its events *v*.

<code>[InfraCausalFutureQ]()[*g*, {*set1*, *set2*, …}]</code> tests every set in the list.

<code>[InfraCausalFutureQ]()[*g*, *density*]</code> tests the keys of a density association.

## Details & Options

Statement: a vertex list *S* is a causal future when it is nonempty, its elements are events of *g*, and *S* = *J*⁺(*v*) = {*e* : *v* ≼ *e*} for some *v* in *S*. Order and repetition in the list do not matter.

Such a *v* is unique: it is the least element of *S*, since every event of *J*⁺(*v*) follows it, and two events with the same causal future precede each other and coincide. So the predicate says that *S* is an up-set, closed under passing to the future, with a least element; an up-set with two minimal events, such as the causal future of a pair of incomparable events, fails.

The predicate takes a set, never an object: <code>[InfraCausalFutureQ]()[*g*, [InfraCausalFuture]()[*v*]]</code> stays unevaluated. Test the support, <code>[RandomInfraCausalFuture]()[*g*, *v*]</code>, or ask <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)</code> whether a set is the causal future of one particular event.

The set predicates of the guide form a small hierarchy. A set that is both a causal future and a causal past, *J*⁺(*p*) = *J*⁻(*q*), is the causal diamond [*p*, *q*] and passes [InfraCausalDiamondQ](); a single event passes all three. A proper-time cut <code>[InfraCausalFuture]()[*v*, *t*]</code> below the height of the future is not an up-set and fails.

## Basic Examples

On each substrate: the causal future of an event, the causal future of two incomparable events, and the proper-time cut at *t* = 2 of the causal future of an event at height 1.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {s = (SeedRandom[1]; RandomSample[RandomInfraSlice[g, InfraSlice[2]], 2])},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {InfraCausalFutureQ[g, RandomInfraCausalFuture[g, First @ s]],
     InfraCausalFutureQ[g, RandomInfraCausalFuture[g, InfraCausalFuture[s]]],
     InfraCausalFutureQ[g, RandomInfraCausalFuture[g, InfraCausalFuture[v, 2]]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The same three sets on the diamond lattice, labelled with the answer.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {s = (SeedRandom[1]; RandomSample[RandomInfraSlice[g, InfraSlice[2]], 2])},
  {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {set}], InfraCausalFutureQ[g, set]],
    {set, {RandomInfraCausalFuture[g, First @ s], RandomInfraCausalFuture[g, InfraCausalFuture[s]], RandomInfraCausalFuture[g, InfraCausalFuture[v, 2]]}}]]
```

A list of sets is tested set by set, and a density by its keys.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {InfraCausalFutureQ[g, RandomInfraCausalFuture[g, #] & /@ {2, 3, 4}],
   InfraCausalFutureQ[g, InfraMeasurement[g, InfraCausalFuture[5], "VertexDensity"]]}]
```

## Properties and Relations

The causal future of every event passes, and the event is the unique least element of the set.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{future = RandomInfraCausalFuture[g, v]},
        InfraCausalFutureQ[g, future] &&
          Select[future, e |-> SubsetQ[VertexOutComponent[g, {e}], future]] === {v}]]]]
```

A set that passes is an up-set: every out-neighbour of one of its events is one of its events.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sets = Join[RandomInfraCausalFuture[g, #] & /@ VertexList[g], RandomInfraCausalPast[g, #] & /@ VertexList[g]]},
    AllTrue[Select[sets, InfraCausalFutureQ[g, #] &], set |->
      SubsetQ[set, Union @@ (VertexOutComponent[g, #, {1}] & /@ set)]]]]
```

A set that is both a causal future and a causal past is a causal diamond.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sets = Join[RandomInfraCausalFuture[g, #] & /@ VertexList[g], RandomInfraCausalPast[g, #] & /@ VertexList[g]]},
    AllTrue[Select[sets, InfraCausalFutureQ[g, #] && InfraCausalPastQ[g, #] &], InfraCausalDiamondQ[g, #] &]]]
```

The proper-time cuts of the causal future of an event pass only at and above the height of the future.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {height = Max @ UniversalTime @ InfraMeasurement[g, InfraCausalFuture[v], "Subgraph"]},
    Table[InfraCausalFutureQ[g, RandomInfraCausalFuture[g, InfraCausalFuture[v, t]]], {t, 0, height}] ===
      Append[ConstantArray[False, height], True]]]
```
