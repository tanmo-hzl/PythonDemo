import json
import os
import random


class BuyerCheckoutLib(object):
	def __init__(self):
		pass

	@staticmethod
	def __get_root_path():
		abspath = os.path.dirname(os.path.abspath(__file__))
		root_path = os.path.dirname(os.path.dirname(abspath))
		return root_path

	def get_random_active_listing(self, env='tst03', variant=None, file_name="active_listings.json", file_dir="MP"):
		if file_dir is not None:
			file_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_name)
		else:
			file_path = os.path.join(self.__get_root_path(), "CaseData", file_name)
		with open(file_path, "r") as f:
			data = json.load(f).get("data")

		variant_listing = []
		no_variant_listing = []

		for item in data:
			if "variant" in item.get("inventory"):
				variant_listing.append(item)
			else:
				no_variant_listing.append(item)
		try:
			if variant is None:
				listing = random.choice(data)
			else:
				if variant:
					listing = random.choice(variant_listing)
				else:
					listing = random.choice(no_variant_listing)

			if "variant" in listing.get("inventory"):
				inventories = listing.get("inventory").split("\n")
				quantity = inventories[0].split(" ")[0]
				variant = True
			else:
				quantity = listing.get("inventory").split(" ")[0]
				variant = False
			return_listing = {
				"title": listing.get("title"),
				"quantity": quantity,
				"variant": variant
			}
			print(return_listing)
			return return_listing
		except Exception as e:
			print(e)
			return None


if __name__ == '__main__':
	b = BuyerCheckoutLib()
	b.get_random_active_listing()


