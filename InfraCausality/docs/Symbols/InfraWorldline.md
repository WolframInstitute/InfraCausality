---
Template: Symbol
Name: InfraWorldline
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraWorldline
Keywords: [worldline, saturated chain, observer, clock, Hasse diagram, timelike curve, particle, symbolic object]
SeeAlso: [RandomInfraWorldline, InfraWorldlineQ, InfraTimelikeGeodesic, InfraChainQ, InfraMessageFunction, InfraRadarCoordinates, InfraCausalDiamond]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraWorldline]()[*p*, *q*]</code> is the family of worldlines from *p* to *q*: every saturated chain from *p* to *q* at once.

<code>[InfraWorldline]()[]</code> is the family of inextendible worldlines of the whole graph, the saturated chains from a source to a sink.

## Details & Options

Definition: a worldline from *p* to *q* is a saturated chain *p* = *e*0 ≺ *e*1 ≺ … ≺ *ek* = *q*: each pair of consecutive events is a covering pair, an edge of the Hasse diagram, so no event lies strictly between them.

A worldline is the discrete analogue of a future-directed timelike curve: a saturated chain skips no event it could have passed through. An *observer* is a worldline whose positions are read as the ticks of a clock, the role a worldline plays in the Infra Observers guide. Worldlines between the same two events need not have the same number of events; the longest ones are the timelike geodesics of [InfraTimelikeGeodesic]().

The head holds its two events and computes nothing. Its graph, <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, *w*, "Graph"]</code>, is the Hasse diagram of the graph restricted to the diamond [*p*, *q*]. Its paths from *p* to *q* are exactly the saturated chains, each once, so `"Faithful"` is `True`, and every count is read off that graph by dynamic programming.

| Property | Value |
|---|---|
| `"Graph"` | the Hasse diagram on the diamond [*p*, *q*] |
| `"Length"` | the sorted distinct numbers of edges of the worldlines, one integer when they agree |
| `"Cardinality"` | the number of worldlines |
| `"VertexDensity"` | for each event, the number of worldlines through it |
| `"EdgeDensity"` | for each edge, the number of worldlines through it |
| `"Faithful"` | `True` |

A member is a vertex list in causal order; [RandomInfraWorldline]() draws members uniformly, and [InfraWorldlineQ]() recognises one. As observers, worldlines are the clocks of the Infra Observers guide: [InfraMessageFunction]() and [InfraRadarCoordinates]() take them as arguments.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Worldline | A future-directed timelike curve; read as an observer, the proper time along it is the reading of the clock it carries. |
| Causal sets | Saturated chain | A chain whose consecutive elements are links, pairs with no element between them. |
| EPS | Particle | The worldline of a massive particle, a curve whose parametrisation is a clock; the particles generate the causal structure. |

## Basic Examples

The worldlines from an event at height 1 to an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraWorldline[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The number of worldlines beside the number of timelike geodesics between the same events. On the two lattices every saturated chain is longest; on the sprinkling it is not.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    {InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"], InfraMeasurement[g, InfraTimelikeGeodesic[p, q], "Cardinality"]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the sprinkling the worldlines between two events have different numbers of events: the shortest worldline beside a timelike geodesic.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraWalk[First @ MinimalBy[members, Length]]}],
    InfraSubstrateHighlight[g, {InfraWalk[First @ MaximalBy[members, Length]]}]}]]
```

The distinct numbers of edges of the worldlines on the sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  InfraMeasurement[g, InfraWorldline[p, q], "Length"]]
```

Every inextendible worldline of the sprinkling, from a source to a sink, drawn at once.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  InfraSubstrateHighlight[g, {InfraWorldline[]}]]
```

## Properties and Relations

Every member passes [InfraWorldlineQ](), the cardinality is the number of members, and every timelike geodesic is a worldline.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    {members = RandomInfraWorldline[g, InfraWorldline[p, q], All]},
    InfraWorldlineQ[g, members] &&
      Length[members] == InfraMeasurement[g, InfraWorldline[p, q], "Cardinality"] &&
      SubsetQ[members, RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q], All]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Dropping an inner tick leaves a chain that is no longer saturated: it passes [InfraChainQ]() and fails [InfraWorldlineQ]().

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {chain = (SeedRandom[1]; RandomInfraWorldline[g, InfraWorldline[{0, 0}, {3, 6}]])},
  {InfraChainQ[g, Delete[chain, 3]], InfraWorldlineQ[g, Delete[chain, 3]]}]
```

The worldlines between two events all run inside their causal diamond.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  SubsetQ[Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], Union @@ RandomInfraWorldline[g, InfraWorldline[p, q], All]]]
```
