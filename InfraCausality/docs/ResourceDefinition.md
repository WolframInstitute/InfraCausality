---
Template: Paclet
ResourceType: Paclet
Name: WolframInstitute/InfraCausality
Context: WolframInstitute`InfraCausality`
Paclet: WolframInstitute/InfraCausality
Description: Causal structure and special relativity on finite directed acyclic graphs
ContributedBy: Pavel Hajek, Wolfram Institute
Keywords: [infrageometry, causal structure, causal set, directed acyclic graph, light cone, worldline, observer, radar coordinates, EPS axioms, Bondi k-calculus, special relativity]
MainGuide: Documentation/English/Guides/CausalInfrageometry.nb
License: MIT
WolframVersion: 14.3+
Categories: [Higher Mathematical Computation]
SourceControlURL: https://github.com/WolframInstitute/InfraCausality
---

## Basic Description

Causal infrageometry is the causal structure of a finite directed acyclic graph, studied the way infrageometry studies the metric structure of an undirected one. Events are vertices and the causal order is reachability. The basic objects are the causal future and past of an event, the causal diamond between two events, the timelike geodesics (all longest chains between two events), the observers (all saturated chains) and the light cones, whose members are the light rays. Observers exchange light, and the message, echo and radar constructions of Ehlers, Pirani and Schild turn the graph into an observer space fibered over radar coordinates.

## Details & Options

- Every object is an inert head that takes no graph. `InfraMeasurement` of InfraGeometry reads it on a causal graph, a `RandomInfra...` sampler draws its members, an `Infra...Q` predicate recognises one, and `InfraSubstrateHighlight` draws it. A cone, a diamond or a slice is a set; a timelike-geodesic family, an observer family or a light cone is a family of chains read through the directed acyclic graph whose source-to-sink paths are its members.
- The paclet has five categories: Causal Infrageometry (cones, diamonds, timelike geodesics, observers, light cones), Causal Time (the universal time and its slices), Infra Observers (message, echo and radar), Causal Substrates (named and random causal graphs) and the continuum Bondi k-Calculus, one guide each. The main sections of a guide hold the settled, elementary functions; the experimental ones are listed at the bottom of the same guide, in sections titled "Experimental: <topic>".
- It depends on [InfraGeometry](paclet:WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry), whose measurement, sampling, highlighting and fiber-bundle functions it extends to causal heads.
- Load with <code>Needs["WolframInstitute\`InfraCausality\`"]</code>; the examples also load <code>Needs["WolframInstitute\`InfraGeometry\`"]</code>.
- The Causal Infrageometry guide, [Causal Infrageometry](paclet:WolframInstitute/InfraCausality/guide/CausalInfrageometry), is the landing page.
