---
Template: Symbol
Name: RandomInfraEchoFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraEchoFunction
Keywords: [echo function, radar, composition, message function, sampler, count contract, EPS axioms, axiom D1]
SeeAlso: [InfraEchoFunction, InfraEchoFunctionQ, RandomInfraMessageFunction, InfraMessageFunction, InfraRadarCoordinates]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[RandomInfraEchoFunction]()[*g*, [InfraEchoFunction]()[*a*, *b*]]</code> gives a random echo function of *a* via *b*, an association, drawn uniformly from the distinct echo functions.

<code>[RandomInfraEchoFunction]()[*g*, [InfraEchoFunction]()[*a*, *b*], *n*]</code> gives a `List` of *n* distinct echo functions, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every one.

## Details & Options

Definition: the members of <code>[InfraEchoFunction]()[*a*, *b*]</code> are the distinct compositions *f*<sub>*ba*</sub> ∘ *f*<sub>*ab*</sub> of a message function from *a* to *b* with a message function from *b* to *a* ([InfraEchoFunctionQ]()). Different pairs of message functions can compose to the same echo function, so the members are counted after removing duplicates; the `"Cardinality"` of the head is their number, at most the product of the numbers of message functions each way.

The sampler enumerates the compositions, since the distinct composites carry no path count of their own, and draws from them uniformly. The count contract and the option are those of [RandomInfraMessageFunction]():

| Count | Result |
|---|---|
| omitted or `Automatic` | one member, an association; the empty association when no signal returns |
| `All` | every member, in no particular order |
| *n* | *n* distinct members, or `{}` when there are fewer than *n* |
| `UpTo[n]` | min(*n*, number of members) distinct members |

| `"NextVertexFunction"` | Effect |
|---|---|
| `Automatic` | uniform draws from the distinct members |
| `Identity` | the first members in the sorted order of their images |
| `RandomSample` | a random order of the members; `All` still enumerates |
| `RandomChoice` | compositions of two random walks, one through each selection graph, not uniform; not with `All`, which stays unevaluated |

The enumeration grows with the product of the message cardinalities; on the staircases of the Small diamond lattice it gives 699 members out of 81 × 81 pairs.

## Basic Examples

A random echo function of an observer *a* (blue) via an observer *b* (green): the ticks of *a* that send (red) and the ticks they receive the echo at (purple), on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {f = (SeedRandom[1]; RandomChoice @ Select[RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], e |-> e =!= <||>])},
    InfraSubstrateHighlight[g, {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardGreen, Keys[f] -> Red, Values[f] -> StandardPurple}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Every echo function of the sprinkling observers.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  Normal /@ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]]
```

The number of echo functions on each substrate beside the numbers of message functions there and back.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {Length @ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All],
     InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"], InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The echo times of the lattice observer *a*: for each tick, the positions on *a* at which its echoes return over all echo functions.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {position = AssociationThread[a, Range @ Length[a]]},
  KeyMap[position, Union /@ Merge[Map[position, RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], {2}], Identity]]]
```

## Options

### NextVertexFunction

With `Identity` the members come in the sorted order of their images, and the strict count of the whole cardinality enumerates them.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {card = InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"]},
  RandomInfraEchoFunction[g, InfraEchoFunction[a, b], card, "NextVertexFunction" -> Identity] ===
    SortBy[RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], Values]]
```

With `RandomChoice` each draw composes a random walk through the selection graph from *a* to *b* with one through the selection graph back; the draws are distinct members, but not uniform.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {walks = (SeedRandom[2]; RandomInfraEchoFunction[g, InfraEchoFunction[a, b], 3, "NextVertexFunction" -> RandomChoice])},
  DuplicateFreeQ[walks] && AllTrue[walks, f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]]]
```

## Properties and Relations

`All` gives the distinct compositions of two message functions, as many as the `"Cardinality"` of the head; [InfraEchoFunctionQ]() recognises each of them.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {members = RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]},
    {compositions = DeleteDuplicates @ Catenate @ Outer[
      {s, t} |-> KeySort @ DeleteMissing[Lookup[t, Key[#]] & /@ s],
      RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All], RandomInfraMessageFunction[g, InfraMessageFunction[b, a], All], 1]},
    DuplicateFreeQ[members] && Length[members] == InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"] &&
      Sort[KeySort /@ members] === Sort[compositions]]]
```

The cardinality is at most the product of the message cardinalities, and an echo always returns strictly later on *a*, to a tick of the echo relation.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {relation = InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"], position = AssociationThread[a, Range @ Length[a]]},
    InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"] <=
      InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"] &&
      AllTrue[RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], f |->
        AllTrue[Keys[f], v |-> MemberQ[relation[v], f[v]] && position[f[v]] > position[v]]]]]
```

The count contract: a strict count above the cardinality gives `{}`, `UpTo` caps at the cardinality, and a single draw is a member.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {head = InfraEchoFunction[a, b]},
    {card = InfraMeasurement[g, head, "Cardinality"]},
    RandomInfraEchoFunction[g, head, card + 1] === {} && Length[RandomInfraEchoFunction[g, head, UpTo[card + 5]]] == card &&
      MemberQ[RandomInfraEchoFunction[g, head, All], (SeedRandom[4]; RandomInfraEchoFunction[g, head])]]]
```
