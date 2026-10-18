---
Template: Symbol
Name: InfraRadarChart
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraRadarChart
Keywords: [radar coordinates, radar time, radar distance, coordinatization, observer space, fibration, EPS axioms, Bondi k-calculus, symbolic object]
SeeAlso: [InfraObserver, InfraWorldline, InfraEchoFunction, InfraMessageFunction, InfraCausalDiamond, BondiRadarCoordinates]
RelatedGuides: [InfraObservers]
---

## Usage

<code>[InfraRadarChart]()[*a*]</code> is the radar chart of the observer *a*: it gives every event between the first and the last tick of *a* its radar time and radar distance.

<code>[InfraRadarChart]()[{*a*, *b*, …}]</code> joins the radar charts of several observers on the events they all chart.

## Details & Options

Definition: for an observer *a* = (*a*1 ≺ *a*2 ≺ … ≺ *ak*), a chain given as a vertex list in causal order, and an event *e* of the radar domain [*a*1, *ak*], the emission tick is *i*(*e*) = max{*i* : *ai* ≼ *e*}, the latest tick that can signal *e*, and the reception tick is *j*(*e*) = min{*j* : *e* ≼ *aj*}, the earliest tick *e* can signal. The radar time of *e* is (*i* + *j*)/2 and its radar distance (*j* − *i*)/2.

This is the radar construction of special relativity, made with the ticks of a clock instead of the readings of a continuous one: an event on the observer is its own emission and reception, at distance 0 and at its own tick; an event off it is seen by the latest signal that can reach it and answers the earliest signal it can send. Radar time is weakly monotone along every edge and radar distance is never negative. Radar distance is unsigned, so a single observer cannot tell left from right: the chart of a symmetric observer folds the graph along it. Joining the charts of several observers separates what one of them identifies.

The head holds its observers and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"Coordinates"` | the association *e* → {radar time, radar distance} over the radar domain, keys sorted; for a list of observers the concatenated coordinates |
| `"Time"`, `"Distance"` | the two marginals |
| `"Domain"` | the radar domain, a sorted vertex list; for a list of observers the intersection of their domains |
| `"Subgraph"` | the directed subgraph on the domain, laid out at {distance, time} |
| `"BaseGraph"` | the directed graph on the coordinate cells, *c* → *c'* when an edge of the domain joins them, laid out at {distance, time} in the style of a "Small" substrate |
| `"Fibration"` | the observer space: an [`InfraFibration`](paclet:WolframInstitute/InfraGeometry/ref/InfraFibration) of the undirected domain over the cells |
| `"Faithful"` | `True` |

The fibers of the observer space are the events the observers cannot tell apart; [`InfraFibers`](paclet:WolframInstitute/InfraGeometry/ref/InfraFibers) lists them and the fiber-bundle functions of InfraGeometry read sections, connections and holonomy on them.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Radar coordinates | An inertial observer assigns to an event the time (*t*1 + *t*2)/2 and distance (*t*2 − *t*1)/2, where *t*1 is the emission and *t*2 the reception of a light signal reflected at the event. |
| EPS | Radar coordinates | The message and echo functions of particles give every event coordinates from the clocks of particles, with which the conformal and projective structures are built. |
| Bondi k-calculus | Radar | The radar time and distance of an event in the plane picture, [BondiRadarCoordinates](). |

## Basic Examples

A random worldline of the substrate (blue) and its radar chart (orange), on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice. [`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws a chart by its radar domain, the events it charts.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    InfraSubstrateHighlight[g, {InfraRadarChart[a] -> StandardOrange, InfraWalk[a] -> StandardBlue}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A worldline between two inner events of the diamond lattice charts only their causal diamond; the rest of the lattice stays grey.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[{1, 0}, {5, 4}]])},
  InfraSubstrateHighlight[g, {InfraRadarChart[a] -> StandardGreen, InfraWalk[a] -> StandardRed}]]
```

The base graph of the chart, the order on its coordinate cells, drawn at distance across and time up.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[{1, 0}, {5, 4}]])},
  InfraMeasurement[g, InfraRadarChart[a], "BaseGraph"]]
```

The radar domains of the two lattices redrawn in their radar coordinates, distance across and time up. The observer is the vertical axis.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    InfraSubstrateHighlight[InfraMeasurement[g, InfraRadarChart[a], "Subgraph"], {InfraWalk[a]}]],
  {name, {"DiamondLatticeGraph", "CylinderLatticeGraph"}}]
```

The radar coordinates of the first events of the sprinkling: the ticks 1, 2 and 10 of the observer lie at distance 0.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  Take[Normal @ InfraMeasurement[g, InfraRadarChart[a], "Coordinates"], 10]]
```

The number of events of the radar domain beside the number of coordinate cells, the fibers of the observer space. On the lattices the chart is injective; on the sprinkling the observer identifies events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {Length @ InfraMeasurement[g, InfraRadarChart[a], "Domain"], Length @ InfraFibers @ InfraMeasurement[g, InfraRadarChart[a], "Fibration"]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A second observer separates what the first one identifies: on the events both observers chart, the joined chart of the sprinkling has more cells than the chart of the first observer.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraWorldline[g])},
  {b = (SeedRandom[1]; RandomInfraWorldline[VertexDelete[g, a]])},
  {domain = InfraMeasurement[g, InfraRadarChart[{a, b}], "Domain"]},
  {Length @ domain,
   Length @ Union @ Values @ KeyTake[InfraMeasurement[g, InfraRadarChart[a], "Coordinates"], domain],
   Length @ Union @ Values @ InfraMeasurement[g, InfraRadarChart[{a, b}], "Coordinates"]}]
```

## Properties and Relations

A tick of the observer is its own emission and reception: the *m*-th tick has radar time *m* and distance 0.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {coordinates = InfraMeasurement[g, InfraRadarChart[a], "Coordinates"]},
    coordinates /@ a === Table[{m, 0}, {m, Length @ a}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Radar time never decreases along an edge of the domain, and radar distance is never negative.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {time = InfraMeasurement[g, InfraRadarChart[a], "Time"]},
    AllTrue[EdgeList @ InfraMeasurement[g, InfraRadarChart[a], "Subgraph"], edge |-> time[First @ edge] <= time[Last @ edge]] &&
      AllTrue[InfraMeasurement[g, InfraRadarChart[a], "Distance"], NonNegative]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The radar domain is the causal diamond of the first and the last tick, and the fibers of the observer space partition it.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraWorldline[g])},
    {domain = InfraMeasurement[g, InfraRadarChart[a], "Domain"]},
    domain === RandomInfraCausalDiamond[g, First @ a, Last @ a] &&
      Sort[Join @@ Values[VertexList /@ InfraFibers @ InfraMeasurement[g, InfraRadarChart[a], "Fibration"]]] === domain],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```
