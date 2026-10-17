---
Template: Symbol
Name: InfraMessageFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraMessageFunction
Keywords: [message function, light signal, EPS axioms, Ehlers-Pirani-Schild, observer, monotone selection, symbolic object]
SeeAlso: [InfraMessageFunctionQ, InfraEchoFunction, RandomInfraMessageFunction, InfraFutureLightCone, InfraObserver, InfraRadarChart, MessageFunctionViewer]
RelatedGuides: [InfraObservers]
---

## Usage

<code>[InfraMessageFunction]()[*a*, *b*]</code> is the message relation from the observer *a* to the observer *b*: each tick of *a* goes to the ticks of *b* that its light rays reach. Its members are the message functions, the single-valued selections of the relation that preserve the order of the ticks.

## Details & Options

Definition: for observers *a* and *b*, chains given as vertex lists in causal order, the message relation sends a tick *v* of *a* to *M*(*v*) = *E*⁺(*v*) ∩ *b*, the ticks of *b* on the future light cone of *v*. A message function is a map *f* from the ticks *a'* of *a* with a message to *b* such that *f*(*v*) ∈ *M*(*v*) for every *v* in *a'* and *f* does not reverse the order: if *v* comes before *w* on *a*, then *f*(*v*) does not come after *f*(*w*) on *b*.

In Minkowski space a light signal from an event of one particle reaches the other particle at exactly one event, and the map preserves the order of the clocks. On a graph a light cone can meet an observer in several ticks, or in none: the relation is set-valued and partial, and the message functions are its consistent single-valued choices. There can be many, or exactly one, as on the diamond lattice between two parallel null lines.

The head holds its two observers and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"Relation"` | the association *v* → *M*(*v*) over every tick of *a*, images in the order of *b* |
| `"Graph"` | the directed graph *v* → *w* of the relation |
| `"Cardinality"` | the number of message functions, by dynamic programming over the ticks of *a* |
| `"Faithful"` | `True` |

A member is an association from the ticks of *a* with a message to ticks of *b*. [InfraMessageFunctionQ]() recognises one, and the experimental [RandomInfraMessageFunction]() draws members uniformly or enumerates them. [InfraSubstrateHighlight](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws the head as the light rays that carry its messages.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Light signal | A light ray from an event of one inertial worldline meets a second worldline at exactly one event, later on its clock for a later emission. |
| EPS | Message function | The map from a particle *P* to a particle *Q* that sends an event of *P* to the event of *Q* reached by a light signal from it; with the echo it defines radar coordinates. |

## Basic Examples

The messages from an observer *a* (blue) to an observer *b* (red), drawn as the light rays that carry them (orange). The observer *a* is a random longest chain of the substrate and *b* a random longest chain of the rest of it. On the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice:

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraSubstrateHighlight[g, {InfraMessageFunction[a, b] -> StandardOrange, InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The number of message functions for the same observers.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The message relation on the sprinkling. The first tick reaches two ticks of *b*; the last four reach none.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Normal @ InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"]]
```

Its two message functions.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Normal /@ RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]]
```

Between two parallel null lines of the diamond lattice the message function is unique: the tick {0, *j*} is sent to {2, *j*}.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{0, j}, {j, 0, 6}], b = Table[{2, j}, {j, 0, 6}]},
  {InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"],
   Normal @ First @ RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]}]
```

## Properties and Relations

The images of a tick are the ticks of *b* on its future light cone.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    AllTrue[Normal @ InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], Apply[{v, images} |->
      Sort[images] === Intersection[b, Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"]]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The cardinality is the number of members, and every member passes [InfraMessageFunctionQ]().

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    {members = RandomInfraMessageFunction[g, InfraMessageFunction[a, b], All]},
    Length[members] == InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"] &&
      AllTrue[members, f |-> InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Sending every tick to its earliest image is always a message function.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraMessageFunctionQ[g, InfraMessageFunction[a, b],
      First /@ DeleteCases[InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"], {}]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```
