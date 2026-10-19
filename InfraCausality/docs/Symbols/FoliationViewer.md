---
Template: Symbol
Name: FoliationViewer
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/FoliationViewer
Keywords: [viewer, causal height, foliation, slice, antichain, interactive, Manipulate, experimental]
SeeAlso: [CausalHeight, CausalHeightFoliation, InfraSlice, LightConeViewer, MessageFunctionViewer]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[FoliationViewer]()[*g*]</code> gives a `Manipulate` with a slider over the causal height *k* drawing the slice <code>[InfraSlice]()[*k*]</code> over the earlier band <code>[InfraSlice]()[{0, *k* − 1}]</code>.

## Details & Options

Experimental: viewer. The interface of the viewers may change.

Definition: the frame at time *k* draws, with <code>[`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight)</code>, the slice {*v* : *t*(*v*) = *k*} of the [CausalHeight]() *t* in red over the band {*v* : *t*(*v*) < *k*} in light blue. The label gives *k* and the sizes of the slice and of the band. The slider runs from 0 to the height of *g*, the largest causal height.

The causal height *t*(*v*) is the length of a longest chain ending at *v*, and its level sets are the slices of [CausalHeightFoliation](). The result is a `Manipulate` with `SaveDefinitions -> True`; it needs the Wolfram notebook front end to move the slider.

## Basic Examples

The height foliation of the cylinder lattice, one slice at a time.

```wl
FoliationViewer[CausalSubstrate["CylinderLatticeGraph", "Small"]]
```

The frame at time 3, drawn without the viewer, on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, {InfraSlice[{0, 2}] -> Lighter[RGBColor[0.259, 0.576, 1], 0.5], InfraSlice[3] -> Red}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Properties and Relations

At every time the slice and the earlier band are disjoint, their union is the band up to *k*, and the slices of all times exhaust the events.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {height = Max @ CausalHeight @ g},
    AllTrue[Range[0, height], k |->
      With[{slice = Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"], earlier = Keys @ InfraMeasurement[g, InfraSlice[{0, k - 1}], "VertexDensity"]},
        Intersection[slice, earlier] === {} && Union[slice, earlier] === Keys @ InfraMeasurement[g, InfraSlice[{0, k}], "VertexDensity"]]] &&
      Sort[Catenate[Keys @ InfraMeasurement[g, InfraSlice[#], "VertexDensity"] & /@ Range[0, height]]] === Sort[VertexList[g]]]]
```

Every slice is an antichain, and every event of slice *k* > 0 has an in-neighbour in slice *k* − 1 and its whole strict past in the earlier band.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[Range[0, Max @ CausalHeight @ g], k |->
      InfraAntichainQ[g, Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"]] &&
        (k == 0 || AllTrue[Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"], v |->
          IntersectingQ[VertexInComponent[g, v, {1}], Keys @ InfraMeasurement[g, InfraSlice[k - 1], "VertexDensity"]] &&
            SubsetQ[Keys @ InfraMeasurement[g, InfraSlice[{0, k - 1}], "VertexDensity"], DeleteCases[Keys @ InfraMeasurement[g, InfraCausalPast[v], "VertexDensity"], v]]])]]]
```

The viewer is a `Manipulate`.

```wl
Head @ FoliationViewer[CausalSubstrate["DiamondLatticeGraph", "Small"]] === Manipulate
```
