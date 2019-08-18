#!/bin/sh

# Load environment variables
source ./tests/env.sh

echo "====> TESTING <===="
echo ""

# Init info-variables
testsCount=$(ls tests | grep ".*\.original$" | wc -l)
passedTestsCount=0

# Get all files with '.original' postfix
for testFile in $(ls tests | grep ".*\.original$" | sed 's/\.original$//g')
do
    echo "====> Testing $testFile <===="

    # Create test file
    cp tests/$testFile.original tests/$testFile

    # Execute shellTemplates on test file
    ./shellTemplates.sh tests/$testFile

    # Compare test file with desired file
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

    # Remove test file
    rm tests/$testFile
    echo ""
done

echo "====> SUMMARY <===="
echo "==> $passedTestsCount/$testsCount tests passed."
echo ""
