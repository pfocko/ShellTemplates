#!/bin/sh

# Load environment variables
. ./tests/env.sh

echo "====> TESTING <===="
echo ""

# Get all files with '.original' extension and then remove extension
testFiles=$(ls tests | grep ".*\.original$" | sed 's/\.original$//g')

# Init info-variables
testsCount=$(echo $testFiles | wc -w)
passedTestsCount=0

for testFile in $testFiles
do
    # Create test file
    cp tests/$testFile.original tests/$testFile.test    
done

# Execute shellTemplates on test files
./shellTemplates.sh $(find tests -type f -name *.test)
if [ $? -eq 0 ]
then
    echo "==> SUCCESS: shellTemplates.sh returned zero (success) code!"
    echo ""
else
    echo "==> FAILURE: shellTemplates.sh returned non-zero code!"
    echo ""
fi

for testFile in $testFiles
do
    echo "====> Comparing $testFile <===="    

    # Compare test file with desired file
    if cmp -s tests/$testFile.test tests/$testFile.desired
    then
        echo "==> SUCCESS!"
        let "passedTestsCount++"
    else
        echo "==> FAILURE!"
        echo "==> Expected:"
        cat tests/$testFile.desired
        echo "==> Received:"
        cat tests/$testFile.test
    fi

    echo ""
done

# Remove test files
rm $(find tests -type f -name *.test)

echo "====> SUMMARY <===="
echo "==> $passedTestsCount/$testsCount tests passed."
echo ""
