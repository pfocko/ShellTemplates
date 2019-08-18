#!/bin/sh

envVarNames=$(env | grep -o '^[A-Za-z_][A-Za-z0-9_]*=' | tr -d '=')

unset awkExpr

for envVarName in $envVarNames
do
    eval envVarValue=\$$envVarName
    envVarValue=$(echo $envVarValue | awk '{gsub(" ","<%!SP!%>");gsub("\t","<%!TB!%>");gsub("$","<%!NL!%>");gsub("\\$","<%!DL!%>");gsub("\\\\","<%!BS!%>");print}')
    envVarValue=$(echo $envVarValue | tr -d ' ' | awk '{gsub("<%!NL!%>$", "");print}')    
    awkExpr=$awkExpr"gsub(\"<%\\\\$ $envVarName \\\\$%>\",\"$envVarValue\");"
done

awkExpr='{'$awkExpr'print}'

function interpretFile {
    awk "$awkExpr" $1 > $1.tmp
    awk '{gsub("<%!SP!%>"," ");gsub("<%!TB!%>","\t");gsub("<%!DL!%>","$");gsub("<%!BS!%>","\\");gsub("<%!NL!%>","\n");print}' $1.tmp > $1
    rm $1.tmp
}

interpretFile $1
