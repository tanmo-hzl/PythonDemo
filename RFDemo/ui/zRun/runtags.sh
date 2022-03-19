# echo off
# run.bat 用例Tags

if test -z "$2"
then
  robot -i $1 -T -o output.xml -r report.html -l log.html TestCase
else
  robot -i $1 -v ENV:$2 -T -o $2_output.xml -r $2_report.html -l $2_log.html TestCase
fi

