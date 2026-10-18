---
Template: TechNote
Name: CausalInfrageometryTutorial
Title: Causal Infrageometry: from a Causal Graph to the Observer Space
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/tutorial/CausalInfrageometryTutorial
Keywords: [causal graph, causal diamond, worldline, timelike geodesic, observer, universal time, message function, echo function, radar chart, radar coordinates, observer space, fibration, section, EPS axioms]
RelatedGuides: [CausalInfrageometry, CausalTime, InfraObservers, CausalSubstrates]
---

- A **causal graph** is a directed acyclic graph whose vertices are events and whose directed paths are the causal relation: *u* ≼ *v* when a path leads from *u* to *v*. Everything below is read off the graph alone.
- The pipeline: causal graph → cones and diamonds → worldlines and timelike geodesics → universal time → message functions → radar chart → the observer space fibered over the chart.
- Each construction is an inert head, such as `InfraCausalDiamond[p, q]` or `InfraRadarChart[a]`, that holds its data and computes nothing; `InfraMeasurement` reads it on a graph, a `RandomInfra…` sampler draws the members of a chain head and `InfraSubstrateHighlight` draws it.
- The running example is the diamond lattice at size "Small", the 7 × 7 light-cone lattice of 1 + 1 Minkowski space; a sprinkling and the cylinder lattice show where the lattice is special.

## Setup

```wl
Needs["WolframInstitute`InfraGeometry`"];
Needs["WolframInstitute`InfraCausality`"]
```

## The causal graph

- The three substrates of the documentation: the diamond lattice, the Hasse diagram of the product order on {0, …, 6}²; a sprinkling of 25 points into a causal diamond of two-dimensional Minkowski space; and the cylinder lattice, a light-cone lattice closed in space. Time runs upward.

```wl
GraphicsRow @ Table[CausalSubstrate[name, "Small"],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

- A substrate is transitively reduced: its edges are the covering pairs, the steps with no event between. On the diamond lattice the order is the product order (*i*, *j*) ≼ (*k*, *l*) ⟺ *i* ≤ *k* and *j* ≤ *l*, the closed light cone in the coordinates *x* = (*j* − *i*)/2, *t* = (*i* + *j*)/2.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[VertexList[g], v |-> Sort @ VertexOutComponent[g, {v}] === Sort @ Select[VertexList[g], w |-> And @@ Thread[v <= w]]]]
```

## Cones and diamonds

- The **causal future** *J*⁺(*p*) is the set of events *p* can influence, the **causal past** *J*⁻(*q*) the set that can influence *q*, and the **causal diamond** [*p*, *q*] = *J*⁺(*p*) ∩ *J*⁻(*q*) the events between them. The **future light cone** *E*⁺(*p*) keeps the events reached from *p* by a light ray, a chain that cannot be lengthened between its ends.
- On the lattice: the future of {1, 0} (orange), the past of {5, 4} (blue), their diamond (green), and the light cone of {1, 0} (red), its two null lines.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCausalFuture[{1, 0}] -> StandardOrange, InfraCausalPast[{5, 4}] -> StandardBlue}],
    InfraSubstrateHighlight[g, {InfraCausalDiamond[{1, 0}, {5, 4}] -> StandardGreen, InfraFutureLightCone[{1, 0}] -> StandardRed}]}]]
```

- The diamond of {1, 0} and {5, 4} is a 5 × 5 square of the lattice: [(*i*, *j*), (*k*, *l*)] has (*k* − *i* + 1)(*l* − *j* + 1) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  InfraMeasurement[g, InfraCausalDiamond[{1, 0}, {5, 4}], "CountingMeasure"]]
```

- On the sprinkling the light cone of an event is a tree of light rays, not two lines: a ray is a maximal chain between its ends, and several can leave an event in each direction.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, {InfraCausalFuture[2] -> StandardOrange, InfraFutureLightCone[2] -> StandardRed, 2}]]
```

## Worldlines and timelike geodesics

- A **worldline** is a saturated chain, a directed path of the substrate; an **observer** is a worldline whose positions are read as the ticks of a clock. A **timelike geodesic** from *p* to *q* is a longest chain between them, the discrete inertial observer: its number of steps is the proper time τ(*p*, *q*). The hierarchy of the chain predicates is light ray ⟹ timelike geodesic ⟹ worldline ⟹ chain.
- A timelike geodesic from {0, 0} to {6, 6}, drawn with the diamond it lies in.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  InfraSubstrateHighlight[g, {InfraCausalDiamond[{0, 0}, {6, 6}] -> StandardGreen, InfraWalk[a] -> StandardRed}]]
```

- On the lattice every worldline from corner to corner has twelve steps, so the 924 = (12 choose 6) worldlines are all timelike geodesics. On the sprinkling only 21 of the 49 worldlines from the first to the last event are longest chains.

