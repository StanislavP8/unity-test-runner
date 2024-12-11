#!/usr/bin/env bash

#
# Run steps
#
source /steps/set_extra_git_configs.sh
source /steps/set_gitcredential.sh
source /steps/activate.sh

# If we didn't activate successfully, exit with the exit code from the activation step.
if [[ $UNITY_EXIT_CODE -ne 0 ]]; then
  exit $UNITY_EXIT_CODE
fi

ALT_TESTER_API_KEY=D3G6N/TrOclbdHEwK7n9f6KT7xRPfWG4LcR/qIiY8QtT6n6n1sdz/iVedismS7DV
wget https://alttester.com/app/uploads/AltTester/desktop/AltTesterDesktopLinuxBatchmode.zip
if [ $? -ne 0 ]; then
  echo "Download failed!"
  exit 1
fi

unzip AltTesterDesktopLinuxBatchmode.zip
if [ $? -ne 0 ]; then
  echo "Unzip failed!"
  exit 1
fi

cd AltTesterDesktopLinux || { echo "Directory not found!"; exit 1; }

chmod +x AltTesterDesktop.x86_64
./AltTesterDesktop.x86_64 -batchmode -port 13000 -license $ALT_TESTER_API_KEY -nographics -termsAndConditionsAccepted &
cd ..

source /steps/run_tests.sh
source /steps/return_license.sh

# cd AltTesterDesktopLinux
# kill -2 `ps -ef | awk '/AltTesterDesktop.x86_64/{print $2}'`
# cd..

#
# Instructions for debugging
#

if [[ $TEST_RUNNER_EXIT_CODE -gt 0 ]]; then
echo ""
echo "###########################"
echo "#         Failure         #"
echo "###########################"
echo ""
echo "Please note that the exit code is not very descriptive."
echo "Most likely it will not help you solve the issue."
echo ""
echo "To find the reason for failure: please search for errors in the log above."
echo ""
fi;

#
# Exit with code from the build step.
#

if [[ $USE_EXIT_CODE == true || $TEST_RUNNER_EXIT_CODE -ne 2 ]]; then
exit $TEST_RUNNER_EXIT_CODE
fi;
