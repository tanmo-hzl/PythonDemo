import os


class CountTestCase:

	def __init__(self, dir_name):
		self.dirPath = os.path.join(self.get_current_path(), "TestCase", dir_name)

	@staticmethod
	def get_current_path():
		"""
		获取当前文件的绝对路径
		:return:
		"""
		current_path = os.path.dirname(os.path.abspath(__file__))
		return current_path

	def get_all_files(self):
		all_files = []
		for root, dirs, files in os.walk(self.dirPath):
			all_files = files
		return all_files

	def count_case_number(self):
		all_files = self.get_all_files()
		cases = {}
		count = 0
		for file in all_files:
			cases[file] = []
			with open(os.path.join(self.dirPath, file), "r") as f:
				body = f.readlines()
				for item in body:
					if item.startswith("Test"):
						cases[file].append(item.replace("\n", ""))
						count += 1
		print(count)
		return cases


if __name__ == '__main__':
	c = CountTestCase("B2B")
	print("c==>", c.get_current_path())
	print(c.get_all_files())
	print(c.count_case_number())
