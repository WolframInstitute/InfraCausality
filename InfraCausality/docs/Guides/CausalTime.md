---
Template: Guide
Name: CausalTime
Title: Causal Time
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/CausalTime
Keywords: [time function, causal height, height, longest chain, foliation, slice, antichain, simultaneity, extremal events]
RelatedGuides: [CausalInfrageometry, EPSAxiomatics, CausalSubstrates, BondiKCalculus]
---

## Abstract

A time function on a causal graph is a map to the integers that increases along every edge. The causal height of an event is the least such function: the number of edges of a longest chain from a source to the event, zero on the sources. Its level sets, the slices of the height foliation, are antichains that partition the events, and the slice through an event is the discrete analogue of a simultaneity surface. A slice is an inert set head read like a ball: `InfraSubgraph[g, InfraSlice[k]]` is its induced subgraph, `Keys @ InfraMeasurement[g, InfraSlice[k], "VertexDensity"]` its support as a sorted vertex list, and `RandomInfraPoint[g, InfraSlice[k], n]` draws random events of it.

## Functions

### Causal height

- `CausalHeight` the height $t(v) = \max_s \tau(s, v)$ over the sources $s$, zero on the sources
- `CausalHeightFoliation` the slices $\{v : t(v) = k\}$, $k = 0, \dots, \max t$, antichains partitioning the events
- `TopologicalSort` (WL), `ReverseGraph` (WL)

### Slices and simultaneity

- `InfraSlice` the slice $\{v : t(v) = k\}$ at height $k$, or the band of slices $k_1 \le t(v) \le k_2$

- `InfraSliceQ`, `InfraAntichainQ`

### Experimental: extremal events

- `MaximalAbsorber`, `MaximalEmitter` per slice of the height foliation, the events of largest causal past or causal future
