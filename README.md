> ⚠️ **Actively developed, experimental research code.** It undergoes frequent cleanings and refactors, and the API may change without notice.

# ⏳ InfraCausality

Causal structure and special relativity on finite directed acyclic graphs: **causal infrageometry**.

Causal infrageometry studies the causal structure of a finite DAG the way Euclidean infrageometry studies the metric structure of an undirected graph. Events are vertices, and the causal order is reachability. The objects are:

- the causal future and past of an event;
- the causal diamond between two events;
- the worldlines between two events, every saturated chain at once;
- the timelike geodesics, every longest chain at once;
- the light cones, whose members are the light rays;
- the slices of the causal height.

Every object is an inert head that takes no graph. A graph evaluates it through the protocol of [InfraGeometry](https://github.com/WolframInstitute/InfraGeometry), on which this paclet depends:

- `InfraMeasurement[g, obj, property]` reads it;
- a named `RandomInfra...` sampler draws the members of a chain head; a set head has one member, its support, `Keys @ InfraMeasurement[g, obj, "VertexDensity"]`;
- an `Infra...Q` predicate recognises one;
- `InfraSubstrateHighlight` draws it.

From observers, worldlines read as clocks, the paclet builds the EPS axioms on a graph. The message and echo relations between two observers come first, with their monotone selections and the predicate of axiom D1. Next are the radar coordinates of an observer, which give every event between its ticks a radar time and a radar distance, with the predicate of axiom D2, their injectivity. Last is the observer space, the causal graph fibered over the chart and handed to InfraGeometry's fiber-bundle machinery, and the defects and graph k-factor that measure the distance of a pair of observers from the axioms.

The continuum anchor is Bondi's k-calculus drawn as Euclidean geometry: two straight worldlines from a common origin, with light zigzagging between them at a fixed angle.

## 🧭 Guides

| Guide | Contents |
|---|---|
| **Causal Infrageometry** (main) | cones, diamonds, worldlines, timelike geodesics, light cones and light rays; reading and drawing them |
| Causal Time | the causal height, its foliation, slices and antichains |
| EPS Axiomatics | the EPS axioms on a graph: message and echo functions (D1), radar coordinates (D2), the observer space, the defects and the graph k-factor |
| Causal Substrates | named causal graphs (lattices, Minkowski sprinklings, spray graphs, Wolfram model universes) and random causal graphs |
| Bondi k-Calculus | the k-factor, rapidity, proper time in the Euclidean picture of worldlines, radar coordinates |

Each guide lists its settled, elementary functions first; experimental material (piecewise geodesics, causal-set estimators, Knuth kinematics, extremal events, the Wolfram model universes, the Bondi figures, the viewers) sits at the bottom of the same guide, in sections titled "Experimental: <topic>". The EPS Axiomatics guide has no experimental section.

Version 2.0.0 is a breaking rewrite of 1.2.0, and 2.1.0 an API review with 61 exports. [CHANGELOG.md](CHANGELOG.md) maps every removed name to its replacement.

## ✨ Usage

InfraCausality requires `WolframInstitute/InfraGeometry` 2.7.2 or later. Install both from the Wolfram Cloud:

```wolfram
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraGeometry.paclet", ForceVersionInstall -> True]
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraCausality.paclet", ForceVersionInstall -> True]
Needs["WolframInstitute`InfraGeometry`"]
Needs["WolframInstitute`InfraCausality`"]
```

Explore the [research documentation](https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraCausality).

Load InfraGeometry as well, because the readers `InfraMeasurement`, `InfraMemberQ` and `InfraSubstrateHighlight` live in its context.

```wolfram
With[ { g = CausalSubstrate[ "DiamondLatticeGraph", "Small" ] },
  InfraSubstrateHighlight[ g, { InfraCausalFuture[ { 2, 1 } ] -> Lighter[ Red, 0.6 ], InfraFutureLightCone[ { 2, 1 } ] -> Red } ] ]
```

Causal substrates are drawn in the causal-graph style of the [Wolfram Physics Project](https://www.wolframphysics.org/technical-introduction/): events in `Hue[0.11, 1, 0.97]`, causal edges in `Hue[0, 1, 0.56]`, light cones and foliation slices highlighted in red.

## 📓 Research Notebooks — "Math from code"

> ⚠️ LLM versions generated directly from the codebase via [ClaudePluginComputationalResearch](https://github.com/WolframInstitute/ClaudePluginComputationalResearch) with no warranty of correctness. Humans are welcome to publish their own versions alongside.

| Notebook | Description | Versions |
|----------|-------------|----------|

## ⚖️ License

- **Code**: [MIT](https://opensource.org/license/mit)
- **Research notebooks and ideas**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
