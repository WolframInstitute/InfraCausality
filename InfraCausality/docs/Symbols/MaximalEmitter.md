---
Template: Symbol
Name: MaximalEmitter
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/MaximalEmitter
Keywords: [extremal events, causal future, emitter, slice, height foliation, experimental]
SeeAlso: [MaximalAbsorber, InfraCausalFuture, CausalHeightFoliation, InfraSlice, CausalHeight]
RelatedGuides: [CausalTime]
---

## Usage

<code>[MaximalEmitter]()[*g*]</code> gives, for each slice *k* of the height foliation, the sorted events of the slice whose causal future has the most vertices.

## Details & Options

Experimental: extremal events. The notion is unsettled; the function reads one count per event and may change.

Definition: for each height *k* = 0, …, *h* of the causal height *t*, the maximal emitters of the slice *S*(*k*) are the events *v* of *S*(*k*) for which the number of events of the causal future *J*⁺(*v*), *v* included, is largest. The result is the association *k* → the sorted list of them, keys in increasing order; every list is nonempty, and ties keep all their events.

An emitter is an event that can influence the most events: the event of its slice whose light reaches furthest. [MaximalAbsorber]() is the time-reversed reading. The slices are those of the causal height, counted from the sources, so the emitters of *g* are not in general the absorbers of the reversed graph, whose slices are counted from the sinks; they are when every event lies on a longest chain, as on the two lattices.

## Basic Examples

The maximal emitters of every slice (red) on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, {Catenate @ Values @ MaximalEmitter[g] -> Red}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The maximal emitters of the sprinkling, slice by slice, beside its maximal absorbers.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {MaximalEmitter[g], MaximalAbsorber[g]}]
```

The emitter of the slice at height 1 of the sprinkling with its causal future.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = First @ MaximalEmitter[g][1]},
  InfraSubstrateHighlight[g, {InfraSlice[1] -> StandardGreen, InfraCausalFuture[v] -> Red, v}]]
```

## Properties and Relations

The keys are the causal heights, and the values are exactly the events of each slice with the largest causal future, by brute force.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {size = v |-> Length @ VertexOutComponent[g, {v}]},
    Keys[MaximalEmitter[g]] === Range[0, Max @ CausalHeight[g]] &&
      AllTrue[Normal @ MaximalEmitter[g], Apply[{k, vs} |->
        With[{slice = Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"]}, vs =!= {} && vs === Sort @ Select[slice, v |-> size[v] == Max[size /@ slice]]]]]]]
```

The size of the causal future read by [`InfraMeasurement`](paclet:WolframInstitute/InfraGeometry/ref/InfraMeasurement) of [InfraCausalFuture]() is the same count.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |-> InfraMeasurement[g, InfraCausalFuture[v], "CountingMeasure"] == Length @ VertexOutComponent[g, {v}]]]]
```

When every event lies on a longest chain, as on the two lattices, the emitters of *g* are the absorbers of the reversed graph with the heights reversed.

```wl
AllTrue[{"DiamondLatticeGraph", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {h = Max @ CausalHeight[g]},
    MaximalEmitter[g] === KeySort @ KeyMap[k |-> h - k, MaximalAbsorber[ReverseGraph[g]]]]]
```
