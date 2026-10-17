---
Template: Guide
Name: Experimental
Title: Experimental Functions
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/Experimental
Keywords: [experimental, Knuth kinematics, chain projection, extremal events, message selection, echo selection, Bondi figures]
RelatedGuides: [CausalInfrageometry, CausalTime, InfraObservers, CausalSubstrates, BondiKCalculus]
---

## Abstract

Research functions not yet settled into a category: the Knuth kinematics of chain pairs, the extremal events of each slice, the exponential enumeration of monotone message and echo selections, and the Bondi figures with the drawing helpers behind them. Reserved: the causal-set estimators on a diamond and the EPS defects.

## Functions

### Knuth kinematics

- `ChainProjection` the fraction of a chain whose causal future, or whose light cone, meets a second chain
- `ChainLightReach` the union of the future light cones of the events of a chain
- `InfraKinematics` the projections of a reference chain onto target chains and the Knuth scalars $E = (p + q)/2$, $P = (p - q)/2$, $m = \sqrt{|pq|}$, $\beta = (p - q)/(p + q)$ of every target pair

### Extremal events

- `MaximalAbsorber`, `MaximalEmitter` per slice of the universal foliation, the events of largest causal past or causal future

### Message and echo selections

- `RandomInfraMessageFunction` random monotone single-valued selections of a message relation; All enumerates them
- `RandomInfraEchoFunction` random monotone compositions of two message selections

### Bondi figures

- `BondiClock`, `DopplerConstruction`, `TimeDilationConstruction`, `SimultaneityConstruction`, `LengthContractionConstruction`, `VelocityAdditionConstruction`, `LightClockConstruction` the seven k-calculus constructions as graphics
- `WorldlineDirection`, `WorldlinePoint`, `WorldlineNormal`, `WorldlinePointAtProperTime`, `ProperTimeScale`, `LightDirection`, `SimultaneityLine` the plane geometry behind the figures