```wl
With[
  {lattice = CausalSubstrate["DiamondLatticeGraph", "Small"], sprinkling = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {{InfraMeasurement[lattice, InfraTimelikeGeodesic[{0, 0}, {6, 6}], "Cardinality"], InfraMeasurement[lattice, InfraWorldline[{0, 0}, {6, 6}], "Cardinality"]},
   {InfraMeasurement[sprinkling, InfraTimelikeGeodesic[1, 25], "Cardinality"], InfraMeasurement[sprinkling, InfraWorldline[1, 25], "Cardinality"]}}]
```

- The diagonal {(*m*, *m*)} is a chain and no worldline: each step (*m*, *m*) ≺ (*m* + 1, *m* + 1) has two events between. It will matter below, since the radar chart accepts any chain.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}]},
  {InfraChainQ[g, diagonal], InfraWorldlineQ[g, diagonal], InfraTimelikeGeodesicQ[g, (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])]}]
```

## Universal time

- The **universal time** of an event is the length of a longest chain from a source to it, and its level sets, the **slices**, are antichains that partition the events. They are the simultaneity surfaces that need no observer. On the lattice the slices are the antidiagonals; on the sprinkling they are ragged.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, UniversalFoliation[g]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D"}}]
```

- The ticks of a timelike geodesic from a source count universal time: the *m*-th tick of the geodesic *a* above lies on the slice *m* − 1.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  UniversalTime[g] /@ a]
```

## Message functions

- Two observers *a* and *b* exchange light. The **message relation** sends a tick *v* of *a* to the ticks *E*⁺(*v*) ∩ *b* of *b* on its light cone, and a **message function** is a single-valued selection of it that preserves the order of the ticks, the discrete form of the Ehlers–Pirani–Schild axiom D1. An **echo function** is a message function to *b* composed with one back to *a*.
- The geodesic *a* above (blue) and a longest chain *b* of the rest of the lattice (red), with the light rays that carry the messages from *a* to *b* (orange).

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  InfraSubstrateHighlight[g, {InfraMessageFunction[a, b] -> StandardOrange, InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}]]
```

- A light cone meets the other observer in several ticks or none, so there are many message functions: 36 from *a* to *b*, 24 back, and 168 distinct echo functions of *a* via *b*.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {InfraMeasurement[g, InfraMessageFunction[a, b], "Cardinality"], InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"],
   InfraMeasurement[g, InfraEchoFunction[a, b], "Cardinality"]}]
```

- One message function, drawn as the light rays from each tick to its image.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {f = (SeedRandom[2]; RandomInfraMessageFunction[g, InfraMessageFunction[a, b]])},
  InfraSubstrateHighlight[g, Join[KeyValueMap[{v, w} |-> InfraMessageFunction[{v}, {w}] -> StandardOrange, f],
    {InfraWalk[a] -> StandardBlue, InfraWalk[b] -> StandardRed}]]]
```

## The radar chart

- The radar chart of an observer *a* = (*a*1, …, *ak*) gives every event *e* of its radar domain [*a*1, *ak*] the emission tick *i*(*e*), the latest tick that can signal *e*, and the reception tick *j*(*e*), the earliest tick *e* can signal; its radar time is (*i* + *j*)/2 and its radar distance (*j* − *i*)/2. A tick is its own emission and reception.
- The observer *a* on the lattice (left) and the radar domain redrawn at its chart positions, distance across and time up (right). The observer becomes the vertical axis and the lattice unfolds to one side of it.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraWalk[a] -> StandardRed}],
    InfraSubstrateHighlight[InfraMeasurement[g, InfraRadarChart[a], "Subgraph"], {InfraWalk[a] -> StandardRed}]}]]
```

- The chart of this observer is injective: the 49 events get 49 distinct coordinates. Radar time never decreases along an edge, and the ticks sit at {*m*, 0}.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  {coordinates = InfraMeasurement[g, InfraRadarChart[a], "Coordinates"]},
  {Length[coordinates], Length @ Union @ Values[coordinates],
   AllTrue[EdgeList[g], e |-> First[coordinates[First @ e]] <= First[coordinates[Last @ e]]],
   coordinates /@ a === Table[{m, 0}, {m, Length[a]}]}]
```

- The base graph is the order the chart induces on its coordinate cells, drawn at the cells.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  InfraMeasurement[g, InfraRadarChart[a], "BaseGraph"]]
```

## The observer fibration

- The **observer space** is the radar domain fibered over the chart: an [`InfraFibration`](paclet:WolframInstitute/InfraGeometry/ref/InfraFibration) whose total graph is the undirected radar domain and whose projection is the chart. Its fibers are the coordinate cells, the events the observer cannot tell apart, and the bundle functions of InfraGeometry apply to it unchanged. A **section** picks one event in every fiber; it is continuous when it maps base edges to edges.
- For the observer *a* every fiber is a single event: the fibration is a fiber bundle with a point as fiber, and it has exactly one continuous section, the inverse of the chart.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[{0, 0}, {6, 6}]])},
  {fib = InfraMeasurement[g, InfraRadarChart[a], "Fibration"]},
  {Union[VertexCount /@ Values @ InfraFibers[fib]], InfraFibrationQ[fib], InfraFiberBundleQ[fib], Length @ FindInfraSection[fib, All],
   InfraSectionQ[fib, (SeedRandom[1]; RandomInfraSection[fib])]}]
```

