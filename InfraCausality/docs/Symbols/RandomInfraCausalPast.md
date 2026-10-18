---
Template: Symbol
Name: RandomInfraCausalPast
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraCausalPast
Keywords: [causal past, past cone, J-, down-set, sampler, support, count contract]
SeeAlso: [InfraCausalPast, InfraCausalPastQ, RandomInfraCausalFuture, RandomInfraCausalDiamond, RandomInfraSlice, InfraMeasurement, InfraMemberQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraCausalPast]()[*g*, [InfraCausalPast]()[*v*]]</code> gives the causal past of *v* on *g* as a sorted vertex list.

<code>[RandomInfraCausalPast]()[*g*, [InfraCausalPast]()[*v*], *n*]</code> gives a `List` of *n* distinct members, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every member.

<code>[RandomInfraCausalPast]()[*g*, *v*]</code> and <code>[RandomInfraCausalPast]()[*g*, *v*, *n*]</code> are the shortcuts for <code>[InfraCausalPast]()[*v*]</code>.

## Details & Options

Definition: a causal past denotes one vertex set, its support *J*⁻(*v*) = {*e* : *e* ≼ *v*}, the events from which *v* can be reached, *v* included. The sampler returns that support as a sorted vertex list, the keys of <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalPast]()[*v*], "VertexDensity"]</code>.

The count contract is the one every `RandomInfra…` sampler shares. With a single member it reads:

| Count | Result |
|---|---|
| omitted or `Automatic` | the sorted support itself |
| `All` | `{support}`, the list of every member |
| 1 | `{support}` |
| 0 or *n* ≥ 2 | `{}`: a strict count asks for *n* distinct members and there is only one |
| `UpTo[n]`, *n* ≥ 1 | `{support}` |

The draw involves no randomness. The option `"NextVertexFunction"` is accepted with the values of the chain samplers and changes nothing here; `"NextVertexFunction" -> RandomChoice` together with `All` stays unevaluated.

The anchor may be an event, a set of events, whose causal past is the union of theirs, or a chain. The cut <code>[InfraCausalPast]()[*v*, *t*]</code> keeps the events of *J*⁻(*v*) from which *v* is reached within proper time *t*. The past is the future of the time-reversed graph: <code>[RandomInfraCausalPast]()[*g*, *v*]</code> is <code>[RandomInfraCausalFuture]()[`ReverseGraph`[*g*], *v*]</code>.

[InfraCausalPastQ]() recognises the output.

## Basic Examples

The causal past of an event at height 4, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[4]])},
    InfraSubstrateHighlight[g, {RandomInfraCausalPast[g, InfraCausalPast[v]], v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The causal past of the event {1, 2} of the diamond lattice is the 2 × 3 rectangle below it.

```wl
RandomInfraCausalPast[CausalSubstrate["DiamondLatticeGraph", "Small"], {1, 2}]
```

A count gives a list of members; a strict count above one gives the empty list.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {RandomInfraCausalPast[g, {1, 1}, All], RandomInfraCausalPast[g, {1, 1}, 3]}]
```

The proper-time cuts of the causal past of the top event of the sprinkling, at *t* = 1, 3 and 5.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[Max @ UniversalTime @ g]])},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {RandomInfraCausalPast[g, InfraCausalPast[v, t]], v}], {t, {1, 3, 5}}]]
```

## Properties and Relations

The support is the in-component of the event, it passes [InfraCausalPastQ](), and its size is the causal volume of the head.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      With[{past = RandomInfraCausalPast[g, InfraCausalPast[v]]},
        past === Sort[VertexInComponent[g, {v}]] && InfraCausalPastQ[g, past] &&
          Length[past] == InfraMeasurement[g, InfraCausalPast[v], "CountingMeasure"]]]]]
```

The causal past on a graph is the causal future on the reversed graph, cut for cut.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      AllTrue[Range[0, 3], t |->
        RandomInfraCausalPast[g, InfraCausalPast[v, t]] === RandomInfraCausalFuture[ReverseGraph[g], InfraCausalFuture[v, t]]]]]]
```

An event *u* lies in the causal past of *v* exactly when *v* lies in the causal future of *u*.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Tuples[VertexList[g], 2], Apply[{u, v} |->
      MemberQ[RandomInfraCausalPast[g, v], u] === MemberQ[RandomInfraCausalFuture[g, u], v]]]]]
```
