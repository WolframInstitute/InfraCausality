---
Template: Symbol
Name: RandomInfraCausalFuture
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraCausalFuture
Keywords: [causal future, future cone, J+, up-set, sampler, support, count contract]
SeeAlso: [InfraCausalFuture, InfraCausalFutureQ, RandomInfraCausalPast, RandomInfraCausalDiamond, RandomInfraSlice, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraCausalFuture]()[*g*, [InfraCausalFuture]()[*v*]]</code> gives the causal future of *v* on *g* as a sorted vertex list.

<code>[RandomInfraCausalFuture]()[*g*, [InfraCausalFuture]()[*v*], *n*]</code> gives a `List` of *n* distinct members, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every member.

<code>[RandomInfraCausalFuture]()[*g*, *v*]</code> and <code>[RandomInfraCausalFuture]()[*g*, *v*, *n*]</code> are the shortcuts for <code>[InfraCausalFuture]()[*v*]</code>.

## Details & Options

Definition: the members of a set head are the vertex sets it denotes, and a causal future denotes one set, its support *J*⁺(*v*) = {*e* : *v* ≼ *e*}. The sampler returns that support as a sorted vertex list, the keys of <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalFuture]()[*v*], "VertexDensity"]</code>.

The count contract is the one every `RandomInfra…` sampler shares. With a single member it reads:

| Count | Result |
|---|---|
| omitted or `Automatic` | the sorted support itself |
| `All` | `{support}`, the list of every member |
| 1 | `{support}` |
| 0 or *n* ≥ 2 | `{}`: a strict count asks for *n* distinct members and there is only one |
| `UpTo[n]`, *n* ≥ 1 | `{support}` |

The draw involves no randomness, since there is nothing to choose; the sampler exists so that the set heads and the chain heads are drawn through the same interface. The option `"NextVertexFunction"` is accepted with the values of the chain samplers ([RandomInfraWorldline]()) and changes nothing here; `"NextVertexFunction" -> RandomChoice` together with `All` stays unevaluated, as it does for the chain samplers.

The anchor is read through [`InfraDensity`](paclet:WolframInstitute/InfraGeometry/ref/InfraDensity), so <code>[InfraCausalFuture]()[{*v1*, *v2*, …}]</code> gives the union of the causal futures, and the proper-time cut <code>[InfraCausalFuture]()[*v*, *t*]</code> gives the events of *J*⁺(*v*) within proper time *t*. The shortcut <code>[RandomInfraCausalFuture]()[*g*, *v*, …]</code> wraps any anchor that is not a head in <code>[InfraCausalFuture]()[*v*]</code>.

[InfraCausalFutureQ]() recognises the output, and <code>[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ)[*g*, [InfraCausalFuture]()[*v*], *set*]</code> tests whether a vertex set is the member.

## Basic Examples

The causal future of an event at height 3, drawn from the sorted vertex list the sampler returns, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[3]])},
    InfraSubstrateHighlight[g, {RandomInfraCausalFuture[g, InfraCausalFuture[v]], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The causal future of the event {4, 4} of the diamond lattice is the 3 × 3 square above it.

```wl
RandomInfraCausalFuture[CausalSubstrate["DiamondLatticeGraph", "Small"], {4, 4}]
```

A count gives a list of members. There is one member, so a strict count of 2 gives the empty list.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {RandomInfraCausalFuture[g, {5, 5}, 1], RandomInfraCausalFuture[g, {5, 5}, 2], RandomInfraCausalFuture[g, {5, 5}, UpTo[2]]}]
```

A set anchor and a proper-time cut on the cylinder lattice.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {s = (SeedRandom[2]; RandomSample[RandomInfraSlice[g, InfraSlice[2]], 2])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {RandomInfraCausalFuture[g, InfraCausalFuture[s]], InfraWalk[{First @ s}], InfraWalk[{Last @ s}]}],
    InfraSubstrateHighlight[g, {RandomInfraCausalFuture[g, InfraCausalFuture[First @ s, 2]], First @ s}]}]]
```

## Properties and Relations

The support is the out-component of the event, it passes [InfraCausalFutureQ](), and it is the member that [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) recognises.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{future = RandomInfraCausalFuture[g, InfraCausalFuture[v]]},
        future === Sort[VertexOutComponent[g, {v}]] && InfraCausalFutureQ[g, future] &&
          InfraMemberQ[g, InfraCausalFuture[v], future]]]]]
```

The number of events of the support is the causal volume, the `"CountingMeasure"` of the head, and `All` has `"Cardinality"` members.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      Length[RandomInfraCausalFuture[g, v]] == InfraMeasurement[g, InfraCausalFuture[v], "CountingMeasure"] &&
        Length[RandomInfraCausalFuture[g, v, All]] == InfraMeasurement[g, InfraCausalFuture[v], "Cardinality"]]]]
```

The causal future of a set of events is the union of their causal futures.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {s = (SeedRandom[3]; RandomSample[RandomInfraSlice[g, InfraSlice[2]], 2])},
    RandomInfraCausalFuture[g, InfraCausalFuture[s]] === Union[RandomInfraCausalFuture[g, First @ s], RandomInfraCausalFuture[g, Last @ s]]]]
```

The proper-time cuts grow with *t* and reach the whole causal future at the height of the future.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {height = Max @ UniversalTime @ InfraMeasurement[g, InfraCausalFuture[v], "Subgraph"]},
    {cuts = Table[RandomInfraCausalFuture[g, InfraCausalFuture[v, t]], {t, 0, height}]},
    AllTrue[Partition[cuts, 2, 1], Apply[SubsetQ[#2, #1] &]] && Last[cuts] === RandomInfraCausalFuture[g, v]]]
```