### The diagonal fold

- The diagonal {(*m*, *m*)} is a chain at rest in the middle of the lattice. Radar distance is unsigned, so its chart cannot tell left from right: the events (*i*, *j*) and (*j*, *i*) get the same coordinates. The lattice with the diagonal (red) and the events left of it (blue), beside the domain at its chart positions, where the two halves lie on top of each other.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {Select[VertexList[g], v |-> First[v] < Last[v]] -> StandardBlue, InfraWalk[diagonal] -> StandardRed}],
    InfraSubstrateHighlight[InfraMeasurement[g, InfraRadarChart[diagonal], "Subgraph"], {InfraWalk[diagonal] -> StandardRed}]}]]
```

- The fibers are the mirror pairs {(*i*, *j*), (*j*, *i*)} and the single events of the diagonal. The fold is a fibration, every base edge lifts at every point, but no fiber bundle, since the fibers have two sizes. Its two continuous sections are the two sides of the diagonal.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {fib = InfraMeasurement[g, InfraRadarChart[Table[{m, m}, {m, 0, 6}]], "Fibration"]},
  {sides = Sort[Sort @ Values @ First @ #] & /@ FindInfraSection[fib, All]},
  {Union[VertexCount /@ Values @ InfraFibers[fib]], InfraFibrationQ[fib], InfraFiberBundleQ[fib],
   Sort[sides] === Sort[{Select[VertexList[g], v |-> First[v] >= Last[v]], Select[VertexList[g], v |-> First[v] <= Last[v]]}]}]
```

- A second observer unfolds the mirror. The chain {(*m*, *m* + 1)} runs beside the diagonal; on the 36 events both observers chart, the joined chart, the two charts concatenated, is injective, and every fiber is a single event.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {chart = InfraRadarChart[{Table[{m, m}, {m, 0, 6}], Table[{m, m + 1}, {m, 0, 5}]}]},
  {coordinates = InfraMeasurement[g, chart, "Coordinates"]},
  {Length[coordinates], DuplicateFreeQ @ Values[coordinates], Union[VertexCount /@ Values @ InfraFibers @ InfraMeasurement[g, chart, "Fibration"]]}]
```

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}], beside = Table[{m, m + 1}, {m, 0, 5}]},
  InfraSubstrateHighlight[g, {InfraRadarChart[{diagonal, beside}] -> StandardGreen, InfraWalk[diagonal] -> StandardRed, InfraWalk[beside] -> StandardBlue}]]
```

### The cylinder loop

- On the cylinder lattice light can go round the universe. The column {(0, *t*)} is a timelike geodesic; the light ray (0, 0) → (1, 1) → … → (5, 5) leaves it and returns to it at (0, 6), so the five events of the ray have emission tick 1 and reception tick 7 and share the cell {4, 3}. The column (red), its radar domain (green) and the loop (orange), beside the base graph.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {column = Table[{0, t}, {t, 0, 6}]},
  {fib = InfraMeasurement[g, InfraRadarChart[column], "Fibration"]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraRadarChart[column] -> StandardGreen, InfraWalk[column] -> StandardRed,
      Select[Values[VertexList /@ InfraFibers[fib]], f |-> Length[f] > 1] -> StandardOrange}],
    InfraMeasurement[g, InfraRadarChart[column], "BaseGraph"]}]]
```

- Here the observer space is not a fibration. The base edge from the cell {1, 0} of the first tick into the loop's cell {4, 3} lifts at (1, 1), the first event of the ray, and at no other event of the fiber: the loop's interior events are not adjacent to (0, 0).

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {fib = InfraMeasurement[g, InfraRadarChart[Table[{0, t}, {t, 0, 6}]], "Fibration"]},
  {loop = VertexList @ InfraFibers[fib][{4, 3}]},
  {Sort[loop], InfraFibrationQ[fib], Select[loop, v |-> EdgeQ[InfraTotalGraph[fib], UndirectedEdge[{0, 0}, v]]]}]
```

- Being a fibration is thus a property of the substrate as well as of the observer. On the sprinkling, too, the chart of a longest chain identifies events, 23 events on 15 cells, and is no fibration.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {fib = InfraMeasurement[g, InfraRadarChart[a], "Fibration"]},
  {Length @ InfraMeasurement[g, InfraRadarChart[a], "Domain"], Length @ InfraFibers[fib], InfraFibrationQ[fib]}]
```

## Open questions

- The observer space is handed to InfraGeometry as an undirected fibration, because its bundle functions test undirected edges; the causal direction survives only in the `"Subgraph"` and `"BaseGraph"` readings of the chart. Which bundle notions keep their meaning on the directed domain?
- On the sprinkling a single longest chain identifies events and fails the lifting condition. How many observers does a joined chart need before the observer space of a sprinkling becomes a fibration, and how does that number grow with the density?
