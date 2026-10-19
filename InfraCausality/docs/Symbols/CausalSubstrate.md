---
Template: Symbol
Name: CausalSubstrate
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/CausalSubstrate
Keywords: [causal substrate, causal graph, causal set, light-cone lattice, cylinder, sprinkling, Minkowski space, spray graph, percolation, Wolfram model, catalogue]
SeeAlso: [CausalSubstrateStyle, CausalSubstrateCode, RandomCausalGraph, UniversalTime, InfraCausalFuture]
RelatedGuides: [CausalSubstrates]
---

## Usage

<code>[CausalSubstrate]()[*name*, *size*]</code> gives the named causal graph at size `"Small"`, `"Medium"` or `"Large"`, a transitively reduced directed acyclic graph.

<code>[CausalSubstrate]()[*name*]</code> gives the size `"Medium"`.

<code>[CausalSubstrate]()[]</code> lists the names by group, and <code>[CausalSubstrate]()[All]</code> lists them all.

## Details & Options

A causal substrate is the Hasse diagram of a finite causal order: its vertices are the events, its edges the covering pairs *u* ≺ *v* with nothing between, so the order is reachability and every directed path is a chain. Every entry is acyclic, transitively reduced and weakly connected, and it is drawn with time upward in the style [CausalSubstrateStyle]() of its size. [CausalSubstrateCode]() gives the code that builds it; it is the analogue of InfraGeometry's [`InfraSubstrate`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrate) for directed graphs.

| Group | Entries | Construction | Small, Medium, Large |
|---|---|---|---|
| `"Lattice"` | `"DiamondLatticeGraph"` | the product order on {0, …, *n*}², edges (*i*, *j*) → (*i* + 1, *j*), (*i*, *j* + 1); the 1 + 1 light-cone lattice with *x* = (*j* − *i*)/2, *t* = (*i* + *j*)/2 | *n* = 6, 10, 16 |
| | `"CylinderLatticeGraph"` | ℤ*w* × {0, …, *h*}, edges (*k*, *t*) → (*k*, *t* + 1), (*k* + 1 mod *w*, *t* + 1): a light-cone lattice closed in space | *w* = *h* = 6, 10, 16 |
| | `"CubicLatticeGraph"` | the product order on {0, …, *n*}³, the 2 + 1 control | *n* = 3, 5, 7 |
| `"Sprinkling"` | `"MinkowskiSprinkling2D"`, `"MinkowskiSprinkling3D"` | a fixed-seed Poisson sprinkling into the unit causal diamond of 1 + 1 or 2 + 1 Minkowski space ([RandomCausalGraph]()) | 25, 50, 100 events |
| `"Spray"` | `"SquareTilingSprayGraph"`, `"HexagonalTilingSprayGraph"`, `"SquareMeshSprayGraph"` | [`SprayGraph`](paclet:WolframInstitute/InfraGeometry/ref/SprayGraph) of the InfraGeometry substrate from its centre: *u* → *v* when *d*(*c*, *v*) = *d*(*c*, *u*) + 1 | the InfraGeometry sizes |
| `"Random"` | `"PercolationGraph"` | a fixed-seed transitive percolation with *p* = log *n* / *n* | 25, 50, 100 events |

On the diamond lattice the causal order is the product order (*i*, *j*) ≼ (*k*, *l*) ⟺ *i* ≤ *k* and *j* ≤ *l*, the closed light cone of the coordinates; on a sprinkling it is the open light cone *t*' − *t* > |*x*' − *x*| of the sprinkled points. For the lattices, the sprinklings and the percolation an integer *n* in place of a size name gives the lattice of side *n* or *n* events; the cylinder lattice of size *n* has width and height *n*, and a pair {*w*, *h*} sets them apart.

