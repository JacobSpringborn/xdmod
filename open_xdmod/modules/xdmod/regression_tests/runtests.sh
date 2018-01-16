#!/bin/sh

set -e

REGUSER=""
PI=""
CD=""
CS=""
PUB=""

if [ "$1" = "--junit-output-dir" ];
then
    REGUSER="--log-junit $2/xdmod-regression-user.xml"
    PI="--log-junit $2/xdmod-regression-principalinvestigator.xml"
    CD="--log-junit $2/xdmod-regression-centerdirector.xml"
    CS="--log-junit $2/xdmod-regression-centerstaff.xml"
    PUB="--log-junit $2/xdmod-regression-public.xml"
fi

cd $(dirname $0)

if [ ! -e ../integration_tests/.secrets.json ];
then
    echo "ERROR missing .secrets.json file." >&2
    echo >&2
    cat README.md >&2
    false
fi

phpunit="$(readlink -f ../../../../vendor/bin/phpunit)"

if [ ! -x "$phpunit" ]; then
    echo phpunit not found, run \"composer install\" 1>&2
    exit 127
fi

REG_TEST_USER_ROLE=usr $phpunit $REGUSER . &
REG_TEST_USER_ROLE=pi $phpunit $PI . &
REG_TEST_USER_ROLE=cd $phpunit $CD . &
REG_TEST_USER_ROLE=cs $phpunit $CS . &
$phpunit $PUB . &
wait
