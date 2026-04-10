#!/usr/bin/env wolframscript

(* run_tests.wls — Run InfraCausality paclet test suite *)

$pacletDir = DirectoryName[$InputFileName];

PacletDirectoryLoad[$pacletDir <> "/InfraCausality"];
Needs["WolframInstitute`InfraCausality`"];

$testDir = FileNameJoin[{$pacletDir, "InfraCausality", "Tests"}];
$testFiles = FileNames["*.wlt", $testDir];

If[$testFiles === {},
    Print["No test files found in ", $testDir];
    Exit[1]
];

Print["Running ", Length[$testFiles], " test file(s) from ", $testDir];
Print[""];

report = TestReport[$testFiles];

passed = Length[report["TestsSucceededIndices"]];
failed = Length[report["TestsFailedIndices"]];
errored = Length[report["TestsFailedWithErrorsIndices"]];
total = Length[report["TestResults"]];

Print[""];
Print["===== Test Summary ====="];
Print["Total:   ", total];
Print["Passed:  ", passed];
Print["Failed:  ", failed];
Print["Errors:  ", errored];
Print[""];

If[failed > 0 || errored > 0,
    Print["FAILED TESTS:"];
    Scan[
        Function[idx,
            With[{tr = report["TestResults"][idx]},
                Print["  ", tr["TestID"], " — ", tr["Outcome"]];
                If[tr["Outcome"] === "Failure",
                    Print["    Expected: ", tr["ExpectedOutput"]];
                    Print["    Actual:   ", tr["ActualOutput"]];
                ];
                If[tr["Outcome"] === "Error",
                    Print["    Messages: ", tr["ActualMessages"]];
                ];
            ]
        ],
        Join[report["TestsFailedIndices"], report["TestsFailedWithErrorsIndices"]]
    ];
    Print[""];
];

If[report["AllTestsSucceeded"],
    Print["All tests passed!"];
    Exit[0],
    Print["Some tests failed."];
    Exit[1]
]
