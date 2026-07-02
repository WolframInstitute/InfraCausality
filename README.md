# InfraCausality

> ⚠️ **Actively developed, experimental research code.** It undergoes frequent cleanings and refactors, and the API may change without notice.

Causal structure and special relativity on finite directed graphs.

Develops minimal models of special relativity notions on directed graphs, including Bondi k-calculus, EPS (Ehlers-Pirani-Schild) axioms, and Knuth-style kinematics.

## Install

Install from the Wolfram Cloud:

```wolfram
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraCausality.paclet", ForceVersionInstall -> True]
Needs["WolframInstitute`InfraCausality`"]
```

## Quick Start

```wolfram
Needs["WolframInstitute`InfraCausality`"]

graph = RandomConnectedDAG[{20, 40}, GraphLayout -> "LayeredDigraphEmbedding"];
chains = FindChain[graph, 2, "Method" -> "Diverse"];
MultiMessageFunction[graph, chains[[1]], chains[[2]]]
```

## License

MIT
