# Changelog

## 2.0.0 (2026-10-18)

A breaking release that rebuilds the paclet on the principles of `WolframInstitute/InfraGeometry` 2.7.2, which is now a declared dependency (`"WolframInstitute/InfraGeometry" -> "2.7.2+"`). The 69 exports of 1.2.0 become 71, in five categories with one guide each. The main guide is **Causal Infrageometry**; the others are Causal Time, Infra Observers, Causal Substrates and Bondi k-Calculus. No alias is kept for a removed name; the table below gives the replacement of each one.

- **Breaking -- inert heads read through InfraGeometry's protocol.** The basic constructs are positional, inert heads that take no graph. They are `InfraCausalFuture`, `InfraCausalPast`, `InfraCausalDiamond`, `InfraSlice`, `InfraWorldline`, `InfraObserver`, `InfraFutureLightCone`, `InfraPastLightCone`, `InfraMessageFunction`, `InfraEchoFunction` and `InfraRadarChart`. A graph evaluates them only through InfraGeometry's functions: `InfraMeasurement[g, obj, prop]`, `InfraMemberQ`, `InfraSubgraph` and `InfraSubstrateHighlight`. Each head also has a family predicate `Infra<Name>Q[g, candidate]`. A set head (a cone, a diamond or a slice) is read by its `"VertexDensity"`. A chain head (worldlines, observers or a light cone) is read by its `"Graph"`, a DAG whose source-to-sink paths are exactly its members; its cardinality and densities come from InfraGeometry's chain-count dynamic programme. The 1.2.0 wrappers `InfraChain`, `InfraLightRay`, `InfraLightCone`, `InfraCausalInterval` and `InfraEvent` are gone, along with their accessors. A chain is a vertex list and an event is a vertex. The functions that returned a cone, an interval, a set of light rays or a message relation are now readings of a head.
- **Breaking -- samplers draw, readers read.** The members of a head are drawn by `RandomInfra<Name>[g, obj, count]`. The count contract is InfraGeometry's: no count or `Automatic` draws one member, `n` gives exactly `n` distinct members or `{}`, `UpTo[n]` at most `n`, and `All` every member in a deterministic order. The samplers take the `"NextVertexFunction"` option and are seeded with `SeedRandom`. A chain sampler draws uniformly, choosing each step by the chain-count weights. `FindChain`, `FindMessageFunction` and `FindEchoFunction` are replaced by `RandomInfraWorldline`, `RandomInfraMessageFunction` and `RandomInfraEchoFunction`. A deterministic draw is `"NextVertexFunction" -> Identity`, and `All` enumerates.
- **Breaking -- experimental sections, and the drops.** The main sections of each guide hold only settled, elementary functions. The functions whose mathematics is not settled are listed at the bottom of the guide of their category, in sections titled "Experimental: <topic>", and their kernel files live in that category's folder. They remain exported. They are the Knuth kinematics and the graph viewers (Causal Infrageometry), the extremal events of a slice (Causal Time), the message and echo selection samplers (Infra Observers), and the Bondi figures with their drawing helpers and `BondiViewer` (Bondi k-Calculus). `ProperTimeScale` is stable. The five Knuth scalars, the `Visualize*` functions, the colour palette, `GetSources`, `GetSinks`, `EchoGraph`, `MonotoneQ` and the `InfraObjects` wrappers are removed. The `"Separated"` method of `FindChain` moves to the dev repository as `Code/SeparatedChains.wl`.

