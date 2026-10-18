---
Template: Symbol
Name: InfraEchoFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraEchoFunction
Keywords: [echo function, radar, round trip, light signal, EPS axioms, Ehlers-Pirani-Schild, observer, EPS defects, k-factor, Bondi factor, symbolic object]
SeeAlso: [InfraEchoFunctionQ, InfraMessageFunction, RandomInfraEchoFunction, InfraRadarChart, InfraFutureLightCone, InfraObserver]
RelatedGuides: [InfraObservers]
---

## Usage

<code>[InfraEchoFunction]()[*a*, *b*]</code> is the echo relation of the observer *a* via the observer *b*: each tick of *a* goes to the ticks of *a* that receive the light returned from *b*. Its members are the echo functions, the compositions of a message function from *a* to *b* with a message function from *b* back to *a*.

## Details & Options

Definition: with the message relations *M*ab from *a* to *b* and *M*ba from *b* to *a* of [InfraMessageFunction](), the echo relation sends a tick *v* of *a* to Echo(*v*) = ⋃ *M*ba(*w*) over *w* ∈ *M*ab(*v*), the ticks of *a* lit by the return signals. An echo function is a composition *t* ∘ *s* of a message function *s* from *a* to *b* and a message function *t* from *b* to *a*, both order-preserving selections (EPS axiom D1), defined on the ticks *v* of *a* whose signal returns, that is *s*(*v*) has a message back. Two pairs (*s*, *t*) can give the same echo function, and the members are the distinct composites.

Every echo function preserves the order of *a*, but not every order-preserving map into the echo relation is an echo function: a map with admissible images may factor only through a selection that reverses the order of two message images. [InfraEchoFunctionQ]() decides membership exactly and without enumeration: the map must be order-preserving with its domain among the ticks that have a message, and the layered selection DAG of *M*ab, restricted to the images *w* of a tick *v* with *f*(*v*) ∈ *M*ba(*w*) (or with *M*ba(*w*) empty when *v* is outside the domain of *f*), with an edge between equal images of consecutive ticks kept only when *f* takes the same value on both, must have a path from the first tick to the last. A path is a selection *s*, and *t* is read off it as *t*(*s*(*v*)) = *f*(*v*); *t* is order-preserving because *f* and *s* are, and it extends to the ticks of *b* that *s* misses because each message image is an initial segment of the future of its tick on *b*.

The echo is the round trip of radar: the observer *a* sends a signal at tick *v*, it is reflected at *b*, and it comes back at a later tick. In Minkowski space the echo is a single event, and the emission and reception times give the radar time and distance of the reflection event. On a graph the echo of a tick can be several ticks, or none when the signal misses *b* or the return misses *a*; every echo lies strictly after its tick.

The head holds its two observers and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"Relation"` | the association *v* → Echo(*v*) over every tick of *a*, echoes in the order of *a* |
| `"Graph"` | the directed graph *v* → *u* of the relation, on the ticks of *a* |
| `"Cardinality"` | the number of distinct echo functions, by enumeration of the two sets of message functions; at most the product of the two message cardinalities |
| `"Faithful"` | `True` |

A member is an association from ticks of *a* to ticks of *a*. [InfraEchoFunctionQ]() decides membership, and [InfraMemberQ](paclet:WolframInstitute/InfraGeometry/ref/InfraMemberQ) is the same test; the experimental [RandomInfraEchoFunction]() draws members or enumerates them. [InfraSubstrateHighlight](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws the head as the outgoing and returning light rays.

Experimental: the EPS defects of the echo relation are the four defects of [InfraMessageFunction]() read on the relation *v* → Echo(*v*), on the window of *a* left by the option `"Boundary" -> b` (a fourth argument, default 0), with the echoes anywhere on *a*: `"DomainDefect"` the fraction of window ticks without an echo, `"FunctionDefect"` the mean of max(0, \|Echo(*v*)\| − 1) / max(1, \|Echo(*v*)\|), `"InjectivityDefect"` 1 − ν / *n* with ν a maximum matching of the relation, and `"OrderDefect"` the fraction of ordered window pairs *v* before *w* with an echo of *v* after an echo of *w*. In Minkowski space the echo of an inertial observer via another is a monotone injection of its clock into itself, and all four vanish.

`"KFactor"` is the square root of the ratio of echo to tick spans of the earliest-echo selection: with *v*, *w* the first and last window ticks that have an echo, √((pos *e*(*w*) − pos *e*(*v*)) / (pos *w* − pos *v*)), positions counted on *a*. In Minkowski space an observer receding at speed *v* returns the radar signal of another after *k*² times the sending time, with *k* = √((1 + *v*)/(1 − *v*)) the Bondi factor, so the square root is the Bondi factor under reciprocity, *k*ab = *k*ba. The reading uses the clock of *a* alone: on the diamond lattice the resting chain {(*m*, *m*)} echoed by the chain {((*p* + 1)*m*, *pm*)} of velocity 1/(2*p* + 1) reads exactly √((*p* + 1)/*p*), the Bondi factor, although the moving chain's ticks are not its proper time. On sprinklings the longest chains between two events wander, so two observers with a given endpoint velocity share stretches of their worldlines and the reading scatters widely at a few hundred events.

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

## Scope

### Experimental readings

The lattice observers at rest, {(*m*, *m*)} and {(*m*, *m* + 2)}, echo each other tick for tick: the four echo defects vanish on the interior window and the k-factor is 1.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  Table[InfraMeasurement[g, InfraEchoFunction[a, b], p, "Boundary" -> 2],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect", "KFactor"}}]]
```

