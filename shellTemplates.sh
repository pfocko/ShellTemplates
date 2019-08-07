#!/bin/sh

envVarNames=$(env | grep -o '^[A-Za-z_][A-Za-z0-9_]*=' | tr -d '=')

for envVarName in $envVarNames
do
    eval envVarValue=\$$envVarName    
    awkExpr=$awkExpr"sub(\"<%\\\\$ $envVarName \\\\$%>\", \"$envVarValue\"); "
done

awkExpr='{'$awkExpr'print}'

awk "$awkExpr" $1 > $1.tmp
mv $1.tmp $1
