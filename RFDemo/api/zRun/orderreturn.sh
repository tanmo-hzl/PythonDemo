# echo off
# run.bat 用例Tags
if test -z "$1"
then
  count=1
else
  count=$1
fi

for((i=0;i<count;i++));
do
  robot -i order-return TestCase
  sleep 1
done