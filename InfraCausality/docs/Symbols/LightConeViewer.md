---
Template: Symbol
Name: LightConeViewer
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/LightConeViewer
Keywords: [viewer, light cone, causal future, causal past, interactive, Manipulate, experimental]
SeeAlso: [InfraCausalFuture, InfraCausalPast, InfraFutureLightCone, InfraPastLightCone, MessageFunctionViewer, FoliationViewer]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[LightConeViewer]()[*g*]</code> gives a `Manipulate` drawing *g* in which clicking an event *v* highlights its causal future and past and its future and past light cones.

## Details & Options

Experimental: viewer. The interface of the viewers may change.

Definition: the frame at an event *v* draws, with <code>[`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight)</code>, the causal future *J*⁺(*v*) in light orange, the causal past *J*⁻(*v*) in light blue, the future light cone *E*⁺(*v*) in orange, the past light cone *E*⁻(*v*) in blue and *v* in red. The label above the drawing gives *v*, its universal time, the causal volumes \|*J*⁺(*v*)\| and \|*J*⁻(*v*)\|, and the numbers of outgoing and incoming light rays.

A click selects the event of *g* nearest to the click in the drawing; the viewer starts at an event of the graph centre. The result is a `Manipulate` with `SaveDefinitions -> True`, so it keeps working in a fresh session; clicking needs the Wolfram notebook front end.

## Basic Examples

The light cones of the events of a sprinkling into two-dimensional Minkowski space. Click an event to move the apex.

```wl
LightConeViewer[CausalSubstrate["MinkowskiSprinkling2D", "Small"]]
```

The frame at an event at height 3, drawn without the viewer, on the diamond lattice, the sprinkling and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {v = (SeedRandom[1]; RandomChoice @ RandomInfraSlice[g, InfraSlice[3]])},
    InfraSubstrateHighlight[g, {
      InfraCausalFuture[v] -> Lighter[StandardOrange, 0.6], InfraCausalPast[v] -> Lighter[StandardBlue, 0.6],
      InfraFutureLightCone[v] -> StandardOrange, InfraPastLightCone[v] -> StandardBlue, {v} -> StandardRed}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Properties and Relations

The four sets drawn at *v* nest: each light cone lies in its causal cone, and the two causal cones meet only at *v*.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      SubsetQ[RandomInfraCausalFuture[g, v], Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"]] &&
        SubsetQ[RandomInfraCausalPast[g, v], Keys @ InfraMeasurement[g, InfraPastLightCone[v], "VertexDensity"]] &&
        Intersection[RandomInfraCausalFuture[g, v], RandomInfraCausalPast[g, v]] === {v}]]]
```

The ray counts in the label are the numbers of extremal events of the light cones: the leaves of the future tree and of the past tree.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    AllTrue[VertexList[g], v |->
      InfraMeasurement[g, InfraFutureLightCone[v], "Cardinality"] == Count[VertexOutDegree @ InfraMeasurement[g, InfraFutureLightCone[v], "Graph"], 0] &&
        InfraMeasurement[g, InfraPastLightCone[v], "Cardinality"] == Count[VertexInDegree @ InfraMeasurement[g, InfraPastLightCone[v], "Graph"], 0]]]]
```

The viewer is a `Manipulate`.

```wl
Head @ LightConeViewer[CausalSubstrate["CylinderLatticeGraph", "Small"]] === Manipulate
```
