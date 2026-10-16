Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: Kernel :: Usage *)

GetSources::usage = "GetSources[g] gives the sources of the directed graph g, the vertices of in-degree zero.";
GetSinks::usage = "GetSinks[g] gives the sinks of the directed graph g, the vertices of out-degree zero.";
RandomCausalGraph::usage = "RandomCausalGraph[{n, m}] gives a random connected directed acyclic graph with n vertices and m edges, an acyclic orientation of a random connected graph.";
FindChain::usage = "FindChain[g, p, q, n] gives up to n longest chains from p to q, and FindChain[g, n] up to n source-to-sink chains of decreasing length; option \"Method\" -> \"Longest\" | \"Separated\".";

ForwardLightCone::usage = "ForwardLightCone[g, v, len] gives the subgraph of g induced on the events reached from v by a directed path of at most len edges, the causal future of v when len is Infinity.";
BackwardLightCone::usage = "BackwardLightCone[g, v, len] gives the subgraph of g induced on the events reaching v by a directed path of at most len edges, the causal past of v when len is Infinity.";
CausalInterval::usage = "CausalInterval[g, p, q] gives the subgraph of g induced on the causal diamond of p and q, the events in the causal future of p and the causal past of q.";
ChainCausalInterval::usage = "ChainCausalInterval[g, c] gives the causal hull of the vertex list c, the events both reached from c and reaching c, as a vertex list.";
UniversalFoliation::usage = "UniversalFoliation[g] gives the level sets of UniversalTime[g] as sorted vertex lists, slice k holding the events whose longest chain from a source has k edges.";
UniversalTime::usage = "UniversalTime[g] gives the height of every event, the number of edges of a longest chain from a source to it, zero exactly on the sources; UniversalTime[g, foliation] indexes a given foliation.";
MaximalAbsorber::usage = "MaximalAbsorber[g] gives, for each slice k of the universal foliation, the events of the slice whose causal past has the most vertices.";
MaximalEmitter::usage = "MaximalEmitter[g] gives, for each slice k of the universal foliation, the events of the slice whose causal future has the most vertices.";
OutgoingLightRays::usage = "OutgoingLightRays[g, v] gives the events e in the causal future of v whose causal diamond with v is a chain, the vertex set of the outgoing light rays of v.";
IncomingLightRays::usage = "IncomingLightRays[g, v] gives the events e in the causal past of v whose causal diamond with v is a chain, the vertex set of the incoming light rays of v.";

VisualizeLightRays::usage = "VisualizeLightRays[g] gives an interactive drawing of g in which clicking an event highlights its outgoing and incoming light rays.";
VisualizeFoliatedCausalGraph::usage = "VisualizeFoliatedCausalGraph[g, foliation, chains] draws g with the slices of foliation and the given chains overlaid as coloured bands on its embedding.";
VisualizeMessageFunction::usage = "VisualizeMessageFunction[g, a, b] gives an interactive drawing of the observers a and b on g in which clicking a tick of a highlights its message images on b.";
VisualizeEchoFunction::usage = "VisualizeEchoFunction[g, a, b] draws the observers a and b on g, the static backdrop of an echo-function picture.";
BondiExplorer::usage = "BondiExplorer[] gives a Manipulate over the seven Bondi k-calculus constructions with sliders for velocity, light angle, bounces and a second velocity.";

MultiMessageFunction::usage = "MultiMessageFunction[g, a, b] gives the message relation from observer a to observer b, the association v -> the events of b on an outgoing light ray of v, for every v on a.";
FindMessageFunction::usage = "FindMessageFunction[g, a, b] gives every monotone single-valued selection of the message relation from a to b, and FindMessageFunction[g, a, b, n] the first n of them.";
MultiEchoFunction::usage = "MultiEchoFunction[g, a, b] gives the echo relation of a via b, the association v -> the events of a reached by light from the message images of v on b.";
FindEchoFunction::usage = "FindEchoFunction[g, a, b] gives every monotone single-valued echo map on a composed of single-valued message selections from a to b and from b to a; option \"MonotoneMessages\".";
EchoGraph::usage = "EchoGraph[f] gives the directed graph with an edge v -> w for every image w of v under the association f of message or echo images.";
MonotoneQ::usage = "MonotoneQ[a, b, f] tests EPS axiom D1 for f, that for v before w on a no position on b of an image of v exceeds a position of an image of w.";

$CausalColors::usage = "$CausalColors is the association of named colours used by the causal drawings.";
CausalGraphStyle::usage = "CausalGraphStyle[tier] gives the VertexStyle and EdgeStyle options of a causal graph drawing, tier being \"Default\", \"Opaque\", \"Faint\" or \"Gray\".";

