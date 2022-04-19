import datetime
import pytz
from bs4 import BeautifulSoup
import os
import sys


def get_total_case_info(soup):
	suite1 = soup.find("suite").get("name")
	suite2 = soup.find("suite").find("suite").get("name")
	suites = soup.findAll("suite")
	totalCase = []
	for item in suites:
		if item.get("id") is not None:
			case = {"name": item.get("name"), "id": item.get("id")}
			totalCase.append(case)
	max_count = 0
	for item in totalCase:
		if item.get("id").count("-") > max_count:
			max_count = item.get("id").count("-")
	allCases = []
	for item in totalCase:
		if item.get("id").count("-") == max_count:
			allCases.append(item)
	# print(allCases)
	return allCases


def get_suite_test_result(id):
	suite = soup.find("suite", id=id)
	test = suite.findAll("test")
	testReport = []
	for item in test:
		tags = []
		for tg in item.findAll("tag"):
			tags.append(tg.string)
		statusList = item.findAll("status")
		status = statusList[len(statusList) - 1].attrs
		kws = item.findAll("kw")

		msg = statusList[len(statusList) - 1].string
		if msg is not None and msg.count("\n"):
			temp_msg = msg.split(":")[:3]
			msg = ":".join(temp_msg)

		if msg is None:
			msg = ""

		docs = item.findAll("doc")
		if docs is not None and len(docs) > 0:
			doc = docs[len(docs) - 1].string
		else:
			doc = ""
		report = {
			"name": item.get("name"),
			"documentation": doc,
			"tags": ",".join(tags),
			"status": status.get("status"),
			"msg": msg,
			"time": "{}\n{}".format(status.get("starttime"), status.get("endtime"))
		}
		testReport.append(report)
	return testReport


def get_test_result_count(soup):
	cases = get_total_case_info(soup)
	for item in cases:
		id = item.get("id")
		testReport = get_suite_test_result(id)
		totalCase = len(testReport)
		passCase = 0
		failCase = 0
		skipCase = 0
		for test in testReport:
			if test.get("status") == "PASS":
				passCase += 1
			if test.get("status") == "FAIL":
				failCase += 1
			if test.get("status") == "SKIP":
				skipCase += 1
		item["test"] = testReport
		item["total"] = totalCase
		item["pass"] = passCase
		item["fail"] = failCase
		item["skip"] = skipCase
	# print(cases)
	return cases


def create_new_report(summary, detail, file_name="TestReport.html"):
	cn = pytz.country_timezones('cn')
	tz = pytz.timezone(cn[0])
	body = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Test Report</title>
<style>
.fail {{background-color:red;align:center;}}
.pass {{background-color:green;align:center;}}
.skip {{background-color:yellow;align:center;}}
</style>
</head>
<body>
<h1 align="center">Test Report</h1>
<h3 align="center">Date：{}</h3>
<hr>
{}
<hr>
{}
<hr>
</body>
</html>""".format(datetime.datetime.now(tz), summary, detail)
	with open(file_name, 'w', encoding="utf-8") as f:
		f.write(body)


def get_test_summary_info(caseInfo):
	headers = ["Suite Name", "Total", "Pass", "Fail", "Skip", "Pass Rate"]
	body = '<table width="40%" border="1" cellspacing="0" cellpadding="0" align="center">\n'
	body += '<caption><h2>Summary Information</h2></caption>\n'
	# header
	body += '<thead>\n<tr style="background-color:#808080;height:30px;">'
	for item in headers:
		body += "<th>{}</th>".format(item)
	body += '<tr>\n</thead>\n'
	# tbody
	body += '\n<tbody>'
	totalCase, passCase, failCase, skipCase = 0, 0, 0, 0
	for item in caseInfo:
		totalCase += item.get("total")
		passCase += item.get("pass")
		failCase += item.get("fail")
		skipCase += item.get("skip")
	body += '\n<tr style="background-color:#C0C0C0;">'
	body += "<td>{}</td>".format("Total")
	body += '<td align="center">{}</td>'.format(totalCase)
	body += '<td align="center">{}</td>'.format(passCase)
	body += '<td align="center">{}</td>'.format(failCase)
	body += '<td align="center">{}</td>'.format(skipCase)
	body += '<td align="right">{}</td>'.format("{}%".format(round((passCase/totalCase)*100, 2)))
	body += '</tr>'
	for item in caseInfo:
		body += '\n<tr>'
		body += "<td>{}</td>".format(item.get("name"))
		body += '<td align="center">{}</td>'.format(item.get("total"))
		body += '<td align="center">{}</td>'.format(item.get("pass"))
		body += '<td align="center">{}</td>'.format(item.get("fail"))
		body += '<td align="center">{}</td>'.format(item.get("skip"))
		body += '<td align="right">{}</td>'.format("{}%".format(round((item.get("pass")/item.get("total"))*100, 2)))
		body += '</tr>'
	body += '\n</tbody>'
	body += '\n</table>'
	return body


def get_test_detail_info(caseInfo):
	headers = ["Name", "Documentation", "Status", "Message"]
	body = '<table width="80%" border="1" cellspacing="0" cellpadding="0" align="center">\n'
	body += '<caption><h2>Test Details</h2></caption>\n'
	# header
	body += '<thead>\n<tr style="background-color:#808080;height:30px;">'
	for item in headers:
		body += "<th>{}</th>".format(item)
	body += '<tr>\n</thead>'
	# tbody
	body += '\n<tbody>'
	for item in caseInfo:
		testInfo = item.get("test")
		for testItem in testInfo:
			body += '\n<tr>'
			body += "<td>{}</td>".format(testItem.get("name"))
			body += "<td>{}</td>".format(testItem.get("documentation"))
			if testItem.get("status") == "FAIL":
				body += '<td class="fail">{}</td>'.format(testItem.get("status"))
			elif testItem.get("status") == "SKIP":
				body += '<td class="skip">{}</td>'.format(testItem.get("status"))
			else:
				body += '<td class="pass">{}</td>'.format(testItem.get("status"))
			body += "<td>{}</td>".format(testItem.get("msg"))
			body += '</tr>'
	body += '\n</tbody>'
	body += '\n</table>'
	return body


if __name__ == '__main__':
	if len(sys.argv) == 1:
		filePath = os.path.join("output3.xml")
	else:
		filePath = sys.argv[1]
	print(filePath)
	if os.path.exists(filePath):
		ff = open(filePath, "r", encoding="utf-8")
		output = ff.read()
		soup = BeautifulSoup(output, features="lxml")
		caseInfo = get_test_result_count(soup)
		case_summary = get_test_summary_info(caseInfo)
		case_detail = get_test_detail_info(caseInfo)
		path = os.path.abspath(filePath)
		dir_name = os.path.dirname(path)
		saveFileName = os.path.join(dir_name, "TestReport.html")
		print(saveFileName)
		create_new_report(case_summary, case_detail, saveFileName)
	else:
		print("XML文件不存在")

