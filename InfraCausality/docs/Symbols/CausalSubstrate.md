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
