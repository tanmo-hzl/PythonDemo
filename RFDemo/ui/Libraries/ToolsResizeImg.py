import tkinter as tk
import uuid
from tkinter import filedialog
from PIL import Image
import os


class ToolsResizeImg:
	def __init__(self):
		pass

	@staticmethod
	def get_size(filePath):
		return os.path.getsize(filePath)/1024

	@staticmethod
	def get_outfile(infile):
		dir_file, suffix = os.path.splitext(infile)
		dir_name, file_name = os.path.split(infile)
		name = str(uuid.uuid1()).split("-")
		name.reverse()
		new_name = "".join(name)[-16:]
		outfile = os.path.join(dir_name, new_name+suffix)
		return outfile

	def compress_image(self, infile, mb=150, step=10, quality=80):
		"""不改变图片尺寸压缩到指定大小
		:param infile: 压缩源文件
		:param mb: 压缩目标，KB
		:param step: 每次调整的压缩比率
		:param quality: 初始压缩比率
		:return: 压缩文件地址，压缩文件大小
		"""
		o_size = self.get_size(infile)
		if o_size <= mb:
			return infile
		outfile = self.get_outfile(infile)
		while o_size > mb:
			im = Image.open(infile)
			im.save(outfile, quality=quality)
			if quality - step < 0:
				break
			quality -= step
			o_size = self.get_size(outfile)
		return outfile, self.get_size(outfile)

	def resize_image(self, infile, zoom=0.4):
		"""修改图片尺寸
		:param infile: 图片源文件
		:param zoom: 缩放比例
		:return:
		"""
		outfile = self.get_outfile(infile)
		im = Image.open(infile)
		x, y = im.size
		x_s = int(x * zoom)
		y_s = int(y * zoom)
		out = im.resize((x_s, y_s), Image.ANTIALIAS)
		out.save(outfile)
		return outfile

	@staticmethod
	def get_file_path():
		root = tk.Tk()
		root.withdraw()

		try:
			filePath = filedialog.askopenfilename()
			return filePath
		except Exception as e:
			print(e)
			print("请选择文件")
			return None


if __name__ == '__main__':
	t = ToolsResizeImg()
	file = t.get_file_path()
	if file is not None:
		new_file = t.resize_image(file, 0.5)
