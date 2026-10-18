---
Template: Symbol
Name: InfraObserver
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraObserver
Keywords: [observer, saturated chain, clock, Hasse diagram, timelike curve, particle, symbolic object]
SeeAlso: [RandomInfraObserver, InfraObserverQ, InfraWorldline, InfraChainQ, InfraMessageFunction, InfraRadarChart, InfraCausalDiamond]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraObserver]()[*p*, *q*]</code> is the family of observers from *p* to *q*: every saturated chain from *p* to *q* at once.

<code>[InfraObserver]()[]</code> is the family of inextendible saturated chains of the whole graph, each from a source to a sink.

## Details & Options

Definition: an observer from *p* to *q* is a saturated chain *p* = *e*0 ≺ *e*1 ≺ … ≺ *ek* = *q*: each pair of consecutive events is a covering pair, an edge of the Hasse diagram, so no event lies strictly between them.

An observer is the discrete analogue of a timelike curve with a clock: its events are the ticks, and their positions along the chain are the readings of the clock. A saturated chain skips no event it could have passed through, so the clock ticks at every event on the way. Observers between the same two events need not have the same number of ticks; the longest ones are the worldlines of [InfraWorldline](), the timelike geodesics.

The head holds its two events and computes nothing. Its graph, <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *o*, "Graph"]</code>, is the Hasse diagram of the graph restricted to the diamond [*p*, *q*]. Its paths from *p* to *q* are exactly the saturated chains, each once, so `"Faithful"` is `True`, and every count is read off that graph by dynamic programming.

| Property | Value |
|---|---|
| `"Graph"` | the Hasse diagram on the diamond [*p*, *q*] |
| `"Length"` | the sorted distinct numbers of edges of the observers, one integer when they agree |
| `"Cardinality"` | the number of observers |
| `"VertexDensity"` | for each event, the number of observers through it |
| `"EdgeDensity"` | for each edge, the number of observers through it |
| `"Faithful"` | `True` |

A member is a vertex list in causal order; [RandomInfraObserver]() draws members uniformly, and [InfraObserverQ]() recognises one. Observers are the clocks of the Infra Observers guide: [InfraMessageFunction]() and [InfraRadarChart]() take them as arguments.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Observer | A future-directed timelike curve; the proper time along it is the reading of the clock it carries. |
| Causal sets | Saturated chain | A chain whose consecutive elements are links, pairs with no element between them. |
| EPS | Particle | The worldline of a massive particle, a curve whose parametrisation is a clock; the particles generate the causal structure. |

## Basic Examples

The observers from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraObserver[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The number of observers beside the number of worldlines between the same events. On the two lattices every saturated chain is longest; on the sprinkling it is not.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {InfraMeasurement[g, InfraObserver[p, q], "Cardinality"], InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the sprinkling the observers between two events carry clocks of different lengths: the shortest observer beside a worldline.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = RandomInfraObserver[g, InfraObserver[p, q], All]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraWalk[First @ MinimalBy[members, Length]]}],
    InfraSubstrateHighlight[g, {InfraWalk[First @ MaximalBy[members, Length]]}]}]]
```

The distinct numbers of ticks of the observers on the sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  InfraMeasurement[g, InfraObserver[p, q], "Length"]]
```

Every inextendible observer of the sprinkling, from a source to a sink, drawn at once.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, {InfraObserver[]}]]
```

## Properties and Relations

Every member passes [InfraObserverQ](), the cardinality is the number of members, and every worldline is an observer.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[UniversalTime[g]] - 1]]])},
    {members = RandomInfraObserver[g, InfraObserver[p, q], All]},
    InfraObserverQ[g, members] &&
      Length[members] == InfraMeasurement[g, InfraObserver[p, q], "Cardinality"] &&
      SubsetQ[members, RandomInfraWorldline[g, InfraWorldline[p, q], All]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Dropping an inner tick leaves a chain that is no longer saturated: it passes [InfraChainQ]() and fails [InfraObserverQ]().

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {chain = (SeedRandom[1]; RandomInfraObserver[g, InfraObserver[{0, 0}, {3, 6}]])},
  {InfraChainQ[g, Delete[chain, 3]], InfraObserverQ[g, Delete[chain, 3]]}]
```

The observers between two events all run inside their causal diamond.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  SubsetQ[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], Union @@ RandomInfraObserver[g, InfraObserver[p, q], All]]]
```
