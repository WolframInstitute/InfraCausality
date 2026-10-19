---
Template: Symbol
Name: RandomInfraCausalDiamond
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraCausalDiamond
Keywords: [causal diamond, Alexandrov interval, causal interval, causal hull, sampler, support, count contract]
SeeAlso: [InfraCausalDiamond, InfraCausalDiamondQ, RandomInfraCausalFuture, RandomInfraCausalPast, RandomInfraWorldline, InfraMeasurement]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[RandomInfraCausalDiamond]()[*g*, [InfraCausalDiamond]()[*p*, *q*]]</code> gives the causal diamond of *p* and *q* on *g* as a sorted vertex list.

<code>[RandomInfraCausalDiamond]()[*g*, [InfraCausalDiamond]()[*p*, *q*], *n*]</code> gives a `List` of *n* distinct members, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every member.

<code>[RandomInfraCausalDiamond]()[*g*, *p*, *q*]</code> and <code>[RandomInfraCausalDiamond]()[*g*, *p*, *q*, *n*]</code> are the shortcuts for <code>[InfraCausalDiamond]()[*p*, *q*]</code>.

## Details & Options

Definition: a causal diamond denotes one vertex set, its support [*p*, *q*] = *J*⁺(*p*) ∩ *J*⁻(*q*), the events that lie between *p* and *q*. The sampler returns that support as a sorted vertex list. For the hull <code>[InfraCausalDiamond]()[*S*]</code> of a set *S* the support is *J*⁺(*S*) ∩ *J*⁻(*S*), the events that lie between two events of *S*.

The count contract is the one every `RandomInfra…` sampler shares. With a single member it reads:

| Count | Result |
|---|---|
| omitted or `Automatic` | the sorted support itself |
| `All` | `{support}`, the list of every member |
| 1 | `{support}` |
| 0 or *n* ≥ 2 | `{}`: a strict count asks for *n* distinct members and there is only one |
| `UpTo[n]`, *n* ≥ 1 | `{support}` |

When *q* does not follow *p* the diamond is empty: its member is the empty set, so the count-less call gives `{}` and `All` gives `{{}}`.

The draw involves no randomness. The option `"NextVertexFunction"` is accepted with the values of the chain samplers and changes nothing here; `"NextVertexFunction" -> RandomChoice` together with `All` stays unevaluated.

[InfraCausalDiamondQ]() recognises the output.

## Basic Examples

The causal diamond between an event at height 1 and an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[Max[UniversalTime[g]] - 1]]])},
    InfraSubstrateHighlight[g, {RandomInfraCausalDiamond[g, InfraCausalDiamond[p, q]], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice the diamond of {1, 2} and {3, 3} is a 3 × 2 rectangle.

```wl
RandomInfraCausalDiamond[CausalSubstrate["DiamondLatticeGraph", "Small"], {1, 2}, {3, 3}]
```

The diamond of an event and an event that does not follow it is empty.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {RandomInfraCausalDiamond[g, {3, 3}, {1, 2}], RandomInfraCausalDiamond[g, {3, 3}, {1, 2}, All]}]
```

The causal hull of two incomparable events of the cylinder lattice is the pair itself; the hull of the pair and an event of their common future is the union of two diamonds.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {s = (SeedRandom[2]; RandomSample[RandomInfraSlice[g, InfraSlice[1]], 2])},
  {top = (SeedRandom[2]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, First @ s], RandomInfraCausalFuture[g, Last @ s]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {RandomInfraCausalDiamond[g, InfraCausalDiamond[s]]}],
    InfraSubstrateHighlight[g, {RandomInfraCausalDiamond[g, InfraCausalDiamond[Append[s, top]]], top}]}]]
```

## Properties and Relations

The diamond is the intersection of the causal future of *p* and the causal past of *q*, and it passes [InfraCausalDiamondQ]() whenever it is nonempty.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    AllTrue[VertexList[g], q |->
      With[{diamond = RandomInfraCausalDiamond[g, p, q]},
        diamond === Intersection[RandomInfraCausalFuture[g, p], RandomInfraCausalPast[g, q]] &&
          (diamond === {} || InfraCausalDiamondQ[g, diamond])]]]]
```

A diamond is convex: the diamond of any two of its events lies inside it, and so does every worldline between them.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomChoice @ Intersection[RandomInfraCausalFuture[g, p], RandomInfraSlice[g, InfraSlice[5]]])},
    {diamond = RandomInfraCausalDiamond[g, p, q]},
    AllTrue[Tuples[diamond, 2], Apply[{x, y} |->
      SubsetQ[diamond, RandomInfraCausalDiamond[g, x, y]] &&
        SubsetQ[diamond, Union @@ RandomInfraWorldline[g, InfraWorldline[x, y], All]]]]]]
```

On the diamond lattice the diamond of {*i*, *j*} and {*k*, *l*} with *i* ≤ *k* and *j* ≤ *l* has (*k* − *i* + 1)(*l* − *j* + 1) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> And @@ Thread[p <= q]]], Apply[{p, q} |->
    Length[RandomInfraCausalDiamond[g, p, q]] == Times @@ (q - p + 1)]]]
```

The hull of a comparable pair is its diamond, and the hull of a diamond is the diamond.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[1]])},
    AllTrue[RandomInfraCausalFuture[g, p], q |->
      RandomInfraCausalDiamond[g, InfraCausalDiamond[{p, q}]] === RandomInfraCausalDiamond[g, p, q] ===
        RandomInfraCausalDiamond[g, InfraCausalDiamond[RandomInfraCausalDiamond[g, p, q]]]]]]
```
