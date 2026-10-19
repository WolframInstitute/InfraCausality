Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: Kernel :: Usage *)

InfraCausalFuture::usage = "InfraCausalFuture[v] is the causal future J+(v) of the event or event set v, the events reached from it; InfraCausalFuture[v, t] keeps those whose longest chain from v has at most t edges.";
InfraCausalPast::usage = "InfraCausalPast[v] is the causal past J-(v) of the event or event set v, the events reaching it; InfraCausalPast[v, t] keeps those whose longest chain to v has at most t edges.";
RandomInfraCausalFuture::usage = "RandomInfraCausalFuture[g, InfraCausalFuture[v], n] gives the support of the causal future on g as a sorted vertex list, its only member; RandomInfraCausalFuture[g, v] is the shortcut.";
RandomInfraCausalPast::usage = "RandomInfraCausalPast[g, InfraCausalPast[v], n] gives the support of the causal past on g as a sorted vertex list, its only member; RandomInfraCausalPast[g, v] is the shortcut.";
InfraCausalFutureQ::usage = "InfraCausalFutureQ[g, set] gives True if the vertex list set is the causal future J+(v) on g of one of its elements v.";
InfraCausalPastQ::usage = "InfraCausalPastQ[g, set] gives True if the vertex list set is the causal past J-(v) on g of one of its elements v.";
InfraCausalDiamond::usage = "InfraCausalDiamond[p, q] is the causal diamond, J+(p) intersected with J-(q); InfraCausalDiamond[s] is the causal hull of the event set s, J+(s) intersected with J-(s).";
RandomInfraCausalDiamond::usage = "RandomInfraCausalDiamond[g, InfraCausalDiamond[p, q], n] gives the support of the diamond on g as a sorted vertex list, its only member; RandomInfraCausalDiamond[g, p, q] is the shortcut.";
InfraCausalDiamondQ::usage = "InfraCausalDiamondQ[g, set] gives True if the vertex list set has a least element p and a greatest element q on g and equals the causal diamond of p and q.";
InfraWorldline::usage = "InfraWorldline[p, q] is the set of timelike geodesics from p to q, every longest chain between them; InfraWorldline[p1, ..., pk] is the set of piecewise geodesics through the knots p1, ..., pk; InfraWorldline[p] is the set of longest chains starting at p; InfraWorldline[] is the set of longest chains of the graph.";
RandomInfraWorldline::usage = "RandomInfraWorldline[g, InfraWorldline[p, q], n] gives n distinct longest chains from p to q drawn uniformly as vertex lists; RandomInfraWorldline[g, p, q, n] and RandomInfraWorldline[g, n] are shortcuts.";
InfraWorldlineQ::usage = "InfraWorldlineQ[g, chain] gives True if the vertex list chain is a saturated chain on g whose number of edges is the longest-chain length from its first to its last event.";
InfraChainQ::usage = "InfraChainQ[g, list] gives True if the vertex list list is duplicate-free and each element precedes the next in the causal order of g.";
InfraObserver::usage = "InfraObserver[p, q] is the set of observers from p to q, every saturated chain between them; InfraObserver[] is the set of inextendible saturated chains, source to sink.";
RandomInfraObserver::usage = "RandomInfraObserver[g, InfraObserver[p, q], n] gives n distinct saturated chains from p to q drawn uniformly as vertex lists; RandomInfraObserver[g, p, q, n] and RandomInfraObserver[g, n] are shortcuts.";
InfraObserverQ::usage = "InfraObserverQ[g, chain] gives True if the vertex list chain is a saturated chain on g, each pair of consecutive events an edge of the Hasse diagram.";
InfraFutureLightCone::usage = "InfraFutureLightCone[v] is the future light cone of v, the events e whose causal diamond with v is a chain; its members are the outgoing light rays, the maximal chains of the cone from v.";
InfraPastLightCone::usage = "InfraPastLightCone[v] is the past light cone of v, the events e whose causal diamond with v is a chain; its members are the incoming light rays, the maximal chains of the cone into v.";
RandomInfraFutureLightCone::usage = "RandomInfraFutureLightCone[g, InfraFutureLightCone[v], n] gives n distinct outgoing light rays of v drawn uniformly as vertex lists; RandomInfraFutureLightCone[g, v, n] is the shortcut.";
RandomInfraPastLightCone::usage = "RandomInfraPastLightCone[g, InfraPastLightCone[v], n] gives n distinct incoming light rays of v drawn uniformly as vertex lists ending at v; RandomInfraPastLightCone[g, v, n] is the shortcut.";
InfraLightRayQ::usage = "InfraLightRayQ[g, chain] gives True if the vertex list chain is a saturated chain on g equal to the causal diamond of its first and last events.";

