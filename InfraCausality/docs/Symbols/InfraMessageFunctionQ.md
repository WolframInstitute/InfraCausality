---
Template: Symbol
Name: InfraMessageFunctionQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraMessageFunctionQ
Keywords: [message function, monotone selection, EPS axioms, Ehlers-Pirani-Schild, axiom D1, light signal, predicate]
SeeAlso: [InfraMessageFunction, RandomInfraMessageFunction, InfraEchoFunctionQ, EPSMessageAxiomQ, InfraFutureLightCone, InfraWorldlineQ]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[InfraMessageFunctionQ]()[*g*, [InfraMessageFunction]()[*a*, *b*], *f*]</code> gives `True` if the association *f* picks one message image on *b* for every tick of *a* that has one and preserves the order of the ticks.

## Details & Options

Statement: with *M*(*v*) = *E*⁺(*v*) ∩ *b* the message relation of [InfraMessageFunction](), an association *f* is a message function from *a* to *b* when

- its keys are exactly the ticks *v* of *a* with *M*(*v*) ≠ ∅,
- *f*(*v*) ∈ *M*(*v*) for every key, and
- the positions of *f*(*v*) on *b* do not decrease as *v* runs along *a*.

This is the discrete form of the EPS axiom D1: a message function is single-valued on its domain and order-preserving. The order of the keys in *f* does not matter. A partial map, a map to a tick off the light cone and a multivalued map fail. The predicate tests a candidate map against the pair of observers; [EPSMessageAxiomQ]() tests the pair itself, whether the relation is already such a map on every tick.

[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) on the head is this predicate, and the members drawn by [RandomInfraMessageFunction]() all pass. When no tick of *a* reaches *b*, the empty association is the one message function.

The three conditions are independent: the order condition can fail with every image admissible, when the images of two ticks are chosen crosswise.

## Basic Examples

The messages from an observer *a* (blue) to an observer *b* (green) on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice. On each: the earliest images, the latest images, and the earliest images without the first tick.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}]},
    {InfraMessageFunctionQ[g, InfraMessageFunction[a, b], First /@ relation],
     InfraMessageFunctionQ[g, InfraMessageFunction[a, b], Last /@ relation],
     InfraMessageFunctionQ[g, InfraMessageFunction[a, b], Rest[First /@ relation]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A message function of the lattice observers drawn as the light rays from each tick to its image (red).

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {f = (SeedRandom[2]; RandomInfraMessageFunction[g, InfraMessageFunction[a, b]])},
  Labeled[
    InfraSubstrateHighlight[g, Join[
      KeyValueMap[{v, w} |-> InfraMessageFunction[{v}, {w}] -> Red, f],
      {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardGreen}]],
    InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]]]
```

The consecutive ticks {1, 4} and {2, 4} of the lattice observer *a* have the same three images {4, 4}, {5, 4}, {6, 4}. Sent in order they give a message function; sent crosswise they do not, although each image is admissible.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {f = First /@ DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}]},
  {InfraMessageFunctionQ[g, InfraMessageFunction[a, b], Join[f, <|{1, 4} -> {4, 4}, {2, 4} -> {6, 4}|>]],
   InfraMessageFunctionQ[g, InfraMessageFunction[a, b], Join[f, <|{1, 4} -> {6, 4}, {2, 4} -> {4, 4}|>]]}]
```

## Properties and Relations

Among all single-valued selections of the relation, the predicate accepts exactly the monotone ones, which are the members enumerated by [RandomInfraMessageFunction]().

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}], position = AssociationThread[b, Range @ Length[b]]},
    {selections = AssociationThread[Keys @ relation, #] & /@ Tuples[Values @ relation]},
    Sort[Select[selections, f |-> InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]]] ===
      Sort[Select[selections, f |-> LessEqual @@ (position /@ Values[f])]] ===
      Sort[KeySort /@ RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]]]]
```

The number of message functions is the `"Cardinality"` of the head, and [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) agrees with the predicate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}]},
    {selections = AssociationThread[Keys @ relation, #] & /@ Tuples[Values @ relation]},
    Count[selections, f_ /; InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]] == InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] &&
      AllTrue[selections, f |-> InfraMemberQ[g, InfraMessageFunction[a, b], f] === InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]]]]
```

Sending every tick to its earliest image is always a message function: the images of a tick are an initial segment of its causal future on *b*, so the first image moves forward along *b* as the tick does.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[3], seed |->
      With[
        {a = (SeedRandom[seed]; RandomInfraTimelikeGeodesic[g])},
        {b = (SeedRandom[seed]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
        {relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}]},
        InfraMessageFunctionQ[g, InfraMessageFunction[a, b], First /@ relation]]]]]
```

A chain whose light never reaches the other observer has the empty association as its one message function.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 4, 6}], b = Table[{m, m}, {m, 0, 3}]},
  InfraMessageFunctionQ[g, InfraMessageFunction[a, b], <||>] && InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] == 1]
```
