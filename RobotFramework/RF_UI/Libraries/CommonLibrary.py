import json
import os
import random
import time
import platform
import uuid

import pykeyboard
from pymouse import PyMouse
import configparser
import pyperclip
from robot.libraries.BuiltIn import BuiltIn


class CommonLibrary(object):
	def __init__(self):
		pass

	@staticmethod
	def __get_root_path():
		parent_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
		return parent_path

	def get_config_ini(self, env_name):
		config_path = os.path.join(self.__get_root_path(), "config.ini")
		conf = configparser.ConfigParser()
		conf.read(config_path, encoding="utf-8")
		options = conf.options(env_name)
		config_info = {}
		for item in options:
			config_info[item] = conf.get(env_name, item)
		return config_info

	@staticmethod
	def my_choose_file(locator, path):
		sl = BuiltIn().get_library_instance("Selenium2Library")
		# sl.choose_file(locator, path)
		print(f"Sending {os.path.abspath(path)} to browser.")
		sl.find_element(locator).send_keys(path)

	@staticmethod
	def upload_file_mac(file):
		k = pykeyboard.PyKeyboard()
		m = PyMouse()
		time.sleep(1)
		x_dim, y_dim = m.screen_size()
		c_x = x_dim // 2
		c_y = y_dim // 2
		# m.move(c_x, c_y)
		# m.click(c_x, c_y, 1)
		k.press_keys(['Command', 'Shift', 'G'])
		pyperclip.copy(file)
		k.press_keys(['Command', 'V'])
		# m.move(c_x, c_y)
		# m.click(c_x, c_y, 1)
		# k.tap_key(k.return_key)
		k.press_keys(['Return'])
		time.sleep(2)
		k.press_keys(['Return'])
		# k.tap_key(k.return_key)

	@staticmethod
	def ctrl_or_command_key():
		if platform.system() == "Darwin":
			return "COMMAND"
		return "CONTROL"

	@staticmethod
	def return_or_enter_key():
		if platform.system() == "Darwin":
			return "RETURN"
		return "ENTER"

	@staticmethod
	def clear_input_value_by_keyboard():
		k = pykeyboard.PyKeyboard()
		if platform.system() == "Darwin":
			k.press_keys(['Command', 'A'])
			k.press_key('DELETE')
		else:
			k.press_keys(['CONTROL', 'A'])
			k.press_key('DELETE')
		time.sleep(1)

	@staticmethod
	def test_click_something():
		m = PyMouse()
		x_dim, y_dim = m.screen_size()
		print((x_dim, y_dim))
		c_x = x_dim // 2
		c_y = y_dim // 2
		m.move(c_x, c_y)
		time.sleep(2)
		m.click(c_x, c_y, 1)
		time.sleep(2)
		k = pykeyboard.PyKeyboard()
		k.press_key('Return')

	@staticmethod
	def get_random_code(length=5, haveNumber=False):
		if haveNumber:
			string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		else:
			string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		randomId = random.sample(string, length)
		print("".join(randomId))
		return "".join(randomId)

	@staticmethod
	def get_uuid_split():
		return str(uuid.uuid1()).split("-")[0]

	@staticmethod
	def create_dir_not_existed(dir_path):
		if not os.path.exists(dir_path):
			os.mkdir(dir_path)

	def save_file(self, file_name, data, project_name=None):
		if project_name is None:
			file_dir_path = os.path.join(self.__get_root_path(), 'CaseData')
		else:
			file_dir_path = os.path.join(self.__get_root_path(), 'CaseData', project_name)
			self.create_dir_not_existed(file_dir_path)
		new_data = None
		try:
			if type(data) is list:
				new_data = {"data": data}
			else:
				if not type(data) is dict:
					new_data = json.loads(data)
				else:
					new_data = data
		except Exception as e:
			print(e)
			new_data = data
		finally:
			print("data type = ", type(new_data))
			if type(new_data) is dict:
				file_path = os.path.join(file_dir_path, file_name+".json")
				with open(file_path, "w+") as f:
					json.dump(new_data, f, indent=4)
			else:
				file_path = os.path.join(file_dir_path, file_name + ".txt")
				with open(file_path, "w+") as f:
					f.write(str(new_data))
		print(file_path)

	def read_file(self, file_name, project_name=None):
		"""
		:param file_name:
		:param project_name:
		:return:
		"""
		file_type = 1
		if project_name is not None:
			file_path = os.path.join(self.__get_root_path(), project_name, file_name + '.txt')
		else:
			file_path = os.path.join(self.__get_root_path(), file_name+'.txt')

		if not os.path.exists(file_path):
			file_type = 2
			if project_name is not None:
				file_path = os.path.join(self.__get_root_path(), project_name, file_name + '.json')
			else:
				file_path = os.path.join(self.__get_root_path(), file_name+'.json')
		if not os.path.exists(file_path):
			return None
		print(file_path)
		with open(file_path, "r") as f:
			if file_type == 1:
				data = f.read()
			else:
				data = json.load(f)
			return data

	@staticmethod
	def get_en_month(month):
		en_month = "January,February,March,April,May,June,July,August,September,October,November,December"
		en_months = en_month.split(",")
		return en_months[int(month)-1]


if __name__ == '__main__':
	cc = CommonLibrary()
	a = cc.get_config_ini('tst02')
	print(a)
