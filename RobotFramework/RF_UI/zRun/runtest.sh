# bin/bash
# Please execute the file in folder automation-robot-ui

DIR=$(date "+zRun%Y%m%d-%H%M%S")
echo $DIR
if [ ! -e $DIR ]
then
mkdir -p $DIR
fi

cd $DIR

if test -z "$2"
then
  robot -i $1  ../TestCase
else
  robot -i $1 -v ENV:$2  ../TestCase
fi
