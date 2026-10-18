---
Template: Symbol
Name: CausalSubstrateCode
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/CausalSubstrateCode
Keywords: [held code, construction, reproducibility, seed, causal substrate]
SeeAlso: [CausalSubstrate, CausalSubstrateStyle, RandomCausalGraph]
RelatedGuides: [CausalSubstrates]
---

## Usage

<code>[CausalSubstrateCode]()[*name*, *size*]</code> gives the held code that builds <code>[CausalSubstrate]()[*name*, *size*]</code>.

<code>[CausalSubstrateCode]()[*name*]</code> gives the code of the size `"Medium"`.

## Details & Options

The code is wrapped in `HoldForm`, so it displays as it would be typed and `ReleaseHold` evaluates it. It contains only public symbols: a lattice is an explicit `Graph` of `Table`s, a sprinkling or a percolation a [RandomCausalGraph]() call inside `BlockRandom[SeedRandom[seed]; …]`, a spray graph a [`SprayGraph`](paclet:WolframInstitute/InfraGeometry/ref/SprayGraph) of an [`InfraSubstrate`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrate), and a Wolfram model entry the import of the bundled asset. The released code gives the vertices and edges of the substrate; [CausalSubstrate]() adds the drawing style.

It takes the options of [CausalSubstrate](): with `"KeepCoordinates" -> True` the code is wrapped in a `Graph` with the construction coordinates as `VertexCoordinates`, and `Graph` options are added to that wrapper.

## Basic Examples

The code of the sprinkling: a fixed seed and a call to the random sprinkling.

```wl
CausalSubstrateCode["MinkowskiSprinkling2D", "Small"]
```

The code of the diamond lattice.

```wl
CausalSubstrateCode["DiamondLatticeGraph", "Small"]
```

The code of a spray graph and of a Wolfram model entry.

```wl
{CausalSubstrateCode["SquareTilingSprayGraph", "Small"], CausalSubstrateCode["wm3467", "Small"]}
```

Released, the code of the cylinder lattice is the substrate.

```wl
With[
  {h = ReleaseHold @ CausalSubstrateCode["CylinderLatticeGraph", "Small"]},
  InfraSubstrateHighlight[h, {InfraSlice[3]}]]
```

## Properties and Relations

For every name the released code has the vertices and the edges of the substrate.

```wl
AllTrue[CausalSubstrate[All], name |->
  With[
    {g = CausalSubstrate[name, "Small"], h = ReleaseHold @ CausalSubstrateCode[name, "Small"]},
    VertexList[g] === VertexList[h] && EdgeList[g] === EdgeList[h]]]
```

The code is free of private symbols, and the seeded codes rebuild the same random substrate however the ambient generator is seeded.

```wl
AllTrue[CausalSubstrate[All], name |->
  FreeQ[CausalSubstrateCode[name, "Small"], s_Symbol /; StringContainsQ[Context[Unevaluated @ s], "Private"], Infinity, Heads -> True]] &&
  AllTrue[{"MinkowskiSprinkling2D", "MinkowskiSprinkling3D", "PercolationGraph"}, name |->
    EdgeList[(SeedRandom[1]; ReleaseHold @ CausalSubstrateCode[name, "Small"])] === EdgeList[(SeedRandom[2]; ReleaseHold @ CausalSubstrateCode[name, "Small"])]]
```

With `"KeepCoordinates" -> True` the released code carries the coordinates of the substrate.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  GraphEmbedding[ReleaseHold @ CausalSubstrateCode[name, "Small", "KeepCoordinates" -> True]] ==
    GraphEmbedding[CausalSubstrate[name, "Small", "KeepCoordinates" -> True]]]
```
