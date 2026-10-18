BeginTestSection[ "BondiFigures" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$initialValues = m |-> Cases[ m, { { s_Symbol, init_, _ }, ___ } :> ( s -> init ) ]

$constructionFrame = { m, name } |-> ReleaseHold[ Extract[ m, 1, Hold ] /. Prepend[ $initialValues[ m ], Extract[ m, { 2, 1, 1 } ] -> name ] ]

VerificationTest[
  With[ { m = BondiViewer[] },
    { Head @ m, Map[ name |-> Head @ $constructionFrame[ m, name ], Extract[ m, { 2, 2 } ] ] } ],
  { Manipulate, ConstantArray[ Graphics, 7 ] },
  TestID -> "BondiViewer-Initial-state-every-construction-draws"
]

EndTestSection[]
