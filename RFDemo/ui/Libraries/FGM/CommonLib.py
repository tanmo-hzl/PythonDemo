from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


def create_profile():
    fp = webdriver.FirefoxProfile()

    fp.set_preference("dom.webnotifications.enabled", False)
    fp.set_preference("geo.enabled", False)
    fp.set_preference("geo.provider.use_corelocation", False)
    fp.set_preference("geo.prompt.testing", False)
    fp.set_preference("geo.prompt.testing.allow", False)
    fp.set_preference('browser.dom.window.dump.enabled', True)
    fp.set_preference('devtools.console.stdout.content', True)
    fp.update_preferences()
    return fp.path


def desired_capabilities_setting():
    cap = DesiredCapabilities.FIREFOX
    cap['loggingPrefs'] = {'browser': 'ALL'}
    cap['marionette'] = True
    return cap






