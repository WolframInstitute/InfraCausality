---
Template: Symbol
Name: InfraCausalPastQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalPastQ
Keywords: [causal past, down-set, greatest element, predicate]
SeeAlso: [InfraCausalPast, RandomInfraCausalPast, InfraCausalFutureQ, InfraCausalDiamondQ, InfraChainQ, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalPastQ]()[*g*, *set*]</code> gives `True` if the vertex list *set* is the causal past *J*⁻(*v*) on *g* of one of its events *v*.

<code>[InfraCausalPastQ]()[*g*, {*set1*, *set2*, …}]</code> tests every set in the list.

<code>[InfraCausalPastQ]()[*g*, *density*]</code> tests the keys of a density association.

## Details & Options

Statement: a vertex list *S* is a causal past when it is nonempty, its elements are events of *g*, and *S* = *J*⁻(*v*) = {*e* : *e* ≼ *v*} for some *v* in *S*. Order and repetition in the list do not matter.

Such a *v* is the greatest element of *S*, and it is unique. So the predicate says that *S* is a down-set, closed under passing to the past, with a greatest element; the causal past of two incomparable events fails.

The predicate is the time reverse of [InfraCausalFutureQ](): <code>[InfraCausalPastQ]()[*g*, *S*]</code> equals <code>[InfraCausalFutureQ]()[`ReverseGraph`[*g*], *S*]</code>. It takes a set, never an object; <code>[InfraCausalPastQ]()[*g*, [InfraCausalPast]()[*v*]]</code> stays unevaluated.

A set that is both a causal past and a causal future, *J*⁻(*q*) = *J*⁺(*p*), is the causal diamond [*p*, *q*] and passes [InfraCausalDiamondQ]().

## Basic Examples

On each substrate: the causal past of an event, the causal past of two incomparable events, and a proper-time cut.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {s = (SeedRandom[1]; RandomSample[RandomInfraSlice[g, InfraSlice[4]], 2])},
    {InfraCausalPastQ[g, RandomInfraCausalPast[g, First @ s]],
     InfraCausalPastQ[g, RandomInfraCausalPast[g, InfraCausalPast[s]]],
     InfraCausalPastQ[g, RandomInfraCausalPast[g, InfraCausalPast[First @ s, 1]]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The causal past of two events of the cylinder lattice has two maximal events and fails; the past of each one passes.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {s = (SeedRandom[1]; RandomSample[RandomInfraSlice[g, InfraSlice[4]], 2])},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {set}], InfraCausalPastQ[g, set]],
    {set, {RandomInfraCausalPast[g, First @ s], RandomInfraCausalPast[g, Last @ s], RandomInfraCausalPast[g, InfraCausalPast[s]]}}]]
```

## Properties and Relations

The causal past of every event passes, and the event is the unique greatest element of the set.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{past = RandomInfraCausalPast[g, v]},
        InfraCausalPastQ[g, past] &&
          Select[past, e |-> SubsetQ[VertexInComponent[g, {e}], past]] === {v}]]]]
```

The predicate on a graph is the future predicate on the reversed graph.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sets = Join[RandomInfraCausalFuture[g, #] & /@ VertexList[g], RandomInfraCausalPast[g, #] & /@ VertexList[g]]},
    AllTrue[sets, set |-> InfraCausalPastQ[g, set] === InfraCausalFutureQ[ReverseGraph[g], set]]]]
```

A set that passes is a down-set: every in-neighbour of one of its events is one of its events.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sets = Join[RandomInfraCausalFuture[g, #] & /@ VertexList[g], RandomInfraCausalPast[g, #] & /@ VertexList[g]]},
    AllTrue[Select[sets, InfraCausalPastQ[g, #] &], set |->
      SubsetQ[set, Union @@ (VertexInComponent[g, #, {1}] & /@ set)]]]]
```