ChainProjection::usage = "ChainProjection[g, a, b] gives the fraction of the events of the chain a whose causal future meets the chain b; \"Method\" -> \"LightRays\" uses their future light cones instead.";
ChainLightReach::usage = "ChainLightReach[g, c] gives the union of the vertex sets of the outgoing light rays of the events of the chain c.";
InfraKinematics::usage = "InfraKinematics[g, ref, targets] gives the projections of the chain ref onto the target chains and, for every pair p, q of them, the Knuth energy, momentum, mass, interval and velocity.";

LightConeViewer::usage = "LightConeViewer[g] gives a Manipulate drawing g in which clicking an event v highlights its causal future and past and its future and past light cones.";
MessageFunctionViewer::usage = "MessageFunctionViewer[g, a, b] gives a Manipulate drawing the observers a and b on g in which choosing a tick of a highlights its message images on b and the light rays carrying them.";
FoliationViewer::usage = "FoliationViewer[g] gives a Manipulate with a slider over the universal time k drawing the slice InfraSlice[k] over the earlier band InfraSlice[{0, k - 1}].";

UniversalTime::usage = "UniversalTime[g] gives the height of every event, the number of edges of a longest chain from a source to it, zero exactly on the sources.";
UniversalFoliation::usage = "UniversalFoliation[g] gives the level sets of UniversalTime[g] as sorted vertex lists, slice k holding the events whose longest chain from a source has k edges.";
InfraSlice::usage = "InfraSlice[k] is the slice of the universal time at height k, the events t(v) = k; InfraSlice[{k1, k2}] is the band of events with k1 <= t(v) <= k2.";
RandomInfraSlice::usage = "RandomInfraSlice[g, InfraSlice[k], n] gives the support of the slice or band on g as a sorted vertex list, its only member; RandomInfraSlice[g, k] is the shortcut.";
InfraSliceQ::usage = "InfraSliceQ[g, set] gives True if the vertex list set is a nonempty level set of UniversalTime[g].";
InfraAntichainQ::usage = "InfraAntichainQ[g, set] gives True if the vertex list set is duplicate-free and no two of its elements are comparable in the causal order of g.";

MaximalAbsorber::usage = "MaximalAbsorber[g] gives, for each slice k of the universal foliation, the sorted events of the slice whose causal past has the most vertices.";
MaximalEmitter::usage = "MaximalEmitter[g] gives, for each slice k of the universal foliation, the sorted events of the slice whose causal future has the most vertices.";

InfraMessageFunction::usage = "InfraMessageFunction[a, b] is the message relation from observer a to observer b, v -> the events of b in the future light cone of v; its members are the monotone single-valued selections.";
InfraEchoFunction::usage = "InfraEchoFunction[a, b] is the echo relation of observer a via observer b, v -> the events of a lit from the message images of v; its members are the compositions of two message functions, one from a to b and one back, on the ticks whose signal returns.";
InfraMessageFunctionQ::usage = "InfraMessageFunctionQ[g, InfraMessageFunction[a, b], f] gives True if the association f picks one message image on b for every tick of a that has one and preserves the order (EPS D1).";
InfraEchoFunctionQ::usage = "InfraEchoFunctionQ[g, InfraEchoFunction[a, b], f] gives True if the association f is the composition of two message functions, one from a to b and one back, decided by a path search in the selection DAG without enumerating them.";
InfraRadarChart::usage = "InfraRadarChart[a] is the radar chart of the observer a, giving each event between its ticks the radar time (i + j)/2 and distance (j - i)/2 of its emission tick i and reception tick j; a list of observers joins charts.";

RandomInfraMessageFunction::usage = "RandomInfraMessageFunction[g, InfraMessageFunction[a, b], n] gives n distinct monotone selections of the message relation as associations, drawn uniformly; All enumerates them.";
RandomInfraEchoFunction::usage = "RandomInfraEchoFunction[g, InfraEchoFunction[a, b], n] gives n distinct echo functions of a via b, compositions of two message functions, as associations; All enumerates them.";

CausalSubstrate::usage = "CausalSubstrate[name, size] gives the named causal graph at size \"Small\", \"Medium\" or \"Large\", a transitively reduced DAG; CausalSubstrate[] lists the names by group.";
CausalSubstrateStyle::usage = "CausalSubstrateStyle[size] gives the Graph options a causal substrate of size \"Small\", \"Medium\" or \"Large\" is drawn with; CausalSubstrateStyle[name, size] those of a named substrate.";
CausalSubstrateCode::usage = "CausalSubstrateCode[name, size] gives the held code that builds CausalSubstrate[name, size].";
RandomCausalGraph::usage = "RandomCausalGraph[{n, p}] gives the Hasse diagram of a transitive percolation on events 1..n with link probability p; {n, m} orients a random connected graph, Method -> {\"Sprinkling\", d} sprinkles.";

