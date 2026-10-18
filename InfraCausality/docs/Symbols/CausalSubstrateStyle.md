---
Template: Symbol
Name: CausalSubstrateStyle
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/CausalSubstrateStyle
Keywords: [style, graph options, layout, layered digraph, time upward, causal substrate]
SeeAlso: [CausalSubstrate, CausalSubstrateCode, RandomCausalGraph]
RelatedGuides: [CausalSubstrates]
---

## Usage

<code>[CausalSubstrateStyle]()[*size*]</code> gives the `Graph` options a causal substrate of size `"Small"`, `"Medium"` or `"Large"` is drawn with.

<code>[CausalSubstrateStyle]()[*name*, *size*]</code> gives those of a named substrate.

## Details & Options

The style is a list of `Graph` option rules: `EdgeStyle` and `VertexStyle` in `StandardGray` with arrowheads, a `VertexSize` that shrinks with the size so that larger graphs stay legible, and `GraphLayout -> {"LayeredDigraphEmbedding", "Orientation" -> Bottom}`, which draws a directed acyclic graph in layers with time upward. It is the analogue of InfraGeometry's [`InfraSubstrateStyle`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateStyle).

The style depends on the size alone: every named substrate of one size has the same style. [CausalSubstrate]() applies it, and so does [RandomCausalGraph](), with the size chosen by the number of events (`"Small"` up to 250, `"Medium"` up to 800, `"Large"` beyond). A layout given by `VertexCoordinates`, as under `"KeepCoordinates" -> True`, takes precedence over the layered embedding.

## Basic Examples

The style of a "Small" substrate.

```wl
CausalSubstrateStyle["Small"]
```

A plain directed graph drawn in the style of each size.

```wl
With[
  {g = Graph[Flatten @ Table[{{i, j} -> {i + 1, j}, {i, j} -> {i, j + 1}}, {i, 0, 3}, {j, 0, 3}]]},
  GraphicsRow @ Table[Graph[g, CausalSubstrateStyle[size]], {size, {"Small", "Medium", "Large"}}]]
```

The vertex sizes of the three sizes.

```wl
Table[VertexSize /. CausalSubstrateStyle[size], {size, {"Small", "Medium", "Large"}}]
```

## Properties and Relations

The style is a list of `Graph` option rules, the same for every named substrate of a size, with time upward.

```wl
AllTrue[{"Small", "Medium", "Large"}, size |->
  With[
    {style = CausalSubstrateStyle[size]},
    MatchQ[style, {(_Rule | _RuleDelayed) ..}] && SubsetQ[Keys @ Options[Graph], Keys[style]] &&
      AllTrue[CausalSubstrate[All], name |-> CausalSubstrateStyle[name, size] === style] &&
      (GraphLayout /. style) === {"LayeredDigraphEmbedding", "Orientation" -> Bottom}]]
```

A random causal graph of 25 events carries the "Small" style, and in that style every edge points upward.

```wl
With[
  {g = (SeedRandom[1]; RandomCausalGraph[25])},
  {y = AssociationThread[VertexList[g], Last /@ GraphEmbedding[g]]},
  (GraphLayout /. Options[g, GraphLayout]) === (GraphLayout /. CausalSubstrateStyle["Small"]) &&
    AllTrue[EdgeList[g], e |-> y[Last @ e] > y[First @ e]]]
```
