import datetime
import os
import sys

import pytz
from bs4 import BeautifulSoup


def get_total_case_info(soup):
	# suite1 = soup.find("suite").get("name")
	# suite2 = soup.find("suite").find("suite").get("name")
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


def get_time_range(soup):
	all_status = soup.findAll("status")
	startTime = all_status[0].attrs.get("starttime")
	endTime = all_status[len(all_status)-1].attrs.get("endtime")
	st = datetime.datetime.strptime(startTime[:-4], "%Y%m%d %H:%M:%S")
	et = datetime.datetime.strptime(endTime[:-4], "%Y%m%d %H:%M:%S")
	time_range = et-st
	range = str(datetime.datetime.strptime(str(time_range), "%H:%M:%S"))[10:]
	body = {"range": range, "startTime": startTime[:-4], "endTime": endTime[:-4]}
	return body


def get_suite_test_result(id):
	suite = soup.find("suite", id=id)
	test = suite.findAll("test")
	testReport = []
	for item in test:
		ck_order_number = ""
		msgs = item.findAll("msg", level="INFO")
		for msg in msgs:
			ckOrderNumber = msg.string
			if ckOrderNumber is not None and ckOrderNumber.count("ck_order_number"):
				ck_order_number += ckOrderNumber + "; "

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
			msg = msg.replace("<", "&lt;")
			msg = msg.replace(">", "&gt;")

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
			"ckOrder": ck_order_number,
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


def create_new_report(summary, failCase, detail, file_name="TestReport.html"):
	cn = pytz.country_timezones('cn')
	tz = pytz.timezone(cn[0])
	body = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Test Report</title>
