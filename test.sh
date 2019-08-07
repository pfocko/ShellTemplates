#!/bin/sh

source ./tests/env.sh

echo "====> TESTING <===="
echo ""

testsCount=$(ls tests | grep ".*\.original$" | wc -l)
passedTestsCount=0

for testFile in $(ls tests | grep ".*\.original$" | sed 's/\.original$//g')
do
    echo "====> Testing $testFile <===="
    cp tests/$testFile.original tests/$testFile

    ./shellTemplates.sh tests/$testFile

    if cmp -s tests/$testFile tests/$testFile.desired
    then
        echo "==> SUCCESS!"
        let "passedTestsCount++"
    else
        echo "==> FAILURE!"
        echo "==> Expected:"
        cat tests/$testFile.desired
        echo "==> Received:"
        cat tests/$testFile
    fi

    rm tests/$testFile
    echo ""
done

echo "====> SUMMARY <===="
echo "==> $passedTestsCount/$testsCount tests passed."
