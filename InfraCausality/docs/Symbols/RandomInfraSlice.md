---
Template: Symbol
Name: RandomInfraSlice
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraSlice
Keywords: [slice, band, universal time, antichain, sampler, support, count contract]
SeeAlso: [InfraSlice, InfraSliceQ, UniversalTime, UniversalFoliation, InfraAntichainQ, RandomInfraCausalPast]
RelatedGuides: [CausalTime]
---

## Usage

<code>[RandomInfraSlice]()[*g*, [InfraSlice]()[*k*]]</code> gives the slice of universal time *k* on *g* as a sorted vertex list.

<code>[RandomInfraSlice]()[*g*, [InfraSlice]()[{*k1*, *k2*}]]</code> gives the band of the slices from height *k1* to height *k2*.

<code>[RandomInfraSlice]()[*g*, *slice*, *n*]</code> gives a `List` of *n* distinct members, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every member.

<code>[RandomInfraSlice]()[*g*, *k*]</code> and <code>[RandomInfraSlice]()[*g*, {*k1*, *k2*}]</code> are the shortcuts for the head.

## Details & Options

Definition: a slice denotes one vertex set, its support {*v* : *t*(*v*) = *k*}, or {*v* : *k1* ≤ *t*(*v*) ≤ *k2*} for a band, where *t* is [UniversalTime](). The sampler returns that support as a sorted vertex list.

The count contract is the one every `RandomInfra…` sampler shares. With a single member it reads:

| Count | Result |
|---|---|
| omitted or `Automatic` | the sorted support itself |
| `All` | `{support}`, the list of every member |
| 1 | `{support}` |
| 0 or *n* ≥ 2 | `{}`: a strict count asks for *n* distinct members and there is only one |
| `UpTo[n]`, *n* ≥ 1 | `{support}` |

A height above the longest chain, or below zero, has the empty slice: the count-less call gives `{}` and `All` gives `{{}}`.

The draw involves no randomness. The option `"NextVertexFunction"` is accepted with the values of the chain samplers and changes nothing here; `"NextVertexFunction" -> RandomChoice` together with `All` stays unevaluated.

[InfraSliceQ]() recognises the output of a single slice, and every output is an antichain when the band is a single slice.

## Basic Examples

The slice at height 3 on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
Table[
  RandomInfraSlice[CausalSubstrate[name, "Small"], InfraSlice[3]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The band from height 2 to height 4 of the sprinkling, drawn with a random event of the slice at height 3 and its causal past.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, 3])},
  InfraSubstrateHighlight[g, {RandomInfraSlice[g, {2, 4}] -> StandardGreen, InfraCausalPast[v] -> StandardBlue, v}]]
```

The count contract on the cylinder lattice: the support, the list of every member, a strict count of two and the empty slice above the top.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {RandomInfraSlice[g, 2, All], RandomInfraSlice[g, 2, 2], RandomInfraSlice[g, 99], RandomInfraSlice[g, 99, All]}]
```

## Properties and Relations

The slices of all heights are the universal foliation, and each passes [InfraSliceQ]() and [InfraAntichainQ]().

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {slices = Table[RandomInfraSlice[g, InfraSlice[k]], {k, 0, Max @ UniversalTime[g]}]},
    slices === UniversalFoliation[g] && AllTrue[slices, s |-> InfraSliceQ[g, s] && InfraAntichainQ[g, s]]]]
```

The support is the key set of the vertex density, its only member: [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) accepts it in any order and the cardinality is 1.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[0, Max @ UniversalTime[g]], k |->
      RandomInfraSlice[g, InfraSlice[k]] === Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"] &&
        InfraMemberQ[g, InfraSlice[k], Reverse @ RandomInfraSlice[g, InfraSlice[k]]] &&
        InfraMeasurement[g, InfraSlice[k], "Cardinality"] == 1]]]
```

A band is the union of its slices.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Subsets[Range[0, Max @ UniversalTime[g]], {2}], Apply[{k1, k2} |->
      RandomInfraSlice[g, {k1, k2}] === Union @@ Table[RandomInfraSlice[g, k], {k, k1, k2}]]]]]
```

The causal past of a slice lies in the band below it, and on the two lattices it is the whole band: every event below the slice can signal it.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[0, Max @ UniversalTime[g]], k |->
      SubsetQ[RandomInfraSlice[g, {0, k}], RandomInfraCausalPast[g, RandomInfraSlice[g, k]]] &&
        (name === "MinkowskiSprinkling2D" || RandomInfraSlice[g, {0, k}] === RandomInfraCausalPast[g, RandomInfraSlice[g, k]])]]]
```

In general the band below a slice is its causal past exactly when every event of the band can signal some event of the slice. On the sprinkling this fails at five of the eight heights.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[0, Max @ UniversalTime[g]], k |->
      (RandomInfraSlice[g, {0, k}] === RandomInfraCausalPast[g, RandomInfraSlice[g, k]]) ===
        AllTrue[RandomInfraSlice[g, {0, k}], e |-> IntersectingQ[VertexOutComponent[g, {e}], RandomInfraSlice[g, k]]]]]]
```