| 1.2.0 | 2.0.0 |
|---|---|
| `$CausalColors` | `StandardOrange`, `StandardBlue`, `StandardGreen`, `StandardRed`, `StandardPurple`, `StandardGray` by name, or palette order in `InfraSubstrateHighlight` |
| `CausalGraphStyle` | `CausalSubstrateStyle[size]`, `CausalSubstrateStyle[name, size]` |
| `GetSources` | `Pick[VertexList[g], VertexInDegree[g], 0]` |
| `GetSinks` | `Pick[VertexList[g], VertexOutDegree[g], 0]` |
| `FindChain` (`"Longest"`) | `RandomInfraWorldline[g, InfraWorldline[p, q], n]`, `RandomInfraWorldline[g, n]` |
| `FindChain` (`"Separated"`) | dev repository `Code/SeparatedChains.wl` |
| `InfraChain` | a vertex list; the families are `InfraWorldline[p, q]` and `InfraObserver[p, q]` |
| `InfraLightRay` | `InfraFutureLightCone[v]`, whose members are the rays |
| `InfraLightCone` | `InfraCausalFuture[v]`, `InfraCausalPast[v]` |
| `InfraCausalInterval` | `InfraCausalDiamond[p, q]` |
| `InfraEvent` | a vertex |
| `InfraChainQ[expr]` (a wrapper test) | `InfraChainQ[g, list]`, whether consecutive elements are causally ordered on `g` |
| `InfraLightRayQ[expr]` (a wrapper test) | `InfraLightRayQ[g, chain]`, whether `chain` is a light ray on `g` |
| `InfraLightConeQ[expr]` | `InfraCausalFutureQ[g, set]`, `InfraCausalPastQ[g, set]` |
| `InfraCausalIntervalQ[expr]` | `InfraCausalDiamondQ[g, set]` |
| `InfraEventQ` | `VertexQ[g, v]` |
| `ForwardLightCone[g, v]` | `InfraMeasurement[g, InfraCausalFuture[v], "Subgraph"]`; the set is `RandomInfraCausalFuture[g, v]` |
| `ForwardLightCone[g, v, len]` | `InfraCausalFuture[v, t]`, cut by proper time (longest chain), not by shortest path |
| `BackwardLightCone` | `InfraCausalPast[v]`, as above |
| `CausalInterval[g, p, q]` | `InfraMeasurement[g, InfraCausalDiamond[p, q], "Subgraph"]` |
| `ChainCausalInterval[g, chain]` | `RandomInfraCausalDiamond[g, InfraCausalDiamond[chain]]` |
| `UniversalTime[g, foliation]` | `UniversalTime[g]` |
| `OutgoingLightRays[g, v]` | `Keys @ InfraMeasurement[g, InfraFutureLightCone[v], "VertexDensity"]`; the rays are `RandomInfraFutureLightCone[g, v, All]` |
| `IncomingLightRays[g, v]` | `InfraPastLightCone[v]`, as above |
| `InfraEnergy[p, q]` | `(p + q)/2`, the `"Energy"` entry of `InfraKinematics` |
| `InfraMomentum[p, q]` | `(p - q)/2`, the `"Momentum"` entry |
| `InfraMass[p, q]` | `Sqrt[Abs[p q]]`, the `"Mass"` entry |
| `InfraInterval[p, q]` | `p q`, the `"Interval"` entry |
| `InfraVelocity[p, q]` | `(p - q)/(p + q)`, the `"Velocity"` entry |
| `MultiMessageFunction[g, a, b]` | `InfraMeasurement[g, InfraMessageFunction[a, b], "Relation"]` |
| `FindMessageFunction[g, a, b]` | `RandomInfraMessageFunction[g, InfraMessageFunction[a, b], n]`; `All` enumerates |
| `MultiEchoFunction[g, a, b]` | `InfraMeasurement[g, InfraEchoFunction[a, b], "Relation"]` |
| `FindEchoFunction[g, a, b]` | `RandomInfraEchoFunction[g, InfraEchoFunction[a, b], n]` |
| `EchoGraph` | `InfraMeasurement[g, InfraMessageFunction[a, b], "Graph"]`, `InfraMeasurement[g, InfraEchoFunction[a, b], "Graph"]` |
| `MonotoneQ[a, b, f]` | `InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f]`, `InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f]` |
| `VisualizeLightRays` | `LightConeViewer[g]` |
| `VisualizeFoliatedCausalGraph` | `FoliationViewer[g]`; static: `InfraSubstrateHighlight[g, InfraSlice /@ Range[0, k]]` |
| `VisualizeMessageFunction` | `MessageFunctionViewer[g, a, b]` |
| `VisualizeEchoFunction` | none (it was a stub that never computed the echo) |
| `RadarCoordinatesFromAlice[event, phi]` | `BondiRadarCoordinates[{x, y}, phi]` |
| `BondiExplorer[]` | `BondiViewer[]` |

Other changes:

- **Fixed: `UniversalFoliation` with several sources.** `UniversalTime[g]` is the height $t(v)$, the number of edges of a longest chain from a source to $v$. It is computed by one pass over a topological order, and `UniversalFoliation[g]` gives its level sets. In 1.2.0 a vertex that some source could not reach got height $-\infty$. For example, `Graph[{1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5}]` now foliates as `{{1, 2}, {3}, {4}, {5}}`.
- **Changed: `ChainProjection`.** It is the fraction of the events of the first chain whose causal future meets the second chain (with `"Method" -> "LightRays"`, whose future light cone meets it), so it lies in $[0, 1]$. In 1.2.0 it was $|J^+(a) \cap b| / |a|$, which could exceed 1. An unknown `"Method"` now falls back to `"Cone"` instead of returning `Null`. `InfraKinematics` returns `"Projections"` and the five Knuth scalars, without `"GeometricMass"`, and gives a `"Velocity"` of `Indeterminate` when $p = q = 0$.
- **Changed: `MaximalAbsorber`, `MaximalEmitter`.** They are Experimental and give `<|k -> events|>`, with the events of each slice as a sorted vertex list.
- **Changed: `RandomCausalGraph`.** It gives the Hasse diagram of a random order on the events `1, ..., n`, labelled in a topological order. The forms are:
  - `RandomCausalGraph[{n, p}]` is transitive percolation;
  - `RandomCausalGraph[n]` is transitive percolation with $p = \log n / n$;
  - `RandomCausalGraph[{n, m}]` orients a random connected graph with `m` edges, as before, but is now transitively reduced;
  - `Method -> {"Sprinkling", d}` sprinkles `n` points into the unit causal diamond of $d$-dimensional Minkowski space.
