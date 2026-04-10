# InfraCausality

Causal structure and special relativity on finite directed graphs.

Develops minimal models of special relativity notions on directed graphs, including Bondi k-calculus, EPS (Ehlers-Pirani-Schild) axioms, and Knuth-style kinematics.

## Install

```wolfram
PacletInstall["https://github.com/WolframInstitute/InfraCausality"]
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
