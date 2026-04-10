BeginPackage[ "WolframInstitute`InfraCausality`" ];

$InfraCausalityKernelDir = DirectoryName[ $InputFileName ];

Get[ FileNameJoin[ { $InfraCausalityKernelDir, "Tools.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "LightRays.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "BondiKCalculus.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "EPS.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "KnuthKinematics.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "LightRaysVisualization.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "BondiVisualization.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "EPSVisualization.wl" } ] ];

EndPackage[];
