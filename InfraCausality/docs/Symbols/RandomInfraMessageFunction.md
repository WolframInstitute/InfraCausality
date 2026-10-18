---
Template: Symbol
Name: RandomInfraMessageFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomInfraMessageFunction
Keywords: [message function, monotone selection, sampler, uniform, count contract, EPS axioms, experimental]
SeeAlso: [InfraMessageFunction, InfraMessageFunctionQ, RandomInfraEchoFunction, InfraEchoFunction, MessageFunctionViewer]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[RandomInfraMessageFunction]()[*g*, [InfraMessageFunction]()[*a*, *b*]]</code> gives a random message function from *a* to *b*, an association, drawn uniformly.

<code>[RandomInfraMessageFunction]()[*g*, [InfraMessageFunction]()[*a*, *b*], *n*]</code> gives a `List` of *n* distinct message functions, or `{}` when there are fewer; `UpTo[n]` gives at most *n*; `All` gives every one.

## Details & Options

Experimental: selections.

Definition: the members of <code>[InfraMessageFunction]()[*a*, *b*]</code> are the monotone single-valued selections *f* of the message relation *M*(*v*) = *E*⁺(*v*) ∩ *b*, defined on the ticks with *M*(*v*) ≠ ∅ ([InfraMessageFunctionQ]()). They are the source-to-sink paths of a layered selection graph: one layer per tick with a message, one node per admissible image, and an edge between consecutive layers when the image does not move backwards on *b*. The sampler draws these paths with the chain engine of [RandomInfraTimelikeGeodesic](), uniformly, by path-count weights, and reads each path back as an association.

The count contract and the option are those of the chain samplers:

| Count | Result |
|---|---|
| omitted or `Automatic` | one member, an association; the empty association when no tick reaches *b* |
| `All` | every member, in no particular order |
| *n* | *n* distinct members, or `{}` when there are fewer than *n* |
| `UpTo[n]` | min(*n*, number of members) distinct members |

| `"NextVertexFunction"` | Effect |
|---|---|
| `Automatic` | uniform draws |
| `Identity` | the first members in the sorted order of their images |
| `RandomSample` | a random order of the search; `All` still enumerates |
| `RandomChoice` | random walks through the selection graph, not uniform; not with `All`, which stays unevaluated |

The number of members is the `"Cardinality"` of the head, computed by dynamic programming without enumeration.

## Basic Examples

A random message function between an observer *a* (blue) and an observer *b* (red), drawn as the light rays from each tick to its image (orange), on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {f = (SeedRandom[1]; RandomInfraMessageFunction[g, InfraMessageFunction[a, b]])},
    InfraSubstrateHighlight[g, Join[
      KeyValueMap[{v, w} |-> InfraMessageFunction[{v}, {w}] -> StandardOrange, f],
      {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Every message function of the sprinkling observers.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  Normal /@ RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]]
```

Three distinct message functions of the cylinder observers.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  Normal /@ (SeedRandom[2]; RandomInfraMessageFunction[g, InfraMessageFunction[a, b], 3])]
```

The draws are uniform: 200 draws of the ten message functions between the cylinder observers.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {draws = (SeedRandom[3]; Table[RandomInfraMessageFunction[g, InfraMessageFunction[a, b]], 200])},
  BarChart[Values @ KeySort @ Counts[Values /@ draws], ChartStyle -> StandardBlue, AxesLabel -> {"member", "draws"}]]
```

## Options

### NextVertexFunction

With `Identity` the members come in the sorted order of their images, and the strict count of the whole cardinality enumerates them.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  RandomInfraMessageFunction[g, InfraMessageFunction[a, b], 10, "NextVertexFunction" -> Identity] ===
    SortBy[RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All], Values]]
```

## Properties and Relations

`All` enumerates exactly the monotone selections of the relation, as many as the `"Cardinality"` of the head, each passing [InfraMessageFunctionQ]().

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {members = RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All],
     relation = DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}], position = AssociationThread[b, Range @ Length[b]]},
    DuplicateFreeQ[members] && Length[members] == InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] &&
      Sort[KeySort /@ members] === Sort @ Select[AssociationThread[Keys @ relation, #] & /@ Tuples[Values @ relation], f |-> LessEqual @@ (position /@ Values[f])] &&
      AllTrue[members, f |-> InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]]]]
```

The count contract: a strict count above the cardinality gives `{}`, `UpTo` caps at the cardinality, and a draw is reproducible under `SeedRandom`.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {head = InfraMessageFunction[a, b]},
    {card = InfraMeasurement[g, head, "Cardinality"]},
    RandomInfraMessageFunction[g, head, card + 1] === {} && Length[RandomInfraMessageFunction[g, head, UpTo[card + 5]]] == card &&
      Length @ DeleteDuplicates[RandomInfraMessageFunction[g, head, card]] == card &&
      (SeedRandom[7]; RandomInfraMessageFunction[g, head, UpTo[2]]) === (SeedRandom[7]; RandomInfraMessageFunction[g, head, UpTo[2]])]]
```

When no tick of *a* reaches *b*, the one member is the empty association.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {head = InfraMessageFunction[Table[{m, m}, {m, 4, 6}], Table[{m, m}, {m, 0, 3}]]},
  RandomInfraMessageFunction[g, head] === <||> && RandomInfraMessageFunction[g, head, All] === {<||>}]
```
