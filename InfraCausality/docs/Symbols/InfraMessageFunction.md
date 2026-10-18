---
Template: Symbol
Name: InfraMessageFunction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraMessageFunction
Keywords: [message function, light signal, EPS axioms, Ehlers-Pirani-Schild, observer, monotone selection, EPS defects, k-factor, Bondi factor, symbolic object]
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

Experimental: the EPS defects measure how far the relation is from a monotone bijection of *a* onto *b*, the message function of two inertial observers in Minkowski space. They are read on a window of *a*, the ticks that remain after the option `"Boundary" -> b` drops *b* ticks at each end (default 0), given as a fourth argument; the images stay in the whole of *b*. With *M*(*v*) the image of a window tick and *n* the window size:

| Property | Value |
|---|---|
| `"DomainDefect"` | #{*v* : *M*(*v*) = ∅} / *n*, the fraction of ticks without a message |
| `"FunctionDefect"` | the mean over the window of max(0, \|*M*(*v*)\| − 1) / max(1, \|*M*(*v*)\|), zero exactly when every image has at most one tick |
| `"InjectivityDefect"` | 1 − ν / *n*, with ν the size of a maximum matching of the bipartite graph of the relation |
| `"OrderDefect"` | the fraction of ordered tick pairs *v* before *w* in the window for which some image of *v* comes after some image of *w* on *b* |
| `"KFactor"` | the ratio of received to sent tick spans of the earliest-image selection: with *v*, *w* the first and last window ticks that have a message, (pos *f*(*w*) − pos *f*(*v*)) / (pos *w* − pos *v*), positions counted on *b* and on *a* |

The four defects lie in [0, 1]; the injectivity defect is at least the domain defect, since a matching uses no tick without a message. The k-factor is the graph form of the Bondi factor: in Minkowski space an inertial observer receding at speed *v* receives the ticks of another at *k* = √((1 + *v*)/(1 − *v*)) proper seconds per second sent. On a graph the tick spans are chain lengths, so the reading is a clock-rate statement, and it is the Bondi factor only where ticks count proper time. On the diamond lattice the chain {(*m*, *m*)} at rest sends its ticks one to one to the chain {(2*m*, *m*)} of velocity 1/3, k-factor 1 instead of √2, because that chain's ticks are √2 times longer in proper time; the echo read on the resting clock alone recovers √2, see [InfraEchoFunction]().

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Light signal | A light ray from an event of one inertial worldline meets a second worldline at exactly one event, later on its clock for a later emission. |
| EPS | Message function | The map from a particle *P* to a particle *Q* that sends an event of *P* to the event of *Q* reached by a light signal from it; with the echo it defines radar coordinates. |

## Basic Examples

The messages from an observer *a* (blue) to an observer *b* (green), drawn as the light rays that carry them (red). The observer *a* is a random longest chain of the substrate and *b* a random longest chain of the rest of it. On the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice:

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    InfraSubstrateHighlight[g, {InfraMessageFunction[a, b] -> Red, InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardGreen}]],
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

## Scope

### Experimental readings

The lattice observers at rest, the chain {(*m*, *m*)} and its parallel {(*m*, *m* + 2)}, exchange their ticks one to one: on the interior window the four defects vanish and the k-factor is 1.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  Table[InfraMeasurement[g, InfraMessageFunction[a, b], p, "Boundary" -> 2],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect", "KFactor"}}]]
```

Without the boundary the two top ticks of {(*m*, *m*)} send their light out of the lattice: domain and injectivity defects 2/7.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  Table[InfraMeasurement[g, InfraMessageFunction[a, b], p],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]]
```

Each light ray from the staircase meets the shifted staircase in two consecutive ticks, so the function defect of the interior window is exactly 1/2; the two pairs of consecutive ticks with the same two images make the order defect 2/10 on a window of five ticks.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {b = Select[(# + {0, 2}) & /@ a, Max[#] <= 6 &]},
  Table[InfraMeasurement[g, InfraMessageFunction[a, b], p, "Boundary" -> 4],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]]
```

A chain against a chain in its past has no messages at all: domain and injectivity defects 1.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 4, 6}], b = Table[{m, m}, {m, 0, 3}]},
  Table[InfraMeasurement[g, InfraMessageFunction[a, b], p],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]]
```

The defects of two random worldlines on the sprinkling: a light ray rarely meets a tick exactly, so half the ticks have no message.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  Table[InfraMeasurement[g, InfraMessageFunction[a, b], p],
    {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]]
```

## Options

### Boundary

The window of `"Boundary" -> b` is *a* with *b* ticks removed at each end; the reading on the window equals the reading of the head whose first observer is the window.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  InfraMeasurement[g, InfraMessageFunction[a, b], "DomainDefect", "Boundary" -> 1] ==
    InfraMeasurement[g, InfraMessageFunction[a[[2 ;; -2]], b], "DomainDefect"]]
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

The experimental defects lie in the unit interval, and the injectivity defect is at least the domain defect.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
    {defects = Table[InfraMeasurement[g, InfraMessageFunction[a, b], p], {p, {"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}}]},
    AllTrue[defects, 0 <= # <= 1 &] && defects[[3]] >= defects[[1]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the lattice the message k-factors of the resting chain {(*m*, *m*)} and the chain {((*p* + 1)*m*, *pm*)} of velocity 1/(2*p* + 1) are 1/*p* and *p* + 1, the ratios of their tick rates; their product (*p* + 1)/*p* is the square of the Bondi factor, which the echo reads directly.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}]},
  Table[
    With[
      {b = Table[{(p + 1) m, p m}, {m, 1, Floor[6/(p + 1)]}], v = 1/(2 p + 1)},
      {InfraMeasurement[g, InfraMessageFunction[a, b], "KFactor"], InfraMeasurement[g, InfraMessageFunction[b, a], "KFactor"],
        InfraMeasurement[g, InfraMessageFunction[a, b], "KFactor"] InfraMeasurement[g, InfraMessageFunction[b, a], "KFactor"] == (1 + v)/(1 - v)}],
    {p, 2}]]
```