The Lorentz check on the lattice: the resting chain echoed by the chain {(2*m*, *m*)} of velocity 1/3 reads the Bondi factor √2, by {(3*m*, 2*m*)} of velocity 1/5 the factor √(3/2).

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}]},
  Table[
    With[
      {b = Table[{(p + 1) m, p m}, {m, 1, Floor[6/(p + 1)]}], v = 1/(2 p + 1)},
      {InfraMeasurement[g, InfraEchoFunction[a, b], "KFactor"], Sqrt[(1 + v)/(1 - v)]}],
    {p, 2}]]
```

The echo defects of two random worldlines on the sprinkling, where few ticks get an echo.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Table[InfraMeasurement[g, InfraEchoFunction[a, b], p],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]]
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

The cardinality is the number of members, every member passes [InfraEchoFunctionQ](), and there are at most as many members as pairs of message functions.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    {members = RandomInfraEchoFunction[g, InfraEchoFunction[a, b], All]},
    Length[members] == InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"] &&
      AllTrue[members, f |-> InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]] &&
      Length[members] <= InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Every member is the composite of two members of the message heads, and every such composite is a member.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {b = Select[(# + {0, 2}) & /@ a, Max[#] <= 6 &]},
  {there = RandomInfraMessageFunction[g, InfraMessageFunction[b, a], All], back = RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]},
  Sort[KeySort /@ DeleteDuplicates @ Catenate @ Outer[{s, t} |-> DeleteMissing[Lookup[t, Key[#]] & /@ s], there, back, 1]] ===
    Sort[KeySort /@ RandomInfraEchoFunction[g, InfraEchoFunction[b, a], All]]]
```

On the diamond lattice, the staircase worldline and its shift by two steps exchange 81 message functions each way, and the shifted observer has 699 echo functions via the staircase while the staircase has 2584 via the shifted observer.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {b = Select[(# + {0, 2}) & /@ a, Max[#] <= 6 &]},
  {InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"], InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"],
    InfraMeasurement[g, InfraEchoFunction[b, a], "Cardinality"], InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"]}]
```

An order-preserving map with admissible images need not be an echo function. This one sends no signal from {3, 5} back but returns the later tick {4, 5} to {5, 6}, which forces the message from {3, 5} to the later image {6, 5} and the message from {4, 5} to the earlier {5, 5}; [InfraEchoFunctionQ]() rejects it without enumerating the members.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {b = Select[(# + {0, 2}) & /@ a, Max[#] <= 6 &]},
  {f = <|{0, 2} -> {2, 3}, {1, 2} -> {2, 3}, {1, 3} -> {3, 4}, {2, 3} -> {3, 4}, {2, 4} -> {4, 5}, {3, 4} -> {4, 5}, {4, 5} -> {5, 6}|>},
  {relation = InfraMeasurement[g, InfraEchoFunction[b, a], "Relation"]},
  {AllTrue[Keys[f], v |-> MemberQ[relation[v], f[v]]], InfraEchoFunctionQ[g, InfraEchoFunction[b, a], f], MemberQ[RandomInfraEchoFunction[g, InfraEchoFunction[b, a], All], f]}]
```
