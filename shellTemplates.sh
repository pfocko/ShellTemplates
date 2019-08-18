#!/bin/sh

# Load names of all environment variables
envVarNames=$(env | grep -o '^[A-Za-z_][A-Za-z0-9_]*=' | tr -d '=')

unset replaceExpr

for envVarName in $envVarNames
do
    # Get value of environment variable
    eval envVarValue=\$$envVarName

    # Replace special characters in environment variable with shellTemplates constant expressions
    envVarValue=$(echo $envVarValue | awk '{gsub(" ","<%!SP!%>");gsub("\t","<%!TB!%>");gsub("$","<%!NL!%>");gsub("\\$","<%!DL!%>");gsub("\\\\","<%!BS!%>");print}')
    envVarValue=$(echo $envVarValue | tr -d ' ' | awk '{gsub("<%!NL!%>$", "");print}')

    # Append gsub function to awk replace expression
    replaceExpr=$replaceExpr"gsub(\"<%\\\\$ $envVarName \\\\$%>\",\"$envVarValue\");"
done

# Assemble complete awk expression
replaceExpr='{'$replaceExpr'print}'

function interpretFile {
    # Interpret shellTemplates variable expressions
    awk "$replaceExpr" $1 > $1.tmp &&

    # Interpret shellTemplates constant expressions
    awk '{gsub("<%!SP!%>"," ");gsub("<%!TB!%>","\t");gsub("<%!DL!%>","$");gsub("<%!BS!%>","\\");gsub("<%!NL!%>","\n");print}' $1.tmp > $1 &&
    rm $1.tmp

    return $?
}

returnCode=0

# Interpret files obtained in args
for file in $@
do  
    interpretFile $file

    # Check for error return code
    if [ $? -ne 0 ]        
    then
        echo "Error occured during interpretation of $1" 1>&2
        returnCode=1
    fi
done

exit $returnCode