KFactor::usage = "KFactor[v] gives the Bondi factor Sqrt[(1 + v)/(1 - v)], and KFactor[v, phi] its angular form Sqrt[Sin[phi + alpha]/Sin[phi - alpha]] with alpha = WorldlineAngle[v, phi].";
VelocityFromK::usage = "VelocityFromK[k] gives the velocity (k^2 - 1)/(k^2 + 1) of the Bondi factor k.";
WorldlineAngle::usage = "WorldlineAngle[v, phi] gives the Euclidean angle ArcTan[v Tan[phi]] between the worldline of velocity v and the time axis, for light at angle phi.";
Rapidity::usage = "Rapidity[v] gives the rapidity ArcTanh[v] of the velocity v.";
RapidityFromK::usage = "RapidityFromK[k] gives the rapidity Log[k] of the Bondi factor k.";
LorentzGamma::usage = "LorentzGamma[v] gives the Lorentz factor (k + 1/k)/2 with k = KFactor[v].";
OutgoingRatio::usage = "OutgoingRatio[v, phi] gives the arc-length ratio Sin[phi]/Sin[phi - alpha] from an emission on the rest worldline to its reception on the worldline of velocity v.";
IncomingRatio::usage = "IncomingRatio[v, phi] gives the arc-length ratio Sin[phi + alpha]/Sin[phi] from an emission on the worldline of velocity v to its reception on the rest worldline.";
WorldlineDirection::usage = "WorldlineDirection[v, phi] gives the unit direction {Sin[alpha], Cos[alpha]} of the worldline of velocity v, with alpha = WorldlineAngle[v, phi].";
WorldlinePoint::usage = "WorldlinePoint[v, s, phi] gives the point at Euclidean arc length s from the origin on the worldline of velocity v.";
WorldlineNormal::usage = "WorldlineNormal[v, phi] gives the unit normal {Cos[alpha], -Sin[alpha]} to the worldline of velocity v, with alpha = WorldlineAngle[v, phi].";
ProperTimeScale::usage = "ProperTimeScale[v, phi] gives the ratio KFactor[v, phi]/OutgoingRatio[v, phi] of proper time to Euclidean arc length on the worldline of velocity v.";
WorldlinePointAtProperTime::usage = "WorldlinePointAtProperTime[v, tau, phi] gives the point at proper time tau on the worldline of velocity v.";
LightDirection::usage = "LightDirection[phi, right] gives the unit direction of a light ray at angle phi to the time axis, pointing to positive x when right is True.";
LightZigzag::usage = "LightZigzag[v, s0, n, phi] gives the n + 1 reflection events of light bouncing between the rest worldline and the worldline of velocity v from arc length s0, as associations.";
RadarCoordinatesFromAlice::usage = "RadarCoordinatesFromAlice[{x, y}, phi] gives the radar time, the radar distance and the emission and return arc lengths of the plane event {x, y} for the observer at rest.";
SimultaneityLine::usage = "SimultaneityLine[v, s, phi, extent] gives the two light-ray ends and the base point of the simultaneity line of the worldline of velocity v at arc length s.";

ChainProjection::usage = "ChainProjection[g, a, b] gives the number of events of the chain b in the causal future of the chain a divided by the length of a; \"Method\" -> \"LightRays\" uses the light rays of a.";
ChainLightReach::usage = "ChainLightReach[g, c] gives the union of the vertex sets of the outgoing light rays of the events of the chain c.";
InfraEnergy::usage = "InfraEnergy[p, q] gives the Knuth energy (p + q)/2 of the projection pair p, q.";
InfraMomentum::usage = "InfraMomentum[p, q] gives the Knuth momentum (p - q)/2 of the projection pair p, q.";
InfraMass::usage = "InfraMass[p, q] gives the Knuth mass Sqrt[Abs[p q]] of the projection pair p, q.";
InfraInterval::usage = "InfraInterval[p, q] gives the Knuth squared interval p q of the projection pair p, q.";
InfraVelocity::usage = "InfraVelocity[p, q] gives the Knuth velocity (p - q)/(p + q) of the projection pair p, q.";
InfraKinematics::usage = "InfraKinematics[g, ref, targets] gives the projections of the chain ref onto each target chain and the Knuth scalars of every pair of projections, as an association.";

BondiClock::usage = "BondiClock[v, n] draws the rest worldline and the worldline of velocity v with a light signal bouncing n times between them and proper-time ticks.";
DopplerConstruction::usage = "DopplerConstruction[v, n] draws n evenly spaced light pulses from the rest worldline to the worldline of velocity v, showing the Bondi factor as a pulse-spacing ratio.";
TimeDilationConstruction::usage = "TimeDilationConstruction[v] draws the radar construction of one event on the worldline of velocity v, illustrating the time dilation gamma = (k + 1/k)/2.";
SimultaneityConstruction::usage = "SimultaneityConstruction[v] draws the simultaneity lines of the rest observer and the observer of velocity v at a common arc length, illustrating the relativity of simultaneity.";
LengthContractionConstruction::usage = "LengthContractionConstruction[v] draws the radar measurement of a rod moving at velocity v by the rest observer, illustrating the contracted length L/gamma.";
VelocityAdditionConstruction::usage = "VelocityAdditionConstruction[v1, v2] draws three worldlines with Bondi factors k1, k2 and k1 k2, illustrating that composing velocities multiplies Bondi factors.";
LightClockConstruction::usage = "LightClockConstruction[v, n] draws a transverse light clock carried by the observer of velocity v, with n bounces between observer and mirror.";
