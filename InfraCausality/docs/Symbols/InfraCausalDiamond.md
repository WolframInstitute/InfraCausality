---
Template: Symbol
Name: InfraCausalDiamond
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalDiamond
Keywords: [causal diamond, Alexandrov interval, causal interval, order interval, causal hull, convex set, interval volume, ordering fraction, Myrheim-Meyer dimension, midpoint scaling, interval abundances, Benincasa-Dowker action, discrete d'Alembertian, symbolic object]
SeeAlso: [InfraCausalDiamondQ, InfraCausalFuture, InfraCausalPast, InfraTimelikeGeodesic, InfraWorldline, InfraRadarCoordinates]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalDiamond]()[*p*, *q*]</code> is the causal diamond of the events *p* and *q*: every event that lies after *p* and before *q*.

<code>[InfraCausalDiamond]()[{*v1*, *v2*, …}]</code> is the causal hull of a set of events: every event that lies after one of them and before one of them.

## Details & Options

Definition: the causal diamond of two events *p* and *q* of a directed acyclic graph is [*p*, *q*] = *J*⁺(*p*) ∩ *J*⁻(*q*) = {*e* : *p* ≼ *e* ≼ *q*}, the Alexandrov interval of the causal order.

It is empty unless *p* ≼ *q*, and it is the single event *p* when *p* = *q*. It is convex: with two of its events *u* ≼ *w* it contains every event between them. Every causal chain from *p* to *q* runs inside it, so it carries the worldlines and the timelike geodesics between its tips, and it is the radar domain of an observer from *p* to *q*.

The causal hull of a set *S* is *J*⁺(*S*) ∩ *J*⁻(*S*), the smallest convex set containing *S*. The hull of a chain from *p* to *q* is the diamond [*p*, *q*].

The head holds its tips and computes nothing. [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) reads it on a graph:

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on every event of the diamond, keys sorted |
| `"EdgeDensity"` | 1 on every edge between two events of the diamond |
| `"Subgraph"` | the subgraph induced on the diamond |
| `"CountingMeasure"` | the interval volume, the number of events of the diamond |
| `"Cardinality"` | 1: the diamond is a set, and its support is its only member |
| `"Faithful"` | `True` |

The interval volume is the quantity causal-set theory reads proper time and dimension from: in a sprinkling of density ρ into *d*-dimensional Minkowski space the expected number of events of [*p*, *q*] is ρ times the spacetime volume of the diamond, which is proportional to the *d*-th power of the proper time between the tips.

