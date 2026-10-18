---
Template: Symbol
Name: RandomInfraEchoFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraEchoFunction
Keywords: [echo function, radar, composition, message function, sampler, count contract, EPS axioms, experimental]
SeeAlso: [InfraEchoFunction, InfraEchoFunctionQ, RandomInfraMessageFunction, InfraMessageFunction, InfraRadarCoordinates]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[RandomInfraEchoFunction]()[*g*, [InfraEchoFunction]()[*a*, *b*]]</code> gives a random echo function of *a* via *b*, an association, drawn uniformly from the distinct echo functions.

<code>[RandomInfraEchoFunction]()[*g*, [InfraEchoFunction]()[*a*, *b*], *n*]</code> gives a `List` of *n* distinct echo functions, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every one.

## Details & Options

Experimental: selections.

Definition: the members of <code>[InfraEchoFunction]()[*a*, *b*]</code> are the distinct compositions *f*<sub>*ba*</sub> ∘ *f*<sub>*ab*</sub> of a message function from *a* to *b* with a message function from *b* to *a* ([InfraEchoFunctionQ]()). Different pairs of message functions can compose to the same echo function, so the members are counted after removing duplicates; the `"Cardinality"` of the head is their number, at most the product of the numbers of message functions each way.

The sampler enumerates the compositions and draws from the distinct ones uniformly:

| Count | Result |
|---|---|
| omitted or `Automatic` | one member, an association; `{}` when there is none |
| `All` | every member |
| *n* | *n* distinct members, or `{}` when there are fewer than *n* |
| `UpTo[n]` | min(*n*, number of members) distinct members |

The enumeration grows with the product of the message cardinalities; on the staircases of the Small diamond lattice it gives 699 members out of 81 × 81 pairs. The sampler takes no `"NextVertexFunction"`.

## Basic Examples

A random echo function of an observer *a* (blue) via an observer *b* (red): the ticks of *a* that send (orange) and the ticks they receive the echo at (purple), on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {f = (SeedRandom[1]; RandomChoice @ Select[RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], e |-> e =!= <||>])},
    InfraSubstrateHighlight[g, {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed, Keys[f] -> StandardOrange, Values[f] -> StandardPurple}]],
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
