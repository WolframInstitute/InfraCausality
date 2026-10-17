---
Template: Symbol
Name: InfraEchoFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraEchoFunction
Keywords: [echo function, radar, round trip, light signal, EPS axioms, Ehlers-Pirani-Schild, observer, symbolic object]
SeeAlso: [InfraEchoFunctionQ, InfraMessageFunction, RandomInfraEchoFunction, InfraRadarChart, InfraFutureLightCone, InfraObserver]
RelatedGuides: [InfraObservers]
---

## Usage

<code>[InfraEchoFunction]()[*a*, *b*]</code> is the echo relation of the observer *a* via the observer *b*: each tick of *a* goes to the ticks of *a* that receive the light returned from *b*. Its members are the echo functions, the order-preserving compositions of a message from *a* to *b* with a message back.

## Details & Options

Definition: with the message relations *M*ab from *a* to *b* and *M*ba from *b* to *a* of [InfraMessageFunction](), the echo relation sends a tick *v* of *a* to Echo(*v*) = ⋃ *M*ba(*w*) over *w* ∈ *M*ab(*v*), the ticks of *a* lit by the return signals. An echo function is a composition *t* ∘ *s* of a message function *s* from *a* to *b* and a message function *t* from *b* to *a*, kept when it does not reverse the order of the ticks of *a*.

The echo is the round trip of radar: the observer *a* sends a signal at tick *v*, it is reflected at *b*, and it comes back at a later tick. In Minkowski space the echo is a single event, and the emission and reception times give the radar time and distance of the reflection event. On a graph the echo of a tick can be several ticks, or none when the signal misses *b* or the return misses *a*; every echo lies strictly after its tick.

The head holds its two observers and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"Relation"` | the association *v* → Echo(*v*) over every tick of *a*, echoes in the order of *a* |
| `"Graph"` | the directed graph *v* → *u* of the relation, on the ticks of *a* |
| `"Cardinality"` | the number of distinct echo functions, by enumeration |
| `"Faithful"` | `True` |

A member is an association from ticks of *a* to ticks of *a*. [InfraEchoFunctionQ]() checks that a map is single-valued, picks an echo and preserves the order; the experimental [RandomInfraEchoFunction]() draws members or enumerates them. [InfraSubstrateHighlight](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws the head as the outgoing and returning light rays.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Radar echo | A light signal sent from an observer at time *t*1, reflected at an event, returns at time *t*2; the event has radar time (*t*1 + *t*2)/2 and radar distance (*t*2 − *t*1)/2. |
| EPS | Echo | The composition of the message from a particle *P* to a particle *Q* with the message from *Q* back to *P*, a map of *P* to itself that increases its clock. |

## Basic Examples

The echoes of an observer *a* (blue) via an observer *b* (red), drawn as the outgoing and returning light rays (orange). The observer *a* is a random longest chain of the substrate and *b* a random longest chain of the rest of it. On the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice:

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraSubstrateHighlight[g, {InfraEchoFunction[a, b] -> StandardOrange, InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The number of echo functions for the same observers.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The echo relation on the sprinkling, and its echo functions.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Normal @ InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"]]
```

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Normal /@ RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]]
```

The graph of the echo relation on the sprinkling, an arrow from each tick to its echoes.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Graph[InfraMeasurement[g, InfraEchoFunction[a, b], "Graph"], VertexLabels -> Automatic]]
```

On the diamond lattice a light signal can travel only along the two null directions, so two parallel null lines exchange no echo: the signal from {0, *j*} reaches {2, *j*}, but nothing returns.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{0, j}, {j, 0, 6}], b = Table[{2, j}, {j, 0, 6}]},
  Union @ Values @ InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"]]
```

## Properties and Relations

Every echo of a tick lies strictly after the tick on *a*.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    AllTrue[Normal @ InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"], Apply[{v, echoes} |->
      AllTrue[echoes, u |-> First[FirstPosition[a, u]] > First[FirstPosition[a, v]]]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The echo relation is the composition of the two message relations.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    {there = InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], back = InfraMeasurement[g, InfraMessageFunction[b, a], "Relation"]},
    AllTrue[Normal @ InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"], Apply[{v, echoes} |->
      Sort[echoes] === Union @@ Prepend[back /@ there[v], {}]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The cardinality is the number of members, and every member passes [InfraEchoFunctionQ]().

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    {members = RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]},
    Length[members] == InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"] &&
      AllTrue[members, f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```
