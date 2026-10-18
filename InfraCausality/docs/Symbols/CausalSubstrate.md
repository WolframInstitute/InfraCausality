---
Template: Symbol
Name: CausalSubstrate
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/CausalSubstrate
RelatedGuides: [CausalSubstrates]
---

## Usage

`CausalSubstrate[name, size]` gives the named causal graph at size "Small", "Medium" or "Large", a transitively reduced DAG.

`CausalSubstrate[]` lists the names by group.

## Details & Options

Under `"KeepCoordinates" -> True` the entries `"CubicLatticeGraph"` and `"MinkowskiSprinkling3D"` keep their full point (*x*, *y*, *t*), and [`InfraSubstrateHighlight`](paclet:WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight) draws them in the plane by the cabinet projection (*x*, *y*, *t*) ↦ (*x* + *y*/(2√2), *t* + *y*/(2√2)), time up and the second space axis receding at 45° with half its length, while the substrate itself keeps the 3D point.

Experimental: the `"WolframModel"` group holds the causal graphs of six notable universes of the Wolfram Physics registry, "wm3467", "wm1783", "wm7714", "wm1529", "wm3975" and "wm2216", evolved for a fixed number of events per size and reduced to the Hasse diagram of their causal order. The vertices are the event numbers, a linear extension of the order. The edge lists ship with the paclet as the asset `"WolframModelCausalGraphs"`, so no evolution runs at load time. The universes "wm1783" and "wm7714" update one event per generation, so their causal orders are total and their Hasse diagrams are chains.

## Basic Examples

The causal graph of the universe "wm3467" at size "Small", with its slice at height 5 and the causal future of event 10.

```wl
With[
  {g = CausalSubstrate["wm3467", "Small"]},
  InfraSubstrateHighlight[g, {InfraSlice[5], InfraCausalFuture[10]}]]
```
