#!/bin/sh

envVarNames=$(env | grep -o '^[A-Za-z_][A-Za-z0-9_]*=' | tr -d '=')

for envVarName in $envVarNames
do
    eval envVarValue=\$$envVarName
    sed -i "s^<%\$ $envVarName \$%>^$envVarValue^g" "$1"
done
