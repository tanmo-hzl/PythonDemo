from robot.libraries.BuiltIn import BuiltIn

from Selenium2Library import Selenium2Library
from SeleniumLibrary.base import keyword


class CustomSeleniumKeywords(Selenium2Library):
	def __init__(self, *args, **kwargs):
		"""Share `Selenium2Library`'s cache of browsers, so that
		we don't have to open a separate browser instance for the
		`Run On Failure Keyword Only Called Once` test."""
		super().__init__(*args, **kwargs)
		sl = BuiltIn().get_library_instance("Selenium2Library")
		self._drivers = sl._drivers

	@keyword
	def custom_selenium_keyword(self):
		self.custom_selenium_keyword_inner()

	@keyword
	def custom_choose_file(self, locator, file_path):
		self.choose_file(locator, file_path)

