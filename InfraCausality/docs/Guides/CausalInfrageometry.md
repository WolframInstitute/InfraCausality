---
Template: Guide
Name: CausalInfrageometry
Title: Causal Infrageometry
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/CausalInfrageometry
Keywords: [causal structure, causal set, directed acyclic graph, causal future, causal past, causal diamond, Alexandrov interval, worldline, observer, light cone, light ray, chain, infrageometry]
RelatedGuides: [CausalTime, InfraObservers, CausalSubstrates, BondiKCalculus, Experimental]
---

## Abstract

Causal infrageometry studies the causal structure of a finite directed acyclic graph the way Euclidean infrageometry studies the metric structure of an undirected one. Events are vertices and the causal order is reachability; the objects are the causal future and past of an event, the causal diamond between two events, the worldlines between them (all longest chains at once, the timelike geodesics), the observers (all saturated chains), and the light cones, whose members are the light rays: the chains $[v, e]$ that admit no second route. Every object is an inert head that takes no graph. `InfraMeasurement[g, obj, property]` of InfraGeometry reads it on a causal graph, a named `RandomInfra...` sampler draws its members, an `Infra...Q` predicate recognises one, and `InfraSubstrateHighlight` draws it. The heads of two kinds follow the two InfraGeometry shapes: a cone, a diamond or a slice is a set, read by its vertex density; a worldline, an observer family or a light cone is a family of chains, read by the directed acyclic graph whose source-to-sink paths are exactly its members, so that cardinalities and densities come from one dynamic programme and never from enumeration.

## Functions

### Events and the causal relation

- `InfraCausalFuture` the causal future $J^+(v) = \{e : v \preceq e\}$ of an event or an event set, or its events within proper time $t$
- `InfraCausalPast` the causal past $J^-(v) = \{e : e \preceq v\}$
- `RandomInfraCausalFuture`, `RandomInfraCausalPast` the support of a cone as a sorted vertex list
- `VertexOutComponent` (WL), `VertexInComponent` (WL), `TransitiveReductionGraph` (WL)

- `InfraCausalFutureQ`, `InfraCausalPastQ`, `InfraChainQ`, `AcyclicGraphQ` (WL)

### Causal diamonds

- `InfraCausalDiamond` the Alexandrov interval $[p, q] = J^+(p) \cap J^-(q)$, or the causal hull $J^+(S) \cap J^-(S)$ of a set
- `RandomInfraCausalDiamond` the support of a diamond as a sorted vertex list

- `InfraCausalDiamondQ`

### Worldlines and observers

- `InfraWorldline` the timelike geodesics from $p$ to $q$, every longest chain between them at once; with no arguments, the longest chains of the graph
- `RandomInfraWorldline` random longest chains from $p$ to $q$ as vertex lists
- `InfraObserver` the observers from $p$ to $q$, every saturated chain between them; with no arguments, every inextendible chain
- `RandomInfraObserver` random saturated chains as vertex lists, their positions the ticks of a clock
- `FindPath` (WL), `TopologicalSort` (WL)

- `InfraWorldlineQ`, `InfraObserverQ`

### Light cones and light rays

- `InfraFutureLightCone` the future light cone $E^+(v) = \{e \succeq v : [v, e] \text{ is a chain}\}$, whose members are the outgoing light rays
- `InfraPastLightCone` the past light cone $E^-(v)$, whose members are the incoming light rays
- `RandomInfraFutureLightCone`, `RandomInfraPastLightCone` random light rays as vertex lists

- `InfraLightRayQ`

### Reading a construction on a graph

- `InfraMeasurement` (InfraGeometry) a property of a causal head on a graph: "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure"
- `InfraDensity` (InfraGeometry) the vertex multiplicities of a vertex, vertex list or chain graph
- `InfraMemberQ` (InfraGeometry) whether a vertex list is a member of a causal head on a graph
- `InfraSubgraph` (InfraGeometry) the subgraph induced on the support of a head

### Substrates and drawing

- `CausalSubstrate` the named causal graphs at size "Small", "Medium" or "Large"
- `RandomCausalGraph` a random causal set: transitive percolation, a random acyclic orientation or a sprinkling
- `InfraSubstrateHighlight` (InfraGeometry) the densities of a list of causal heads drawn on a causal graph, one palette colour each

### Experimental: viewers

- `LightConeViewer`, `MessageFunctionViewer`, `FoliationViewer`, `BondiViewer` interactive viewers for light cones, message functions, the universal foliation and the Bondi constructions
