# echo off
# run.bat 用例Tags
count=
if test -z "$1"
then
  count=1
else
  count=$1
fi

for((i=0;i<count;i++));
do
  robot -i order-create TestCase
done
