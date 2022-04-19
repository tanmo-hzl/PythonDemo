import sys
import time
from datetime import timedelta

from robot.libraries.BuiltIn import BuiltIn

from SeleniumLibrary import SeleniumLibrary
from SeleniumLibrary.base import keyword


class CustomSeleniumKeywords(SeleniumLibrary):
	def __init__(self, *args, **kwargs):
		"""Share `SeleniumLibrary`'s cache of browsers, so that
		we don't have to open a separate browser instance for the
		`Run On Failure Keyword Only Called Once` test."""
		super().__init__(*args, **kwargs)
		sl = BuiltIn().get_library_instance("SeleniumLibrary")
		self._drivers = sl._drivers

	@keyword
	def custom_selenium_keyword(self):
		self.custom_selenium_keyword_inner()

	@keyword
	def custom_selenium_keyword_inner(self):
		raise AssertionError

	@keyword
	def check_errors_console_log(self, url):
		"""Function to get the browser's console log errors"""
		self.driver.get(url)
		current_console_log_errors = []
		# As IE driver does not support retrieval of any logs,
		# we are bypassing the get_browser_console_log() method
		if "ie" not in str(self.driver):
			log_errors = []
			new_errors = []
			log = self.get_browser_console_log()
			print
			"Console Log: ", log
			for entry in log:
				if entry['level'] == 'SEVERE':
					log_errors.append(entry['message'])

			if current_console_log_errors != log_errors:
				# Find the difference
				new_errors = list(set(log_errors) - set(current_console_log_errors))
				# Set current_console_log_errors = log_errors
				current_console_log_errors = log_errors

			if len(new_errors) > 0:
				print("\nBrowser console error on url: %s\nConsole error(s):%s" % (
					self.driver.current_url, '\n----'.join(new_errors)))

	@keyword
	def get_browser_console_log(self):
		"""Get the browser console log"""
		try:
			logs = self.driver.get_log('browser')
			error_msg = []
			for item in logs:
				msg = item.get("message")
				if msg.count(".js") or msg.count(".jpeg") or msg.count(".css") \
						or (msg.count("data:image") and msg.count("base64")):
					continue
				else:
					if msg not in error_msg:
						error_msg.append(msg)
			print("BrowserError: {}".format(error_msg))
		except Exception as e:
			print("Exception when reading Browser Console log")
			print(str(e))

	@keyword
	def click_element(self, locator):
		self.hidden_unknown_popup()
		print("Click Element {}.".format(locator))
		self.find_element(locator).click()

	@keyword
	def input_text(self, locator, text):
		self.hidden_unknown_popup()
		print("Input {} To Element {}.".format(text, locator))
		self.find_element(locator).send_keys(text)

	def hidden_unknown_popup(self):
		ele = self.find_elements('//*[@id="attentive_creative"]')
		if len(ele) > 0:
			self.execute_javascript('document.querySelector("#attentive_creative").remove()')
			print("hidden attentive_creative success")
			time.sleep(0.5)

	@keyword
	def wait_until_page_contains_elements_ignore_ad(self, locator, timeout=5):
		start_time = time.time()
		while True:
			time.sleep(1)
			end_time = time.time()
			ele = self.find_elements(locator)
			self.hidden_unknown_popup()
			if len(ele) > 0:
				print("Find element: {} success!".format(locator))
				break
			if int(end_time - start_time) > int(timeout):
				msg = "Find element: {} timeout".format(locator)
				assert False, msg
