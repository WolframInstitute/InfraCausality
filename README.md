> ⚠️ **Experimental research code.** The language and API are actively developing.

# ⏳ InfraCausality

This repository contains experimental code and a developing language for causal structure and special relativity on finite directed acyclic graphs, the causal companion of [Infrageometry](https://github.com/WolframInstitute/InfraGeometry), aligned with the vision of [Stephen Wolfram](https://writings.stephenwolfram.com/).

Our goal is to show how the causal structure of spacetime, its light cones, clocks, radar coordinates and Lorentz kinematics, emerges from the causal graphs of hypergraph rewriting models of the universe, as described in the [Wolfram Physics Project technical introduction](https://www.wolframphysics.org/technical-introduction/). Events are vertices and the causal order is reachability; everything else is built from paths.

📚 **Documentation:** [research documentation of InfraCausality](https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraCausality).

## 🔺 Causal Infrageometry

Causal infrageometry studies the causal structure of a DAG the way Euclidean infrageometry studies the metric structure of an undirected graph. Its objects are the causal future and past of an event, the causal diamond between two events, the worldlines (every saturated chain at once), the timelike geodesics (every longest chain at once) and the light cones, whose members are the light rays. Every object is an inert head that takes no graph; a graph evaluates it through the InfraGeometry protocol: `InfraMeasurement[g, obj, property]` reads it, a `RandomInfra...` sampler draws the members of a chain family, an `Infra...Q` predicate recognises one, and `InfraSubstrateHighlight` draws it.

## 🕰️ Causal Time

The causal height of an event, the length of a longest chain from a source to it, is a time function with no observer chosen. Its level sets, the slices of the height foliation, are antichains partitioning the events: the discrete analogue of simultaneity surfaces.

## 📡 EPS Axiomatics

Following the EPS axiomatisation, an observer is a worldline read as a clock. Two observers exchange light: the message and echo relations, their monotone selections and the predicate of axiom D1; the radar coordinates of an observer, with the predicate of axiom D2; the observer space, the causal graph fibered over the coordinate cells and handed to InfraGeometry's fiber-bundle machinery; and the defects and graph k-factor that measure how far a pair of observers is from the axioms.

## 🧱 Causal Substrates

Named causal graphs at three sizes (diamond and cylinder lattices, Minkowski sprinklings, spray graphs of Riemannian substrates, Wolfram model universes) and random causal sets by transitive percolation or sprinkling, drawn in the causal-graph style of the Wolfram Physics Project.

## 📐 Bondi k-Calculus

The continuum anchor: Bondi's k-calculus drawn as Euclidean geometry, two straight worldlines from a common origin with light zigzagging between them at a fixed angle. The k-factor is a ratio of arc lengths, proper time a fixed multiple of arc length, and the bounce count logarithmic in arc length.

## ✨ Usage

Install from the Wolfram Cloud (InfraCausality requires InfraGeometry 2.7.2 or later):

```wolfram
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraGeometry.paclet", ForceVersionInstall -> True]
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraCausality.paclet", ForceVersionInstall -> True]
Needs["WolframInstitute`InfraGeometry`"]
Needs["WolframInstitute`InfraCausality`"]
```

Explore the [research documentation](https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraCausality). [CHANGELOG.md](CHANGELOG.md) maps every removed name to its replacement.

## 🙏 Funding

Pavel Hájek's work on this repository was supported by the John Templeton Foundation grant 63655, [Causality, Observers and Computation: A New Approach to Fundamental Physics and Metamathematics](https://www.templeton.org/grant/causality-observers-and-computation-a-new-approach-to-fundamental-physics-and-metamathematics) at the Wolfram Institute. The opinions expressed are those of the author and do not necessarily reflect the views of the John Templeton Foundation.

## ⚖️ License

- Code: [MIT](LICENSE)
- Mathematical content: [CC BY 4.0](LICENSE-CC-BY-4.0)
