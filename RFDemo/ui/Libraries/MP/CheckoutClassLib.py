

class CheckoutClassLib(object):
	def __init__(self):
		self.first_name = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty']
		self.email = 'buyertst{}@snapmail.cc'
		self.phone = '989796{}'

	def get_class_guest_info(self, guest_number=4):
		guest_data = []
		for i in range(guest_number):
			if i < 20:
				firstName = "Guest {}".format(self.first_name[i])
			else:
				name_len = len(self.first_name)
				firstName = "Guest {} {}".format(self.first_name[i // name_len], self.first_name[i % name_len])

			guest = {
				"firstName": firstName,
				"lastName": "Auto",
				"email": self.email.format(str(i+1).zfill(3)),
				"phone": self.phone.format(str(i+1).zfill(4))
			}
			guest_data.append(guest)
		print(guest_data)
		return guest_data


if __name__ == '__main__':
	c = CheckoutClassLib()
	c.get_class_guest_info(22)
