---
Template: Symbol
Name: RandomCausalGraph
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/RandomCausalGraph
Keywords: [random causal set, transitive percolation, Rideout-Sorkin, sprinkling, Poisson sprinkling, Minkowski space, acyclic orientation, Hasse diagram, Myrheim-Meyer, ordering fraction]
SeeAlso: [CausalSubstrate, CausalSubstrateStyle, UniversalTime, InfraCausalDiamond]
RelatedGuides: [CausalSubstrates]
---

## Usage

<code>[RandomCausalGraph]()[*n*]</code> gives the Hasse diagram of a transitive percolation on the events 1, …, *n* with link probability log *n* / *n*.

<code>[RandomCausalGraph]()[{*n*, *p*}]</code> gives the Hasse diagram of a transitive percolation with link probability *p*, 0 < *p* < 1.

<code>[RandomCausalGraph]()[{*n*, *m*}]</code>, with *m* an integer, gives the Hasse diagram of an acyclic orientation of a random connected graph with *m* edges.

<code>[RandomCausalGraph]()[*n*, Method -> {"Sprinkling", *d*}]</code> gives the Hasse diagram of *n* points sprinkled into the unit causal diamond of *d*-dimensional Minkowski space.

## Details & Options

Every form returns a random finite order as its Hasse diagram, a transitively reduced directed acyclic graph on the events 1, …, *n*, numbered in a linear extension of the order, so every edge *i* → *j* has *i* < *j*. The graph has the [CausalSubstrateStyle]() of its size. Randomness comes from the ambient generator: `SeedRandom` before the call fixes the graph. `Graph` options pass through.

| Form | Order |
|---|---|
| *n* | transitive percolation (Rideout–Sorkin) with *p* = log *n* / *n*; the same as `Method -> "Percolation"` |
| {*n*, *p*} | each pair *i* < *j* is linked independently with probability *p*, and the order is the transitive closure of the links |
| {*n*, *m*} | a random connected graph with *n* vertices and *m* edges (clipped to [*n* − 1, *n*(*n* − 1)/2]), oriented acyclically; the Hasse diagram keeps fewer than *m* edges when some are implied |
| *n*, `Method -> {"Sprinkling", d}` | *n* points uniform in the diamond {(*x*, *t*) : \|*x*\| < min(*t*, 1 − *t*)} of *d*-dimensional Minkowski space, *x* ∈ ℝ^(*d*−1), with *u* ≺ *v* iff *t*(*v*) − *t*(*u*) > \|*x*(*v*) − *x*(*u*)\|; `Method -> "Sprinkling"` is *d* = 2 |

In a transitive percolation the probability that 1 ≺ 2 is *p*, since only a direct link can relate them, and the probability that 1 ≺ 3 is 1 − (1 − *p*)(1 − *p*²), a direct link or a path through 2. A sprinkling has `VertexCoordinates` the sprinkled point {*x*1, …, *x*(*d* − 1), *t*} for *d* ≤ 3, and {*x*1, *t*} beyond; a sprinkling is the standard model of a causal set that is faithfully embedded in Minkowski space.

The ordering fraction *r* = *R* / (*n* choose 2) of an order, *R* the number of related pairs, estimates the dimension of a sprinkling: Myrheim and Meyer showed that its expectation in the causal diamond of *d*-dimensional Minkowski space is Γ(*d* + 1) Γ(*d*/2) / (2 Γ(3*d*/2)), which is 1/2 for *d* = 2, 8/35 for *d* = 3 and 1/10 for *d* = 4. The experimental reading `"OrderingFraction"` of [InfraCausalDiamond]() computes it, and `"MyrheimMeyerDimension"` inverts the formula.

## Basic Examples

The four forms on 25 events: the default percolation, a percolation with *p* = 0.2, an orientation of a graph with 40 edges and a two-dimensional sprinkling.

```wl
GraphicsRow[{
  (SeedRandom[1]; RandomCausalGraph[25]),
  (SeedRandom[1]; RandomCausalGraph[{25, 0.2}]),
  (SeedRandom[1]; RandomCausalGraph[{25, 40}]),
  (SeedRandom[1]; RandomCausalGraph[25, Method -> {"Sprinkling", 2}])}]
```

A sprinkling of 100 points into the two-dimensional diamond, in its coordinates, with the causal future of event 20.

```wl
With[
  {g = (SeedRandom[2]; RandomCausalGraph[100, Method -> {"Sprinkling", 2}])},
  InfraSubstrateHighlight[g, {InfraCausalFuture[20] -> Red, 20}]]
```

The universal foliation of a percolation of 60 events with *p* = 0.08.

