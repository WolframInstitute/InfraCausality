---
Template: Symbol
Name: InfraSliceQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraSliceQ
Keywords: [slice, level set, universal time, antichain, maximal antichain, predicate]
SeeAlso: [InfraSlice, InfraAntichainQ, UniversalTime, UniversalFoliation]
RelatedGuides: [CausalTime]
---

## Usage

<code>[InfraSliceQ]()[*g*, *set*]</code> gives `True` if the vertex list *set* is a nonempty level set of <code>[UniversalTime]()[*g*]</code>.

<code>[InfraSliceQ]()[*g*, {*set1*, *set2*, …}]</code> tests every set in the list.

<code>[InfraSliceQ]()[*g*, *density*]</code> tests the keys of a density association.

## Details & Options

Statement: a vertex list *S* is a slice when it is nonempty, its elements are events of *g*, and *S* = {*v* : *t*(*v*) = *t*(*s*)} for one, hence every, *s* in *S*, where *t* is the universal time. Order does not matter; a repeated event makes the list fail.

A slice is an antichain, so the predicate implies [InfraAntichainQ](). The converse fails twice over: a part of a slice is an antichain and no slice, and an antichain can mix heights. Even a maximal antichain, one no event can be added to, need not be a slice: on the diamond lattice {(0, 6), (1, 4), (2, 3), (3, 2), (4, 1), (5, 0)} is maximal and its events have heights 6 and 5. The slices are the antichains that the universal time singles out.

The predicate takes a set, never an object; <code>[InfraSliceQ]()[*g*, [InfraSlice]()[*k*]]</code> stays unevaluated.

## Basic Examples

On each substrate: the slice at height 2, the same slice without its first event, and the slice at height 2 joined with an event of height 3.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {s = Keys @ InfraMeasurement[g, InfraSlice[2], "VertexDensity"]},
    {InfraSliceQ[g, s], InfraSliceQ[g, Rest[s]], InfraSliceQ[g, Append[s, First @ Keys @ InfraMeasurement[g, InfraSlice[3], "VertexDensity"]]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

A maximal antichain of the diamond lattice that is not a slice, drawn beside the slice at height 6.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {set = {{0, 6}, {1, 4}, {2, 3}, {3, 2}, {4, 1}, {5, 0}}},
  GraphicsRow[{
    Labeled[InfraSubstrateHighlight[g, {set -> StandardRed}], {InfraAntichainQ[g, set], InfraSliceQ[g, set]}],
    Labeled[InfraSubstrateHighlight[g, {InfraSlice[6]}], InfraSliceQ[g, Keys @ InfraMeasurement[g, InfraSlice[6], "VertexDensity"]]]}]]
```

The list form tests the whole universal foliation at once.

```wl
Table[
  With[{g = CausalSubstrate[name, "Small"]}, InfraSliceQ[g, UniversalFoliation[g]]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Properties and Relations

Every slice passes, the empty list fails, and a set passes exactly when it equals the slice through its first event.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {t = UniversalTime[g]},
    AllTrue[UniversalFoliation[g], s |-> InfraSliceQ[g, s] && InfraSliceQ[g, Reverse[s]]] && ! InfraSliceQ[g, {}] &&
      AllTrue[Subsets[VertexList[g], {1, 2}], set |-> InfraSliceQ[g, set] === (Sort[set] === Keys @ InfraMeasurement[g, InfraSlice[t[First @ set]], "VertexDensity"])]]]
```

A slice is an antichain; a proper nonempty part of a slice of more than one event is an antichain and no slice.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Select[UniversalFoliation[g], s |-> Length[s] > 1], s |->
      InfraAntichainQ[g, s] && InfraAntichainQ[g, Rest[s]] && ! InfraSliceQ[g, Rest[s]]]]]
```

On the two lattices every slice is a maximal antichain: every event off it is comparable with some event of it. The maximal antichain of the diamond lattice above is no slice.

```wl
With[
  {maximalQ = {g, s} |-> InfraAntichainQ[g, s] && AllTrue[Complement[VertexList[g], s], v |-> ! InfraAntichainQ[g, Append[s, v]]]},
  {diamond = CausalSubstrate["DiamondLatticeGraph", "Small"], cylinder = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  AllTrue[UniversalFoliation[diamond], s |-> maximalQ[diamond, s]] && AllTrue[UniversalFoliation[cylinder], s |-> maximalQ[cylinder, s]] &&
    maximalQ[diamond, {{0, 6}, {1, 4}, {2, 3}, {3, 2}, {4, 1}, {5, 0}}] && ! InfraSliceQ[diamond, {{0, 6}, {1, 4}, {2, 3}, {3, 2}, {4, 1}, {5, 0}}]]
```
