BeginPackage[ "WolframInstitute`InfraCausality`" ];

$InfraCausalityKernelDir = DirectoryName[ $InputFileName ];

Get[ FileNameJoin[ { $InfraCausalityKernelDir, "Tools.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "LightRays.wl" } ] ];
Get[ FileNameJoin[ { $InfraCausalityKernelDir, "LightRaysVisualization.wl" } ] ];

EndPackage[];
