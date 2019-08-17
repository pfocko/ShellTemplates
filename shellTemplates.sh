#!/bin/sh

envVarNames=$(env | grep -o '^[A-Za-z_][A-Za-z0-9_]*=' | tr -d '=')

unset awkExpr

for envVarName in $envVarNames
do
    eval envVarValue=\$$envVarName    
    awkExpr=$awkExpr"gsub(\"<%\\\\$ $envVarName \\\\$%>\", \"$envVarValue\");"
done

awkExpr='{'$awkExpr'print}'

function interpretFile {
    awk "$awkExpr" $1 > $1.tmp
    mv $1.tmp $1
}

interpretFile $1
