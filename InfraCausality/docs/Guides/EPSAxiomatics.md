---
Template: Guide
Name: EPSAxiomatics
Title: EPS Axiomatics
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/EPSAxiomatics
Keywords: [EPS axioms, observer, clock, message function, echo function, axiom D1, radar coordinates, axiom D2, radar domain, observer space, fibration, message selection, echo selection, joined radar coordinates, EPS defects, k-factor]
RelatedGuides: [CausalInfrageometry, CausalTime, CausalSubstrates, BondiKCalculus]
RelatedTutorials: [CausalInfrageometryTutorial]
---

## Abstract

The EPS axiomatisation (Ehlers, Pirani and Schild) builds the geometry of spacetime from what observers can do: light rays fix the conformal structure, freely falling particles the projective structure, and observers exchanging light signals read both off their clocks. On a graph the ingredients are the heads of the Causal Infrageometry guide: events are vertices, light rays are the members of the light cones (axiom L), freely falling particles are the timelike geodesics (axiom P), and an observer is a worldline whose positions are read as the ticks of a clock. The compatibility axiom C, that light rays are the null geodesics of the projective structure, has no construction on a graph yet and is open.

This guide holds the constructions of the axioms D on the observers. Two observers $a$ and $b$ exchange light: the message relation sends a tick of $a$ to the ticks of $b$ it reaches by a light ray, and the echo relation returns the message to $a$. Axiom D1 asks the message to be a monotone map of the clock of $a$ into the clock of $b$; on a graph the relation is set-valued and partial, its monotone single-valued selections are the message functions, an echo function is the composition of a message function to $b$ with one back to $a$, and the axiom holds exactly when the relation is itself such a map. Axiom D2 asks the clocks to coordinatise the events: the radar coordinates of an observer give every event of its radar domain the emission tick $i$ of the latest tick that can signal it and the reception tick $j$ of the earliest tick it can signal, hence the radar time $(i + j)/2$ and the radar distance $(j - i)/2$, and the axiom holds when the coordinates are injective. Since the distance is unsigned, a single observer in $1 + 1$ dimensions sees the two sides of its worldline folded onto each other; the observer space, the radar domain fibered over the coordinate cells, records what the observers cannot tell apart, and the defects and the graph k-factor measure how far a pair of observers is from the axioms.

## Functions

### Axiom D1: message and echo functions

- `InfraMessageFunction` the message relation from observer $a$ to observer $b$, $v \mapsto E^+(v) \cap b$, whose members are its monotone single-valued selections, read for its relation, its graph, its selection graph and the number of its members
- `InfraEchoFunction` the echo relation of $a$ via $b$, a message to $b$ returned to $a$, whose members are the compositions $f_{ba} \circ f_{ab}$ of two message functions
- `RandomInfraMessageFunction` random message functions, drawn uniformly by the path weights of the selection graph; All enumerates them
- `RandomInfraEchoFunction` random echo functions, drawn uniformly from the distinct compositions; All enumerates them

- `InfraMessageFunctionQ`, `InfraEchoFunctionQ`, `EPSMessageAxiomQ`

### Axiom D2: radar coordinates

- `InfraRadarCoordinates` the radar coordinates of one observer: radar time $(i + j)/2$ and radar distance $(j - i)/2$ of every event in the radar domain, with its time and distance marginals, its domain (a set head, read by its vertex density), the directed subgraph on the domain and the base graph on the coordinate cells
- `InfraRadarCoordinates` of a list of observers, the joined radar coordinates: the coordinates concatenated on the common radar domain; a second observer unfolds the mirror of the first

- `EPSRadarAxiomQ`

### The observer space

- `InfraMeasurement` (InfraGeometry) of a chart: "Fibration", the observer space, the undirected radar domain fibered over the chart, whose fibers are the events the observers cannot tell apart, singletons exactly under axiom D2
- `InfraFiberedGraph` (InfraGeometry), `InfraFibers` (InfraGeometry), `InfraBaseSpace` (InfraGeometry), `InfraSection` (InfraGeometry), `InfraConnection` (InfraGeometry), `InfraHolonomy` (InfraGeometry)

- `InfraFibrationQ` (InfraGeometry), `InfraFiberBundleQ` (InfraGeometry)

### Distance from the axioms

- `InfraMeasurement` (InfraGeometry) of a message or echo relation: "DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect", how far the relation is from a monotone bijection on the window of $a$ left by the option "Margin", all four zero exactly under axiom D1; a tie of single images counts against injectivity, not order
- `InfraMeasurement` (InfraGeometry) of a message or echo relation: "KFactor", the Bondi factor of two observers from their tick-span ratios, exact on the lattice for the echo of $\{(m, m)\}$ via the chains $\{((p+1)m, pm)\}$ of velocity $1/(2p+1)$
