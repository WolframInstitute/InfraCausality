> ⚠️ **Actively developed, experimental research code.** It undergoes frequent cleanings and refactors, and the API may change without notice.

# ⏳ InfraCausality

Causal structure and special relativity on finite directed acyclic graphs: **causal infrageometry**.

Causal infrageometry studies the causal structure of a finite DAG the way Euclidean infrageometry studies the metric structure of an undirected graph. Events are vertices, and the causal order is reachability. The objects are:

- the causal future and past of an event;
- the causal diamond between two events;
- the worldlines between two events, every longest chain at once (the timelike geodesics);
- the observers, every saturated chain;
- the light cones, whose members are the light rays;
- the slices of the universal time.

Every object is an inert head that takes no graph. A graph evaluates it through the protocol of [InfraGeometry](https://github.com/WolframInstitute/InfraGeometry), on which this paclet depends:

- `InfraMeasurement[g, obj, property]` reads it;
- a named `RandomInfra...` sampler draws its members;
- an `Infra...Q` predicate recognises one;
- `InfraSubstrateHighlight` draws it.

From observers the paclet builds the discrete Ehlers–Pirani–Schild construction. The message and echo relations between two observers come first. Next is the radar chart of an observer, which gives every event between its ticks a radar time and a radar distance. Last is the observer space, the causal graph fibered over the chart and handed to InfraGeometry's fiber-bundle machinery.

The continuum anchor is Bondi's k-calculus drawn as Euclidean geometry: two straight worldlines from a common origin, with light zigzagging between them at a fixed angle.

## 🧭 Guides

| Guide | Contents |
|---|---|
| **Causal Infrageometry** (main) | cones, diamonds, worldlines, observers, light cones and light rays; reading and drawing them |
| Causal Time | the universal time, its foliation, slices and antichains |
| Infra Observers | message and echo relations (EPS), radar charts, the observer fibration |
| Causal Substrates | named causal graphs (lattices, Minkowski sprinklings, spray graphs) and random causal graphs |
| Bondi k-Calculus | the k-factor, rapidity, the Euclidean picture of worldlines and radar coordinates |
| Experimental Functions | Knuth kinematics, extremal events, message and echo selections, the Bondi figures |

Version 2.0.0 is a breaking rewrite of 1.2.0. [CHANGELOG.md](CHANGELOG.md) maps every removed name to its replacement.

## ✨ Usage

InfraCausality requires `WolframInstitute/InfraGeometry` 2.7.2 or later. Install both from the Wolfram Cloud:

```wolfram
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraGeometry.paclet", ForceVersionInstall -> True]
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraCausality.paclet", ForceVersionInstall -> True]
Needs["WolframInstitute`InfraGeometry`"]
Needs["WolframInstitute`InfraCausality`"]
```

Load InfraGeometry as well, because the readers `InfraMeasurement`, `InfraMemberQ` and `InfraSubstrateHighlight` live in its context.

```wolfram
With[ { g = CausalSubstrate[ "DiamondLatticeGraph", "Small" ] },
  InfraSubstrateHighlight[ g, { InfraCausalFuture[ { 2, 1 } ] -> StandardOrange, InfraFutureLightCone[ { 2, 1 } ] -> StandardRed } ] ]
```

## 📓 Research Notebooks — "Math from code"

> ⚠️ LLM versions generated directly from the codebase via [ClaudePluginComputationalResearch](https://github.com/WolframInstitute/ClaudePluginComputationalResearch) with no warranty of correctness. Humans are welcome to publish their own versions alongside.

| Notebook | Description | Versions |
|----------|-------------|----------|

## ⚖️ License

- **Code**: [MIT](https://opensource.org/license/mit)
- **Research notebooks and ideas**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
