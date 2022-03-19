import os
import tkinter as tk
from tkinter import filedialog


class ToolsFormatIni:
	def __init__(self):
		pass

	@staticmethod
	def get_file_path():
		root = tk.Tk()
		root.withdraw()

		try:
			filePath = filedialog.askopenfilename()
			dir_file, suffix = os.path.splitext(filePath)
			if suffix == ".ini":
				return filePath
			else:
				print("请选择.ini文件")
				return None
		except Exception as e:
			print(e)
			print("请选择文件")
			return None

	@staticmethod
	def get_config_data(filepath):
		print(filepath)
		with open(filepath, "r") as f:
			data = f.read()
		# print(data)
		return data

	@staticmethod
	def format_ini_data(data, filePath):
		"""
		美化输出ini文件
		:param data: 初始ini文件数据
		:param filePath: 保存的文件路径
		:return:
		"""
		dd = data.split("\n")
		min_space = 5
		max_space = 0
		for d in dd:
			if "=" in d:
				ss = d.split("=")
				key = ss[0].strip()
				now_space = len(key)
				if now_space > max_space:
					max_space = now_space
		space_num = max_space+min_space
		new_ini = []
		for d in dd:
			if "=" in d:
				ss = d.split("=")
				key = ss[0].strip()
				f_space = space_num-len(key)
				value = ss[1].strip()
				new_ini.append(key.upper() + " "*f_space + "=" + " "*min_space + value)
				print(key.upper(), " "*f_space, "=", " "*min_space, value)
			else:
				new_ini.append(d)
				print(d)
		text = "\n".join(new_ini)
		with open(filePath, "w") as f:
			f.write(text)


if __name__ == '__main__':
	"""美化.INI文件内容,执行脚本，选择相应的文件即可"""
	t = ToolsFormatIni()
	file = t.get_file_path()
	if file is not None:
		dat = t.get_config_data(file)
		t.format_ini_data(dat, file)


