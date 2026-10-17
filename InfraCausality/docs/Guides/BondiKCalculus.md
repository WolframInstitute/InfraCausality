---
Template: Guide
Name: BondiKCalculus
Title: Bondi k-Calculus
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/guide/BondiKCalculus
Keywords: [Bondi k-calculus, k-factor, Doppler factor, special relativity, rapidity, Lorentz factor, radar coordinates, light zigzag]
RelatedGuides: [CausalInfrageometry, CausalTime, InfraObservers, CausalSubstrates, Experimental]
---

## Abstract

Bondi's k-calculus derives special relativity from the ratio $k$ between the period of a light signal as sent and as received. Drawn in the Euclidean plane with two straight worldlines from a common origin and light at a fixed angle, the k-factor is a ratio of arc lengths, and proper time is a logarithm of arc length. These functions are the continuum anchor of the paclet and take no graph; the graph analogue of the radar construction is the radar chart of the Infra Observers guide.

## Functions

### The k-factor

- `KFactor` the Bondi factor $k = \sqrt{(1 + v)/(1 - v)}$, or its angular form $\sqrt{\sin(\varphi + \alpha)/\sin(\varphi - \alpha)}$
- `VelocityFromK` the velocity $(k^2 - 1)/(k^2 + 1)$
- `LorentzGamma` the Lorentz factor $(k + 1/k)/2$
- `Rapidity`, `RapidityFromK` the rapidity $\operatorname{artanh} v = \log k$
- `ArcTanh` (WL)

### Worldlines in the Euclidean picture

- `WorldlineAngle` the angle $\arctan(v \tan \varphi)$ of the worldline of velocity $v$ against the time axis, for light at angle $\varphi$
- `OutgoingRatio`, `IncomingRatio` the arc-length ratios $\sin\varphi / \sin(\varphi - \alpha)$ and $\sin(\varphi + \alpha)/\sin\varphi$, whose product is $k^2$

### Radar coordinates

- `LightZigzag` the light signal bouncing between two worldlines, as emission events and arc lengths
- `BondiRadarCoordinates` the radar time and radar distance of a plane event from the observer at rest