A set head has one member, its support, so no sampler draws it. The three readings of the diamond on a graph are <code>[`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalDiamond]()[*p*, *q*], "Subgraph"]</code> (InfraGeometry), the induced subgraph; <code>Keys @ [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement)[*g*, [InfraCausalDiamond]()[*p*, *q*], "VertexDensity"]</code>, the sorted vertex list; and <code>[`RandomInfraPoint`](paclet:WolframInstitute/InfraGeometry/ref/RandomInfraPoint)[*g*, [InfraCausalDiamond]()[*p*, *q*], *n*]</code> (InfraGeometry), *n* distinct random events of it. [InfraCausalDiamondQ]() recognises a vertex set that is the diamond of its least and greatest events.

Experimental: the causal-set estimators are further readings of the diamond, on its *N* events with the order restricted to them. *R* is the number of related pairs *x* ≺ *y* of the diamond and *N*<sub>*k*</sub> the number of related pairs with exactly *k* events strictly between them, so *N*<sub>0</sub> counts the links.

| Property | Value |
|---|---|
| `"OrderingFraction"` | *r* = *R* / (*N* choose 2), the fraction of related pairs, exact |
| `"MyrheimMeyerDimension"` | the *d* with Γ(*d* + 1) Γ(*d*/2) / (2 Γ(3*d*/2)) = *r*, the dimension of the Minkowski space whose sprinkled intervals have ordering fraction *r*: *r* = 1, 1/2, 8/35, 1/10 at *d* = 1, 2, 3, 4; it is 1 on a chain and ∞ on an antichain |
| `"MidpointScalingDimension"` | log<sub>2</sub>(*N* / *N*′), where *N*′ is the largest over the events *m* of the smaller of the cardinalities of *J*⁻(*m*) and *J*⁺(*m*) within the diamond: halving the proper time divides the volume by 2<sup>*d*</sup> |
| `"IntervalAbundances"` | the association from *k* to *N*<sub>*k*</sub>, for *k* = 0, …, *N* − 2 |
| `"BenincasaDowkerDAlembertian"` | the matrix of the Benincasa–Dowker operator *B* in the basis of the diamond's events, in the order of the keys of `"VertexDensity"`, with ℓ = 1 |
| `"BenincasaDowkerRicci"` | the association from each event *x* to *R*(*x*) = −2 (*B* **1**)(*x*), the discrete scalar curvature |
| `"BenincasaDowkerAction"` | *S* = ½ Σ<sub>*x*</sub> *R*(*x*), the Benincasa–Dowker action in units ħ = ℓ = 1 |

The last three take the option `"Dimension" -> 2 | 4` as a fourth argument of `InfraMeasurement`. In two dimensions *B*φ(*x*) = 4 (−½ φ(*x*) + Σ<sub>1</sub> − 2 Σ<sub>2</sub> + Σ<sub>3</sub>) and in four *B*φ(*x*) = (4/√6)(−φ(*x*) + Σ<sub>1</sub> − 9 Σ<sub>2</sub> + 16 Σ<sub>3</sub> − 8 Σ<sub>4</sub>), where Σ<sub>*i*</sub> is the sum of φ over the *i*-th past layer of *x*, the events *y* ≺ *x* of the diamond with *i* − 1 events strictly between (Benincasa and Dowker 2010, Eqs. 2, 3 and 10). The operator is retarded: row *x* of the matrix is supported on *J*⁻(*x*). In a sprinkling into a curved spacetime its mean tends to (□ − ½ *R*) φ, which is why *R*(*x*) = *B*(−2)(*x*); summing gives *S*<sub>2</sub> = 2 (*N* − 2 *N*<sub>0</sub> + 4 *N*<sub>1</sub> − 2 *N*<sub>2</sub>) and *S*<sub>4</sub> = (4/√6)(*N* − *N*<sub>0</sub> + 9 *N*<sub>1</sub> − 16 *N*<sub>2</sub> + 8 *N*<sub>3</sub>), the alternating sums of Benincasa and Dowker's Eqs. 13 and 14 with their order-one prefactors restored. On a chain of *N* events *S*<sub>2</sub> = 2 *N* and *S*<sub>4</sub> = (4/√6)(*N* − 1). On *N* points sprinkled into a flat two-dimensional causal diamond the mean of *S*<sub>2</sub> is exactly 2 for every *N* (Brightwell's theorem, quoted by Benincasa, Dowker and Schmitzer 2011), while its standard deviation grows like 2 *N*: the unsmeared operator fluctuates, and the mean curvature 2 *S* / *N* of a flat diamond is 4 / *N* in expectation.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| Minkowski space | Causal diamond | The intersection *J*⁺(*p*) ∩ *J*⁻(*q*) of the future of *p* and the past of *q*, a double cone. |
| Causal sets | Order interval | The interval [*p*, *q*] = {*x* : *p* ≼ *x* ≼ *q*}; its cardinality estimates the spacetime volume between *p* and *q*. |
| Alexandrov topology | Alexandrov interval | The open intervals *I*⁺(*p*) ∩ *I*⁻(*q*) form the base of the Alexandrov topology, which equals the manifold topology in a strongly causal spacetime. |

## Basic Examples

The causal diamond between an event at height 1 and an event of its future one slice below the top, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[Max[CausalHeight[g]] - 1]]])},
    InfraSubstrateHighlight[g, {InfraCausalDiamond[p, q], p, q}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The diamond is the overlap of the causal future of its lower tip and the causal past of its upper tip.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCausalFuture[p], InfraCausalPast[q]}],
    InfraSubstrateHighlight[g, {InfraCausalDiamond[p, q], p, q}]}]]
```

The causal hull of three events of the diamond lattice, the smallest convex set that contains them: the union of the diamonds between the comparable pairs. The two upper events are incomparable, so the hull has two arms.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {s = {{0, 3}, {3, 4}, {1, 6}}},
  InfraSubstrateHighlight[g, {InfraCausalDiamond[s], s}]]
```

The interval volume of the diamonds from the bottom event of the diamond lattice to every event of the slice at height 6.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  Table[InfraMeasurement[g, InfraCausalDiamond[{0, 0}, q], "CountingMeasure"], {q, Keys @ InfraMeasurement[g, InfraSlice[6], "VertexDensity"]}]]
```

## Scope

### Experimental readings

The ordering fraction of the full diamond lattice, exact: with *n* + 1 events on a side, the related pairs are the comparable pairs of a product of two chains, ((*n* + 1)(*n* + 2)/2)² − (*n* + 1)² of them. It tends to 1/2, the Minkowski value, but slowly.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  Table[{n, InfraMeasurement[g, InfraCausalDiamond[{0, 0}, {n, n}], "OrderingFraction"]}, {n, 1, 6}]]
```

A sprinkling of 300 events into the two-dimensional flat diamond, read as one causal set: the ordering fraction is near 1/2, both dimension estimators near 2, and the action an integer that fluctuates from seed to seed around its mean 2.

```wl
SeedRandom[1];
With[
  {g = RandomCausalGraph[300, Method -> {"Sprinkling", 2}]},
  InfraMeasurement[g, InfraCausalDiamond[VertexList[g]], {"OrderingFraction", "MyrheimMeyerDimension", "MidpointScalingDimension", "BenincasaDowkerAction"}]]
