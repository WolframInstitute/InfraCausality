---
Template: Guide
Name: EPSAxiomatics
Title: EPS Axiomatics
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/EPSAxiomatics
Keywords: [EPS axioms, Ehlers-Pirani-Schild, observer, clock, message function, echo function, axiom D1, radar coordinates, axiom D2, radar domain, observer space, fibration, message selection, echo selection, joined radar coordinates, EPS defects, k-factor]
RelatedGuides: [CausalInfrageometry, CausalTime, CausalSubstrates, BondiKCalculus]
RelatedTutorials: [CausalInfrageometryTutorial]
---

## Abstract

An observer is a worldline, a saturated chain, whose positions are read as the ticks of a clock. Two observers exchange light: the message relation sends a tick of $a$ to the ticks of $b$ it reaches by a light ray, and the echo relation returns the message to $a$. A single-valued selection of the relation that preserves the tick order is a message function in the sense of Ehlers, Pirani and Schild (axiom D1); an echo function is the composition of a message function to $b$ with a message function back to $a$. The message and echo heads are read for their relation, their graph and the number of such functions. The radar coordinates of an observer assign to every event in its radar domain the emission tick $i$ of the latest tick that can signal the event and the reception tick $j$ of the earliest tick the event can signal, hence the radar time $(i + j)/2$ and the radar distance $(j - i)/2$; the distance is unsigned, so a single observer in $1 + 1$ dimensions sees the two sides of its worldline folded onto each other.

## Functions

### Messages and echoes

- `InfraMessageFunction` the message relation from observer $a$ to observer $b$, $v \mapsto E^+(v) \cap b$, whose members are its monotone single-valued selections
- `InfraEchoFunction` the echo relation of $a$ via $b$, a message to $b$ returned to $a$, whose members are the compositions $f_{ba} \circ f_{ab}$ of two message functions

- `RandomInfraMessageFunction` random message functions, drawn uniformly by the path weights of the selection graph; All enumerates them
- `RandomInfraEchoFunction` random echo functions, drawn uniformly from the distinct compositions; All enumerates them

- `InfraMessageFunctionQ`, `InfraEchoFunctionQ`

### Radar coordinates

- `InfraRadarCoordinates` the radar coordinates of one observer: radar time $(i + j)/2$ and radar distance $(j - i)/2$ of every event in the radar domain, with its time and distance marginals, its domain (a set head, read by its vertex density), the directed subgraph on the domain and the base graph on the coordinate cells
- `InfraRadarCoordinates` of a list of observers, the joined radar coordinates: the coordinates concatenated on the common radar domain; a second observer unfolds the mirror of the first

### The observer space

- `InfraMeasurement` (InfraGeometry) of a chart: "Fibration", the observer space, the undirected radar domain fibered over the chart, whose fibers are the events the observer cannot tell apart
- `InfraFibration` (InfraGeometry), `InfraFibers` (InfraGeometry), `InfraBaseGraph` (InfraGeometry), `InfraSection` (InfraGeometry), `InfraConnection` (InfraGeometry), `InfraHolonomy` (InfraGeometry)

- `InfraFibrationQ` (InfraGeometry), `InfraFiberBundleQ` (InfraGeometry)

### Distance from the axioms

- `InfraMeasurement` (InfraGeometry) of a message or echo relation: "DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect", how far the relation is from a monotone bijection on the window left by the option "Margin", and "KFactor", the Bondi factor of two observers from their tick-span ratios, exact on the lattice for the chains $\{((p+1)m, pm)\}$ of velocity $1/(2p+1)$