<style>
.fail {{background-color:#ce3e01;align:center;}}
.fail-color {{background-color:#ce3e01;}}
.pass {{background-color:green;align:center;}}
.skip {{background-color:#fed84f;align:center;}}
.skip-color {{background-color:#fed84f;}}
.small-size {{font-size:0.8em;}}
.pad-left {{padding-left:5px;}}
.pad-right {{padding-right:5px;}}
.case-color {{color:#15c;}}
.w-5 {{width:5%}}
.w-10 {{width:10%}}
.w-25 {{width:25%}}
.w-30 {{width:30%}}
.w-35 {{width:35%}}
.h-tr {{background-color:#808080;height:30px;}}
.t-key {{align:center;}}
.t-value {{align:center;}}
</style>
</head>
<body>
{}
<hr>
{}
<hr>
{}
<hr>
<div><p align="right" style="padding-right:10%">{}<p><div>
</body>
</html>""".format(summary, failCase, detail, datetime.datetime.now(tz),)
	with open(file_name, 'w', encoding="utf-8") as f:
		f.write(body)


def get_test_summary_info(caseInfo, timeRange):
	headers = ["Suite Name", "Total", "Pass", "Fail", "Skip", "Pass Rate"]
	body = '<table width="90%" border="1" cellspacing="0" cellpadding="0" align="center">\n'
	body += '<caption>\n<h2>Summary Information</h2>'
	body += '<p align="right">Start Time:&emsp;{}<br>End Time:&emsp;{}<br>Elapsed Time:&emsp;{}</p>'\
		.format(timeRange.get("startTime"), timeRange.get("endTime"), timeRange.get("range"))
	body += '\n</caption>\n'
	# header
	body += '<thead>\n<tr class="h-tr">'
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
	body += '<td align="center">{}</td>'.format("Total")
	body += '<td align="center">{}</td>'.format(totalCase)
	body += '<td align="center">{}</td>'.format(passCase)
	body += '<td align="center">{}</td>'.format(failCase)
	body += '<td align="center">{}</td>'.format(skipCase)
	body += '<td align="right"><span class="pad-right">{}</span></td>'.format("{}%".format(round((passCase/totalCase)*100, 2)))
	body += '</tr>'
	for item in caseInfo:
		body += '\n<tr>'
		body += '<td class="case-color"><span class="pad-left">{}</span></td>'.format(item.get("name"))
		body += '<td align="center">{}</td>'.format(item.get("total"))
		body += '<td align="center">{}</td>'.format(item.get("pass"))
		body += '<td align="center">{}</td>'.format(item.get("fail"))
		body += '<td align="center">{}</td>'.format(item.get("skip"))
		body += '<td align="right"><span class="pad-right">{}</span></td>'.format("{}%".format(round((item.get("pass")/item.get("total"))*100, 2)))
		body += '</tr>'
	body += '\n</tbody>'
	body += '\n</table>'
	return body


def get_fail_case_info(caseInfo):
	headers = ["Name", "Documentation", "Status", "Type/Tester", "Remark"]
	body = '<table width="90%" border="1" cellspacing="0" cellpadding="0" align="center">\n'
	body += '<caption><h2>Failure Case Analysis</h2></caption>\n'
	# header
	body += '<thead>\n<tr class="h-tr">'
	for item in headers:
		body += "<th>{}</th>".format(item)
	body += '<tr>\n</thead>'
	# tbody
	body += '\n<tbody>'
	for item in caseInfo:
		testInfo = item.get("test")
		for testItem in testInfo:
			if testItem.get("status") in ("FAIL", "SKIP"):
				body += '\n<tr>'
				body += '<td class="case-color w-30"><span class="small-size pad-left">{}</span>.{}</td>'.format(item.get("name"), testItem.get("name"))
				if testItem.get("status") == "FAIL":
					body += '<td class="fail w-30"><span class="pad-left">{}</span></td>'.format(testItem.get("documentation"))
					body += '<td class="fail w-5" align="center">{}</td>'.format(testItem.get("status"))
				elif testItem.get("status") == "SKIP":
					body += '<td class="skip w-30"><span class="pad-left">{}</span></td>'.format(testItem.get("documentation"))
					body += '<td class="skip w-5" align="center">{}</td>'.format(testItem.get("status"))
				body += '<td class="w-10"></td>'
				body += '<td class="w-25"><span class="pad-left">{}</span></td>'.format(testItem.get("msg"))
				body += '</tr>'
	body += '\n</tbody>'
	body += '\n</table>'
	return body


def get_test_detail_info(caseInfo):
	headers = ["Name", "Documentation", "Status", "Message"]
	body = '<table width="90%" border="1" cellspacing="0" cellpadding="0" align="center">\n'
	body += '<caption><h2>Test Details</h2></caption>\n'
	# header
	body += '<thead>\n<tr class="h-tr">'
	for item in headers:
		body += "<th>{}</th>".format(item)
	body += '<tr>\n</thead>'
	# tbody
	body += '\n<tbody>'
	for item in caseInfo:
		testInfo = item.get("test")
		for testItem in testInfo:
			body += '\n<tr>'
			body += '<td class="case-color w-30"><span class="small-size pad-left">{}</span>.{}</td>'.format(item.get("name"), testItem.get("name"))

			if testItem.get("status") == "FAIL":
				body += '<td class="fail w-30"><span class="pad-left">{}</span></td>'.format(testItem.get("documentation"))
				body += '<td class="fail w-5" align="center">{}</td>'.format(testItem.get("status"))
			elif testItem.get("status") == "SKIP":
				body += '<td class="skip w-30"><span class="pad-left">{}</span></td>'.format(testItem.get("documentation"))
				body += '<td class="skip w-5" align="center">{}</td>'.format(testItem.get("status"))
			else:
				body += '<td><span class="pad-left  w-30">{}</span></td>'.format(testItem.get("documentation"))
				body += '<td class="pass w-5" align="center">{}</td>'.format(testItem.get("status"))
			if testItem.get("ckOrder") is not None and testItem.get("ckOrder") != "":
				body += '<td class="w-35"><span class="pad-left">{}</span><br>' \
				        '<span class="pad-left">{}</span></td>'.format(testItem.get("ckOrder"), testItem.get("msg"))
			else:
				body += '<td class="w-35"><span class="pad-left">{}</span></td>'.format(testItem.get("msg"))
			body += '</tr>'
	body += '\n</tbody>'
	body += '\n</table>'
	return body


if __name__ == '__main__':
	if len(sys.argv) == 1:
		filePath = os.path.join("../output1.xml")
	else:
		filePath = sys.argv[1]
	print(filePath)
	if os.path.exists(filePath):
		ff = open(filePath, "r", encoding="utf-8")
		output = ff.read()
		soup = BeautifulSoup(output, features="lxml")
		timeRange = get_time_range(soup)
		caseInfo = get_test_result_count(soup)
		case_summary = get_test_summary_info(caseInfo, timeRange)
		fail_case = get_fail_case_info(caseInfo)
		case_detail = get_test_detail_info(caseInfo)
		path = os.path.abspath(filePath)
		dir_name = os.path.dirname(path)
		saveFileName = os.path.join(dir_name, "TestReport.html")
		print(saveFileName)
		create_new_report(case_summary, fail_case, case_detail, saveFileName)
	else:
		print("XML文件不存在")

