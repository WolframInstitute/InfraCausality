---
Template: Guide
Name: InfraObservers
Title: Infra Observers
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/InfraObservers
Keywords: [observer, message function, echo function, Ehlers-Pirani-Schild, EPS axioms, radar coordinates, radar chart, observer space, fibration]
RelatedGuides: [CausalInfrageometry, CausalTime, CausalSubstrates, BondiKCalculus, Experimental]
---

## Abstract

An observer is a saturated chain, its positions the ticks of a clock. Two observers exchange light: the message relation sends a tick of $a$ to the ticks of $b$ it reaches by a light ray, and the echo relation returns the message to $a$. A single-valued selection of the relation that preserves the tick order is a message function in the sense of Ehlers, Pirani and Schild (axiom D1); the message and echo heads are read for their relation, their graph and the number of such functions, and their random samplers draw one. The radar chart of an observer assigns to every event in its radar domain the emission tick $i$ of the latest tick that can signal the event and the reception tick $j$ of the earliest tick the event can signal, hence the radar time $(i + j)/2$ and the radar distance $(j - i)/2$; a list of observers joins their charts. The observer space is the causal graph fibered over the chart: the "Fibration" reading hands InfraGeometry an `InfraFibration` whose fibers are the events an observer cannot tell apart, on which sections, connections and holonomy are read with the Infra Fiber Bundles guide.

## Functions

### Messages and echoes

- `InfraMessageFunction` the message relation from observer $a$ to observer $b$, $v \mapsto E^+(v) \cap b$, whose members are its monotone single-valued selections
- `InfraEchoFunction` the echo relation of $a$ via $b$, a message to $b$ returned to $a$, whose members are the monotone compositions of two selections

- `InfraMessageFunctionQ`, `InfraEchoFunctionQ`

### Radar charts

- `InfraRadarChart` the radar chart of one observer or of a list of observers: radar time $(i + j)/2$ and radar distance $(j - i)/2$ of every event in the radar domain
- `InfraFibration` (InfraGeometry) the observer space, the radar domain fibered over the chart, from the "Fibration" reading
- `InfraFibers` (InfraGeometry), `InfraBaseGraph` (InfraGeometry), `InfraSection` (InfraGeometry), `InfraConnection` (InfraGeometry), `InfraHolonomy` (InfraGeometry)

### Experimental: selections

- `RandomInfraMessageFunction`, `RandomInfraEchoFunction` random monotone selections of a message or echo relation