```wl
With[
  {g = (SeedRandom[3]; RandomCausalGraph[{60, 0.08}])},
  InfraSubstrateHighlight[g, UniversalFoliation[g]]]
```

The ordering fractions of ten sprinklings of 200 points in two and in three dimensions, beside the Myrheim–Meyer values 1/2 and 8/35.

```wl
Table[
  Mean @ Table[
    With[{g = (SeedRandom[seed]; RandomCausalGraph[200, Method -> {"Sprinkling", d}])}, N @ InfraMeasurement[g, InfraCausalDiamond[VertexList[g]], "OrderingFraction"]],
    {seed, 10}],
  {d, {2, 3}}]
```

## Options

### Method

`Method -> "Percolation"` is the default form, and `"Sprinkling"` is the two-dimensional sprinkling.

```wl
{(SeedRandom[4]; EdgeList @ RandomCausalGraph[30, Method -> "Percolation"]) === (SeedRandom[4]; EdgeList @ RandomCausalGraph[30]),
 (SeedRandom[4]; EdgeList @ RandomCausalGraph[30, Method -> "Sprinkling"]) === (SeedRandom[4]; EdgeList @ RandomCausalGraph[30, Method -> {"Sprinkling", 2}])}
```

## Properties and Relations

Every form gives a transitively reduced acyclic graph on 1, …, *n* with every edge going up in the numbering.

```wl
AllTrue[Range[3], seed |->
  AllTrue[{
      (SeedRandom[seed]; RandomCausalGraph[30]), (SeedRandom[seed]; RandomCausalGraph[{30, 0.15}]),
      (SeedRandom[seed]; RandomCausalGraph[{30, 50}]), (SeedRandom[seed]; RandomCausalGraph[30, Method -> {"Sprinkling", 3}])},
    g |-> VertexList[g] === Range[30] && AcyclicGraphQ[g] && EdgeCount[g] == EdgeCount @ TransitiveReductionGraph[g] &&
      AllTrue[EdgeList[g], e |-> First[e] < Last[e]]]]
```

The percolation probabilities: over 2000 percolations of 5 events with *p* = 0.3, the frequencies of 1 ≺ 2 and of 1 ≺ 3 are within 0.04 of *p* = 0.3 and of 1 − (1 − *p*)(1 − *p*²) = 0.363.

```wl
With[
  {p = 0.3},
  {gs = (SeedRandom[7]; Table[RandomCausalGraph[{5, p}], 2000])},
  Abs[Mean[Boole[GraphDistance[#, 1, 2] < Infinity] & /@ gs] - p] < 0.04 &&
    Abs[Mean[Boole[GraphDistance[#, 1, 3] < Infinity] & /@ gs] - (1 - (1 - p) (1 - p^2))] < 0.04]
```

The extremes of the percolation: *p* near 1 gives a chain, *p* near 0 an antichain.

```wl
EdgeList[RandomCausalGraph[{6, 1 - 10^-12}]] === DirectedEdge @@@ Partition[Range[6], 2, 1] && EdgeCount[RandomCausalGraph[{6, 10.^-12}]] == 0
```

The sprinkled order is the light-cone order of the sprinkled points, in two and in three dimensions.

```wl
AllTrue[{2, 3}, d |->
  With[
    {g = (SeedRandom[1]; RandomCausalGraph[30, Method -> {"Sprinkling", d}])},
    {c = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    AllTrue[Permutations[VertexList[g], {2}], Apply[{u, v} |->
      MemberQ[VertexOutComponent[g, {u}], v] === (Last[c[v]] - Last[c[u]] > Norm[Most[c[v]] - Most[c[u]]])]]]]
```

The Myrheim–Meyer ordering fractions: the mean ordering fraction of ten sprinklings of 200 points is within 0.02 of 1/2 in two dimensions and of 8/35 in three.

```wl
AllTrue[{{2, 1/2}, {3, 8/35}}, Apply[{d, r} |->
  Abs[r - Mean @ Table[
    With[{g = (SeedRandom[seed]; RandomCausalGraph[200, Method -> {"Sprinkling", d}])}, InfraMeasurement[g, InfraCausalDiamond[VertexList[g]], "OrderingFraction"]],
    {seed, 10}]] < 0.02]]
```

The orientation form is connected, and its Hasse diagram has at most *m* edges.

```wl
AllTrue[Range[5], seed |->
  With[
    {g = (SeedRandom[seed]; RandomCausalGraph[{25, 40}])},
    VertexCount[g] == 25 && WeaklyConnectedGraphQ[g] && EdgeCount[g] <= 40]]
```
