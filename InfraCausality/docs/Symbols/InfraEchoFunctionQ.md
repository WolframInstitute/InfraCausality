---
Template: Symbol
Name: InfraEchoFunctionQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraEchoFunctionQ
Keywords: [echo function, radar, composition, message function, EPS axioms, Ehlers-Pirani-Schild, predicate]
SeeAlso: [InfraEchoFunction, RandomInfraEchoFunction, InfraMessageFunctionQ, InfraMessageFunction, InfraRadarChart]
RelatedGuides: [InfraObservers]
---

## Usage

<code>[InfraEchoFunctionQ]()[*g*, [InfraEchoFunction]()[*a*, *b*], *f*]</code> gives `True` if the association *f* is the composition of a message function from *a* to *b* with a message function from *b* back to *a*.

## Details & Options

Statement: an association *f* from ticks of *a* to ticks of *a* is an echo function of *a* via *b* when there are message functions *f*<sub>*ab*</sub> from *a* to *b* and *f*<sub>*ba*</sub> from *b* to *a*, in the sense of [InfraMessageFunctionQ](), with *f* = *f*<sub>*ba*</sub> ∘ *f*<sub>*ab*</sub>: the keys of *f* are the ticks *v* whose message *f*<sub>*ab*</sub>(*v*) has a return, and *f*(*v*) = *f*<sub>*ba*</sub>(*f*<sub>*ab*</sub>(*v*)). This is the EPS echo: a light signal sent from *a*, reflected at *b* and received back on *a*.

The domain of an echo function depends on the message function chosen: a tick whose light reaches *b* both at a tick that answers and at one that does not lies in the domain of some echo functions and not of others. The empty association is an echo function when some message function to *b* sends every tick to a tick with no return.

Being a monotone selection of the echo relation, the `"Relation"` of [InfraEchoFunction](), is necessary and not sufficient. The predicate decides the composition without enumerating the message functions: it walks the ticks of *a* through the layers of admissible images on *b*, keeping only images that move forward along *b*, or stay at a tick of *b* whose return is already fixed. [`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) on the head is this predicate.

## Basic Examples

On the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice, an observer *a* and an observer *b* of the rest of the substrate. On each: a random echo function, the earliest echoes of the echo relation, and an echo function with one of its returns moved to a tick that is not an echo.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {f = (SeedRandom[1]; RandomChoice @ Select[RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All], e |-> e =!= <||>])},
    {InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f],
     InfraEchoFunctionQ[g, InfraEchoFunction[a, b], First /@ DeleteCases[InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"], {}]],
     InfraEchoFunctionQ[g, InfraEchoFunction[a, b], Append[f, First[Keys @ f] -> First[a]]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the cylinder lattice the first two ticks of *a* reach *b* at ticks that answer and at ticks that do not, so the echo functions have domains of zero, one and two ticks.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  Normal /@ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]]
```

A monotone selection of the echo relation that is no composition. On the diamond lattice the staircase *a* sends light to the staircase *b* two steps up; every value of *f* lies in the echo relation and the values move forward along *a*, but no pair of message functions composes to *f*.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {b = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {a = Select[(# + {0, 2}) & /@ b, Max[#] <= 6 &]},
  {f = <|{0, 2} -> {2, 3}, {1, 2} -> {2, 3}, {1, 3} -> {3, 4}, {2, 3} -> {3, 4}, {2, 4} -> {4, 5}, {3, 4} -> {4, 5}, {4, 5} -> {5, 6}|>},
  {relation = InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"]},
  {AllTrue[Keys[f], v |-> MemberQ[relation[v], f[v]]], InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]}]
```

The same pair has 699 echo functions.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {b = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {a = Select[(# + {0, 2}) & /@ b, Max[#] <= 6 &]},
  InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"]]
```

## Properties and Relations

The echo functions are exactly the compositions of two message functions, enumerated by brute force from [RandomInfraMessageFunction](), and the compositions pass; on the lattice, with 168 of them, the first forty are checked.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {compositions = DeleteDuplicates @ Catenate @ Outer[
      {s, t} |-> KeySort @ DeleteMissing[Lookup[t, Key[#]] & /@ s],
      RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All], RandomInfraMessageFunction[g, InfraMessageFunction[b, a], All], 1]},
    Sort[compositions] === Sort[KeySort /@ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]] &&
      AllTrue[Take[compositions, UpTo[40]], f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]]]]
```

Among the compositions of arbitrary single-valued selections, the predicate accepts exactly those of two message functions. Checked on the sprinkling and the cylinder lattice.

```wl
AllTrue[{"MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {selections = {x, y} |-> With[{relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[x, y], "Relation"], {}]},
      AssociationThread[Keys @ relation, #] & /@ Tuples[Values @ relation]]},
    {members = KeySort /@ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]},
    AllTrue[DeleteDuplicates @ Catenate @ Outer[{s, t} |-> KeySort @ DeleteMissing[Lookup[t, Key[#]] & /@ s], selections[a, b], selections[b, a], 1],
      f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f] === MemberQ[members, f]]]]
```

[`InfraMemberQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) agrees with the predicate, on members and on members with one return moved back to the tick that sent it.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {sample = (SeedRandom[1]; RandomInfraEchoFunction[g, InfraEchoFunction[a, b], UpTo[8]])},
    AllTrue[Join[sample, Map[f |-> Append[f, First[Keys @ f] -> First[Keys @ f]], Select[sample, f |-> f =!= <||>]]], f |->
      InfraMemberQ[g, InfraEchoFunction[a, b], f] === InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]]]]
```

On the staircases of the diamond lattice the 699 echo functions pass, and they are at most the product of the numbers of message functions each way, 81 × 81.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {b = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {a = Select[(# + {0, 2}) & /@ b, Max[#] <= 6 &]},
  {members = RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]},
  Length[members] == 699 <= InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"] &&
    AllTrue[members[[1 ;; ;; 25]], f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]]]
```