```

The same in three dimensions: the ordering fraction is near 8/35 and the estimators near 3.

```wl
SeedRandom[1];
With[
  {g = RandomCausalGraph[300, Method -> {"Sprinkling", 3}]},
  InfraMeasurement[g, InfraCausalDiamond[VertexList[g]], {"OrderingFraction", "MyrheimMeyerDimension", "MidpointScalingDimension"}]]
```

The interval abundances of the 4 × 4 diamond of the lattice: 24 links, 16 pairs with one event between, and the one pair of tips with all 14 others between.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  InfraMeasurement[g, InfraCausalDiamond[{0, 0}, {3, 3}], "IntervalAbundances"]]
```

The Benincasa–Dowker operator of the 2 × 2 diamond: −2 on the diagonal, 4 on each link below the diagonal in the sorted event order, and the discrete curvature it assigns to each event.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {d = InfraCausalDiamond[{0, 0}, {1, 1}]},
  {Normal @ InfraMeasurement[g, d, "BenincasaDowkerDAlembertian"], InfraMeasurement[g, d, "BenincasaDowkerRicci"]}]
```

## Options

### Dimension

The Benincasa–Dowker readings use the two-dimensional layer coefficients by default; `"Dimension" -> 4` uses the four-dimensional ones. On a chain of ten events the actions are 2 *N* = 20 and (4/√6)(*N* − 1) = 6 √6.

```wl
With[
  {g = PathGraph[Range[10], DirectedEdges -> True]},
  {InfraMeasurement[g, InfraCausalDiamond[1, 10], "BenincasaDowkerAction"], InfraMeasurement[g, InfraCausalDiamond[1, 10], "BenincasaDowkerAction", "Dimension" -> 4]}]
```

## Properties and Relations

The diamond is the intersection of the causal future of *p* and the causal past of *q*, for every pair of events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Tuples[VertexList[g], 2], Apply[{p, q} |->
      Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"] === Intersection[Keys @ InfraMeasurement[g, InfraCausalFuture[p], "VertexDensity"], Keys @ InfraMeasurement[g, InfraCausalPast[q], "VertexDensity"]]]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

On the diamond lattice the diamond of {*i*, *j*} ≼ {*k*, *l*} is a rectangle of (*k* − *i* + 1)(*l* − *j* + 1) events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  AllTrue[Select[Tuples[VertexList[g], 2], Apply[{p, q} |-> And @@ Thread[p <= q]]], Apply[{p, q} |->
    InfraMeasurement[g, InfraCausalDiamond[p, q], "CountingMeasure"] == Times @@ (q - p + 1)]]]
```

The diamond is convex: an event between two of its events is one of its events.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[6]]])},
  {diamond = Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"]},
  AllTrue[Tuples[diamond, 2], Apply[{u, w} |-> SubsetQ[diamond, Keys @ InfraMeasurement[g, InfraCausalDiamond[u, w], "VertexDensity"]]]]]
```

The causal hull of every timelike geodesic from *p* to *q* is the diamond of its tips.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  {p = (SeedRandom[2]; RandomInfraPoint[g, InfraSlice[0]])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
  AllTrue[RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[p, q], All], chain |->
    Keys @ InfraMeasurement[g, InfraCausalDiamond[chain], "VertexDensity"] === Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"]]]
```

The discrete curvature is the operator applied to the constant field −2, and the action is half its total, in both dimensions.

```wl
SeedRandom[1];
With[
  {g = RandomCausalGraph[300, Method -> {"Sprinkling", 2}]},
  {d = InfraCausalDiamond[VertexList[g]]},
  AllTrue[{2, 4}, dim |->
    With[
      {B = InfraMeasurement[g, d, "BenincasaDowkerDAlembertian", "Dimension" -> dim], ricci = InfraMeasurement[g, d, "BenincasaDowkerRicci", "Dimension" -> dim]},
      Union @ Simplify[Values[ricci] + 2 B . ConstantArray[1, 300]] === {0} &&
        Simplify[InfraMeasurement[g, d, "BenincasaDowkerAction", "Dimension" -> dim] - Total[ricci]/2] === 0]]]
```

The Myrheim–Meyer dimension inverts the exact ordering fractions: 1/2 gives 2, 8/35 gives 3, 1/10 gives 4.

```wl
With[
  {star = Graph[{0 -> 1, 0 -> 2, 0 -> 3}], sparse = Graph[Range[15], Join[Thread[Range[6] -> Range[2, 7]], {8 -> 9, 9 -> 10}]], lone = Graph[Range[5], {1 -> 2}]},
  Table[InfraMeasurement[g, InfraCausalDiamond[VertexList[g]], {"OrderingFraction", "MyrheimMeyerDimension"}], {g, {star, sparse, lone}}]]
```