KFactor::usage = "KFactor[v] gives the Bondi factor Sqrt[(1 + v)/(1 - v)], and KFactor[v, phi] its angular form Sqrt[Sin[phi + alpha]/Sin[phi - alpha]] with alpha = WorldlineAngle[v, phi].";
VelocityFromK::usage = "VelocityFromK[k] gives the velocity (k^2 - 1)/(k^2 + 1) of the Bondi factor k.";
LorentzGamma::usage = "LorentzGamma[v] gives the Lorentz factor (k + 1/k)/2 with k = KFactor[v].";
Rapidity::usage = "Rapidity[v] gives the rapidity ArcTanh[v] of the velocity v.";
RapidityFromK::usage = "RapidityFromK[k] gives the rapidity Log[k] of the Bondi factor k.";
WorldlineAngle::usage = "WorldlineAngle[v, phi] gives the Euclidean angle ArcTan[v Tan[phi]] between the worldline of velocity v and the time axis, for light at angle phi.";
OutgoingRatio::usage = "OutgoingRatio[v, phi] gives the arc-length ratio Sin[phi]/Sin[phi - alpha] from an emission on the rest worldline to its reception on the worldline of velocity v.";
IncomingRatio::usage = "IncomingRatio[v, phi] gives the arc-length ratio Sin[phi + alpha]/Sin[phi] from an emission on the worldline of velocity v to its reception on the rest worldline.";
ProperTimeScale::usage = "ProperTimeScale[v, phi] gives the ratio of proper time to Euclidean arc length on the worldline of velocity v for light at angle phi, KFactor[v, phi]/OutgoingRatio[v, phi].";
LightZigzag::usage = "LightZigzag[v, s0, n, phi] gives the n + 1 reflection events of light bouncing between the rest worldline and the worldline of velocity v from arc length s0, as associations.";
BondiRadarCoordinates::usage = "BondiRadarCoordinates[{x, y}, phi] gives the radar time, the radar distance and the emission and return arc lengths of the plane event {x, y} for the observer at rest.";

BondiClock::usage = "BondiClock[v, n] draws the rest worldline and the worldline of velocity v with a light signal bouncing n times between them and proper-time ticks.";
DopplerConstruction::usage = "DopplerConstruction[v, n] draws n evenly spaced light pulses from the rest worldline to the worldline of velocity v, showing the Bondi factor as a pulse-spacing ratio.";
TimeDilationConstruction::usage = "TimeDilationConstruction[v] draws the radar construction of one event on the worldline of velocity v, illustrating the time dilation gamma = (k + 1/k)/2.";
SimultaneityConstruction::usage = "SimultaneityConstruction[v] draws the simultaneity lines of the rest observer and the observer of velocity v at a common arc length, illustrating the relativity of simultaneity.";
LengthContractionConstruction::usage = "LengthContractionConstruction[v] draws the radar measurement of a rod moving at velocity v by the rest observer, illustrating the contracted length L/gamma.";
VelocityAdditionConstruction::usage = "VelocityAdditionConstruction[v1, v2] draws three worldlines with Bondi factors k1, k2 and k1 k2, illustrating that composing velocities multiplies Bondi factors.";
LightClockConstruction::usage = "LightClockConstruction[v, n] draws a transverse light clock carried by the observer of velocity v, with n bounces between observer and mirror.";

WorldlineDirection::usage = "WorldlineDirection[v, phi] gives the unit direction {Sin[alpha], Cos[alpha]} of the worldline of velocity v, with alpha = WorldlineAngle[v, phi].";
WorldlinePoint::usage = "WorldlinePoint[v, s, phi] gives the point at Euclidean arc length s from the origin on the worldline of velocity v.";
WorldlineNormal::usage = "WorldlineNormal[v, phi] gives the unit normal {Cos[alpha], -Sin[alpha]} to the worldline of velocity v, with alpha = WorldlineAngle[v, phi].";
WorldlinePointAtProperTime::usage = "WorldlinePointAtProperTime[v, tau, phi] gives the point at proper time tau on the worldline of velocity v.";
LightDirection::usage = "LightDirection[phi, right] gives the unit direction of a light ray at angle phi to the time axis, pointing to positive x when right is True.";
SimultaneityLine::usage = "SimultaneityLine[v, s, phi, extent] gives {left end, base point, right end} of the simultaneity line through the point at arc length s on the worldline of velocity v: the events whose radar midpoint on that worldline is the base point, along {Tan[phi], v} and extent to each side.";

BondiViewer::usage = "BondiViewer[] gives a Manipulate over the seven Bondi k-calculus constructions with sliders for velocity, light angle, bounces and a second velocity.";
