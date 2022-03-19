
if test -z "$2"
then
  robot -i $1  TestCase
else
  robot -i $1 -v ENV:$2  TestCase
fi