The option `"KeepCoordinates" -> True` replaces the drawing layout by the construction coordinates: (*x*, *t*) on the lattices and the 2D sprinkling. The entries `"CubicLatticeGraph"` and `"MinkowskiSprinkling3D"` keep their full point (*x*, *y*, *t*), and [`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws them in the plane by the cabinet projection (*x*, *y*, *t*) ↦ (*x* + *y*/(2√2), *t* + *y*/(2√2)), time up and the second space axis receding at 45° with half its length, while the substrate itself keeps the 3D point. `Graph` options pass through.

The doc pages use `"DiamondLatticeGraph"`, `"MinkowskiSprinkling2D"` and `"CylinderLatticeGraph"` at size `"Small"` as their three substrates: a flat universe, a random one and a closed one.

Experimental: the `"WolframModel"` group holds the causal graphs of six notable universes of the Wolfram Physics registry, "wm3467", "wm7978", "wm4735", "wm1529", "wm3975" and "wm2216", evolved for a fixed number of events per size and reduced to the Hasse diagram of their causal order. The vertices are the event numbers, a linear extension of the order. The edge lists ship with the paclet as the asset `"WolframModelCausalGraphs"`, so no evolution runs at load time. The causal orders of "wm3467", "wm7978" and "wm4735" are two-dimensional: their largest antichain and their longest chain both grow like the square root of the number of events (for "wm7978" at 100, 300 and 800 events the width is 12, 22 and 37 and the height 18, 29 and 46).

## Basic Examples

The catalogue by group.

```wl
CausalSubstrate[]
```

The lattices, sprinklings, spray graphs and percolation at size "Small".

```wl
GraphicsGrid[
  Partition[Labeled[CausalSubstrate[#, "Small"], #] & /@ Catenate @ Values @ KeyDrop[CausalSubstrate[], "WolframModel"], 3],
  ImageSize -> 720]
```

The three doc substrates in their construction coordinates, with the causal future (red) and past (blue) of an event at height 5.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, 5])},
    InfraSubstrateHighlight[g, {InfraCausalFuture[v] -> Red, InfraCausalPast[v] -> StandardBlue, v}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The two 2 + 1 dimensional entries in their coordinates, drawn by the cabinet projection with the future light cone of their first event.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {InfraFutureLightCone[First @ VertexList[g]] -> Red}]],
  {name, {"CubicLatticeGraph", "MinkowskiSprinkling3D"}}]
```

The number of events and edges of each entry at size "Small".

```wl
Table[{name, VertexCount[#], EdgeCount[#]} & @ CausalSubstrate[name, "Small"], {name, CausalSubstrate[All]}] // Grid
```

The causal graph of the universe "wm3467" at size "Small", with its slice at height 5 and the causal future of event 10.

```wl
With[
  {g = CausalSubstrate["wm3467", "Small"]},
  InfraSubstrateHighlight[g, {InfraSlice[5], InfraCausalFuture[10]}]]
```

## Properties and Relations

Every entry at size "Small" is acyclic, transitively reduced and weakly connected, and its default drawing has every edge pointing upward.

```wl
AllTrue[CausalSubstrate[All], name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {y = AssociationThread[VertexList[g], Last /@ GraphEmbedding[g]]},
    AcyclicGraphQ[g] && EdgeCount[g] == EdgeCount @ TransitiveReductionGraph[g] && WeaklyConnectedGraphQ[g] &&
      AllTrue[EdgeList[g], e |-> y[Last @ e] > y[First @ e]]]]
```

On the diamond lattice the causal order is the product order, and the lattice has (*n* + 1)² events.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  VertexCount[g] == 7^2 &&
    AllTrue[VertexList[g], v |-> Sort @ VertexOutComponent[g, {v}] === Sort @ Select[VertexList[g], w |-> And @@ Thread[v <= w]]]]
```

On the sprinkling the causal order is the light-cone order of the sprinkled points: *u* ≺ *v* exactly when *t*(*v*) − *t*(*u*) > |*x*(*v*) − *x*(*u*)|.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small", "KeepCoordinates" -> True]},
  {c = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  AllTrue[Permutations[VertexList[g], {2}], Apply[{u, v} |->
    MemberQ[VertexOutComponent[g, {u}], v] === (Last[c[v]] - Last[c[u]] > Abs[First[c[v]] - First[c[u]]])]]]
```

On the cylinder lattice every event above the bottom row has two direct predecessors, and the rows are the slices of the universal time.

```wl
With[
  {g = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  AllTrue[Select[VertexList[g], v |-> Last[v] > 0], v |-> VertexInDegree[g, v] == 2] &&
    UniversalTime[g] === AssociationMap[Last, VertexList[g]]]
```

On a spray graph the universal time is the graph distance from the centre of the undirected substrate.

```wl
AllTrue[{"SquareTilingSprayGraph", "HexagonalTilingSprayGraph", "SquareMeshSprayGraph"}, name |->
  With[
    {s = InfraSubstrate[StringReplace[name, "SprayGraph" -> "Graph"], "Small"], g = CausalSubstrate[name, "Small"]},
    {c = First @ GraphCenter[s]},
    UniversalTime[g] === AssociationMap[v |-> GraphDistance[s, c, v], VertexList[g]]]]
```

The held code builds the entry.

```wl
AllTrue[CausalSubstrate[All], name |->
  With[
    {g = CausalSubstrate[name, "Small"], h = ReleaseHold @ CausalSubstrateCode[name, "Small"]},
    VertexList[g] === VertexList[h] && EdgeList[g] === EdgeList[h]]]
```
