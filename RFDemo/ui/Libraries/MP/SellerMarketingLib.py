import json
import random


class SellerMarketingLib(object):
	def __init__(self):
		self.all_pro_type_names = ['Spend & Get - % Off&&', 'Spend & Get - $ Amount Off&&', 'Buy  & Get  - % Off&&', 'Buy A & Get A&&', 'Percent Off&&', 'BMSM - % Off&&']

	def get_promotion_info_by_index(self, pro_list, pro_index=1):
		need_pro_type = self.all_pro_type_names[int(pro_index)-1]
		need_pros = []
		need_pro_skus = []
		other_pros = []
		other_pro_skus = []
		for pro in pro_list:
			promotionExtensions = pro.get("promotionExtensions")
			productRestriction = pro.get("productRestriction")
			promotionId = pro.get("promotionId")
			benefit = pro.get("benefit")
			if promotionExtensions.get("benefitJson") == need_pro_type:
				need_pros.append(pro)
				for item in productRestriction:
					if item not in need_pro_skus:
						item["promotionId"] = promotionId
						item["benefit"] = benefit
						need_pro_skus.append(item)
			else:
				other_pros.append(pro)
				for item in productRestriction:
					if item not in other_pro_skus:
						item["promotionId"] = promotionId
						other_pro_skus.append(item)
		unique_discount_skus = []
		for need_sku in need_pro_skus:
			is_unique_sku = True
			sku = need_sku.get("value")
			for other_sku in other_pro_skus:
				if sku == other_sku.get("value"):
					is_unique_sku = False
					continue
			if is_unique_sku:
				unique_discount_skus.append(need_sku)
		print("{},unique_discount_skus = {}".format(need_pro_type, unique_discount_skus))
		if len(unique_discount_skus) > 0:
			return True, need_pro_type, random.choice(unique_discount_skus)
		else:
			return False, need_pro_type, None

	@staticmethod
	def get_promotion_items_variants(items_info, sub_sku_number):
		item_info = items_info[0]
		sku_number = item_info.get("skuNumber")
		if sku_number == sub_sku_number:
			variants = None
		else:
			subSkus = item_info.get("subSkus")
			for item in subSkus:
				if item.get("skuNumber") == sub_sku_number:
					attrs = item.get("attrs")
			attrs_list = attrs.split(",")
			variants = []
			for item in attrs_list:
				variants.append(item.split(": ")[1])
		return sku_number, variants

if __name__ == '__main__':
	with open("a.json", "r", encoding="utf-8") as f:
		data = json.load(f)
	content = data.get("data").get("content")

	s = SellerMarketingLib()
	s.get_promotion_info_by_index(content, 1)