- **New: `CausalSubstrate`.** It is the catalogue of named causal graphs at sizes `"Small"`, `"Medium"` and `"Large"`, with `CausalSubstrateStyle` and `CausalSubstrateCode`, mirroring `InfraSubstrate`. The groups are:
  - `"Lattice"`: `"DiamondLatticeGraph"`, `"CylinderLatticeGraph"`, `"CubicLatticeGraph"`;
  - `"Sprinkling"`: `"MinkowskiSprinkling2D"`, `"MinkowskiSprinkling3D"`;
  - `"Spray"`: the spray graphs of three InfraGeometry substrates;
  - `"Random"`: `"PercolationGraph"`;
  - `"WolframModel"` (experimental): `"wm3467"`, `"wm1783"`, `"wm7714"`, `"wm1529"`, `"wm3975"`, `"wm2216"`, the Hasse diagrams of the causal orders of six notable universes of the Wolfram Physics registry.

  Every entry is a transitively reduced DAG drawn with time upward. The Wolfram model edge lists ship as the paclet asset `WolframModelCausalGraphs` (`Resources/WolframModelCausalGraphs.wxf`, located by `PacletObject[...]["AssetLocation", "WolframModelCausalGraphs"]`), so no evolution runs at load time. The universes `"wm1783"` and `"wm7714"` update one event per generation, so their causal orders are total and their Hasse diagrams are chains.
- **Changed: echo functions are EPS compositions.** The members of `InfraEchoFunction[a, b]` are the composites $f_{ba} \circ f_{ab}$ of a member of `InfraMessageFunction[a, b]` with a member of `InfraMessageFunction[b, a]`, on the ticks whose signal returns, deduplicated. An earlier draft composed arbitrary selections and kept the monotone composites, a strictly larger set: on the Small diamond lattice the staircase worldline shifted by two steps has 699 echo functions via the staircase (932 under the draft rule) and the staircase 2584 via the shifted one. `"Cardinality"` counts the distinct composites and is at most the product of the two message cardinalities. `InfraEchoFunctionQ` is now exact and polynomial: it decides membership by a path search in the selection DAG of the outgoing messages restricted to the images compatible with the map, and `InfraMemberQ` on an echo head is the same test.
- **New: `InfraRadarChart`.** It is the radar chart of an observer chain, or of a list of chains. Each event in the radar domain gets the radar time $(i + j)/2$ and the radar distance $(j - i)/2$ of its emission tick $i$ and reception tick $j$. Its `"Fibration"` reading hands InfraGeometry an `InfraFibration` of the undirected radar domain over the chart: the observer space, on which sections, connections and holonomy are read.
- **New: the drawing primitive.** `InfraSubstrateHighlight` draws the causal heads, by two conditional definitions added to InfraGeometry's primitive. Set heads are drawn by their density, chain heads by their graph, message and echo heads by the light rays that carry them, and `InfraRadarChart` by its radar domain. A substrate with a 3D embedding (`"CubicLatticeGraph"` and `"MinkowskiSprinkling3D"` under `"KeepCoordinates" -> True`) is drawn in the plane by the cabinet projection $(x, y, t) \mapsto (x + y/(2\sqrt 2), t + y/(2\sqrt 2))$; the substrate keeps its 3D points. The `"BaseGraph"` of a chart is drawn in the style of a `"Small"` substrate. Every colour is a `Standard*` colour.
- **New: the documentation.** Markdown sources in `docs/` (71 symbol pages and 5 guides, each guide ending in its experimental sections) are built to notebooks with MarkdownToNotebook. The 11 head pages are written in full, and the remaining 60 are stubs generated from `Kernel/Usage.wl`, which holds every usage string.
- **Tests:** 271 tests, organised by category under `Tests/<Category>/`. They assert mathematical invariants on small deterministic DAGs.
