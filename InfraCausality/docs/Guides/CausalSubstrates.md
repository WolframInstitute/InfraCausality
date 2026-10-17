---
Template: Guide
Name: CausalSubstrates
Title: Causal Substrates
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/CausalSubstrates
Keywords: [causal substrate, causal graph, causal set, lattice, sprinkling, Minkowski space, transitive percolation, spray graph, Wolfram model]
RelatedGuides: [CausalInfrageometry, CausalTime, InfraObservers, BondiKCalculus, Experimental]
---

## Abstract

A causal substrate is the directed acyclic graph the observer lives in. The named substrates come at three sizes with the style they are drawn in and the code that builds them: the light-cone lattices (the $\mathbb{Z}^2$ product order cut to a diamond and the cylinder lattice of constant width), fixed-seed Poisson sprinklings into a Minkowski diamond, the spray graphs of InfraGeometry's Riemannian substrates, and the causal graphs of notable Wolfram model universes. Random causal graphs are drawn by transitive percolation, by an acyclic orientation of a random graph or by a sprinkling.

## Functions

### Named causal graphs

- `CausalSubstrate` the named causal graph at size "Small", "Medium" or "Large"
- `CausalSubstrateStyle` the options a causal substrate is drawn with at a given size
- `CausalSubstrateCode` the held code that builds a named causal substrate

### Random causal graphs

- `RandomCausalGraph` a random causal set of $n$ events: the Hasse diagram of a transitive percolation with link probability $p$, of a random acyclic orientation with $m$ edges, or of a sprinkling into $d$-dimensional Minkowski space
- `RandomGraph` (WL), `DirectedGraph` (WL)

### Causal graphs from Riemannian substrates

- `SprayGraph` (InfraGeometry) the rank DAG of an undirected substrate from a base point, $u \to v$ iff $d(c, v) = d(c, u) + 1$
- `InfraSubstrate` (InfraGeometry) the named undirected substrates
