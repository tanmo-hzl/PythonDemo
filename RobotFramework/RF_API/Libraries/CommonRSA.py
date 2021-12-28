#!/usr/bin/python3
# python version 3.6
# pycryptodome进行RSA生成公钥、私钥，加密、解密、签名、验签
# 参考1 https://blog.csdn.net/u010693827/article/details/78629268
# 参考2 https://www.cnblogs.com/huxianglin/p/6387045.html
# 参考3 https://blog.csdn.net/orangleliu/article/details/72964948
import urllib.parse,base64
from Crypto.Hash import SHA
from Crypto import Random
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as Cipher_pkcs1_v1_5
from Crypto.Signature import PKCS1_v1_5 as Signature_pkcs1_v1_5
from Crypto.Cipher import PKCS1_OAEP
from Crypto.Hash import SHA256


'''
加密的 plaintext 最大长度是 证书key位数/8 - 11
1024 bit的证书，被加密的最长 1024/8 - 11=117
2048 bit的证书，被加密的最长 2048/8 - 11 =245
'''
encode_gbk_utf8 = 'utf-8'  # 全局编码方式 utf-8 | gbk
key_num = 2048  # 证书key位数


class CommonRSA(object):

	def __init__(self):
		pass

	@staticmethod
	def rsa_create_key():
		random_generator = Random.new().read  # 伪随机数生成器
		rsa = RSA.generate(key_num, random_generator)  # rsa算法生成实例
		private_pem = rsa.exportKey()  # master的秘钥对的生成
		print(private_pem)
		# 生成公私钥对文件
		with open('master-private.pem', 'wb') as f:
			f.write(private_pem)

		public_pem = rsa.publickey().exportKey()
		print(public_pem)
		with open('master-public.pem', 'wb') as f:
			f.write(public_pem)
		# ghost的秘钥对的生成,与master内容一样，如果想不一样请重新生成rsa实例
		private_pem = rsa.exportKey()
		with open('ghost-private.pem', 'wb') as f:
			f.write(private_pem)

		public_pem = rsa.publickey().exportKey()
		with open('ghost-public.pem', 'wb') as f:
			f.write(public_pem)

	# ghost使用公钥加密
	@staticmethod
	def rsa_ghost_key_encrypt(message):
		with open('ghost-public.pem', 'rb') as f:
			key = f.read()
			print(key)
			rsakey = RSA.importKey(key)  # 导入读取到的公钥
			cipher = Cipher_pkcs1_v1_5.new(rsakey)  # 生成对象
			# 加密message明文，python3加密的数据必须是bytes，不能是str
			cipher_text = base64.b64encode(cipher.encrypt(
				message.encode(encoding=encode_gbk_utf8)))
			return cipher_text

	# ghost使用私钥解密
	@staticmethod
	def rsa_ghost_key_decrypt(cipher_text):
		with open('ghost-private.pem', 'rb') as f:
			key = f.read()
			rsakey = RSA.importKey(key)  # 导入读取到的私钥
			cipher = Cipher_pkcs1_v1_5.new(rsakey)  # 生成对象
			# 将密文解密成明文，返回的是bytes类型，需要自己转成str,主要是对中文的处理
			text = cipher.decrypt(base64.b64decode(cipher_text), "ERROR")
			return text.decode(encoding=encode_gbk_utf8)

	# master 使用私钥对内容进行签名
	@staticmethod
	def rsa_master_key_sign(message):
		with open('master-private.pem', 'rb') as f:
			key = f.read()
			print(key)
			rsakey = RSA.importKey(key)
			signer = Signature_pkcs1_v1_5.new(rsakey)
			digest = SHA.new()
			digest.update(message.encode(encoding=encode_gbk_utf8))
			sign = signer.sign(digest)
			signature = base64.b64encode(sign)  # 对结果进行base64编码
		return signature

	# master 使用公钥对内容进行验签
	@staticmethod
	def rsa_mater_key_check_sign(message, signature):
		with open('master-public.pem', 'rb') as f:
			key = f.read()
			rsakey = RSA.importKey(key)
			verifier = Signature_pkcs1_v1_5.new(rsakey)
			digest = SHA.new()
			# 注意内容编码和base64解码问题
			digest.update(message.encode(encoding=encode_gbk_utf8))
			is_verify = verifier.verify(digest, base64.b64decode(signature))
		return is_verify

	@staticmethod
	def rsa_encrypt_sha256_msg_by_key(public_key, message):
		print(str(message))
		pubkey = '-----BEGIN PUBLIC KEY-----\n' + public_key + '\n-----END PUBLIC KEY-----'
		key = bytes(pubkey, encoding=encode_gbk_utf8)
		rsa_key = RSA.importKey(key)  # 导入读取到的公钥
		cipher = PKCS1_OAEP.new(rsa_key, SHA256)  # 生成对象
		# 加密message明文，python3加密的数据必须是bytes，不能是str
		cipher_text = base64.b64encode(cipher.encrypt(str(message).encode(encoding=encode_gbk_utf8)))
		# cc = bstr(cipher_text)
		return str(cipher_text, encoding=encode_gbk_utf8)

	@staticmethod
	def rsa_decrypt_sha256_msg_by_key(private_key, sign_data):
		print(str(sign_data))
		privatekey = '-----BEGIN RSA PRIVATE KEY-----\n' + private_key + '\n-----END RSA PRIVATE KEY-----'
		key = bytes(privatekey, encoding=encode_gbk_utf8)
		rsa_key = RSA.importKey(key)  # 导入读取到的私钥
		cipher = PKCS1_OAEP.new(rsa_key, SHA256)  # 生成对象
		message = cipher.decrypt(base64.b64decode(sign_data.encode(encoding=encode_gbk_utf8)))
		# cc = bstr(cipher_text)
		return str(message, encoding=encode_gbk_utf8)

	@staticmethod
	def str_to_url_encode(msg):
		return urllib.parse.quote(msg)

	@staticmethod
	def url_decode_to_str(msg):
		return urllib.parse.unquote(msg)


if __name__ == '__main__':
	r = CommonRSA()
	# r.rsa_create_key()
	publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArZjXir6We1d63GNmQXphs3TupULeSeJXQ0OFi7IR+g3FW2iHbjRraP+oajI+2ArxX4cKE2jYsycnS4VpsNKwZv/kF+SARVXVL4QLZ1RGeGI+Ml3JKLjfFZuHMRES3bW91Ilo7ZuhO/CKWyVqxfAEMd5WXxlNruG97/kmcM/e2iP4MHbgbvRIvP95kvn/xp+yoLGiTwS+CjlUBeoYc9O4l2OakMJTysk8ghkhhkAkOYMkz5OjIYk8R9YseeDxlAE7amcYB3fpHVpSfSBE+A5KxmrK9kikr+fSfqetGsN6Q7tJBZXBsg4fqPLxVkwcdDC7ghgHiwP2vV+yxtajUDm91QIDAQAB"
	serverTime = "1635470214928"
	body ={
		"serverTime": serverTime,
		"email": "ZM@snapmail.cc",
		"password": "Passwrod123"
	}
	pk = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCtmNeKvpZ7V3rcY2ZBemGzdO6lQt5J4ldDQ4WLshH6DcVbaIduNGto/6hqMj7YCvFfhwoTaNizJydLhWmw0rBm/+QX5IBFVdUvhAtnVEZ4Yj4yXckouN8Vm4cxERLdtb3UiWjtm6E78IpbJWrF8AQx3lZfGU2u4b3v+SZwz97aI/gwduBu9Ei8/3mS+f/Gn7KgsaJPBL4KOVQF6hhz07iXY5qQwlPKyTyCGSGGQCQ5gyTPk6MhiTxH1ix54PGUATtqZxgHd+kdWlJ9IET4DkrGasr2SKSv59J+p60aw3pDu0kFlcGyDh+o8vFWTBx0MLuCGAeLA/a9X7LG1qNQOb3VAgMBAAECggEARlcHBz4AhYvFyaUxGtj225tG04nLvk5LI4Mpipgltpd733T0Y1A0MYBeAmHHmwycDyQNjh3OqJD12CD/2VkVhzaqeo/o9a84yZ8Ma9r3DvJn10qvJqP6KKwzVEthxJpOh98BuD12UG4/8XywzfFaEcbQYopDMthfeOwQimeAGg0MFdeEuIStUp1gJzMEBhIcmQI09h6vfQ9JrNgiwGYRdnnnn0osoK5yai3DbVx5em9Kv0rAAWYxER6oLyaDNt22kNXOrUy2AnUZg6DSeb0CQcMvEOqnB5p0bFjjkUeBLQAJNU0MW58UJcq7dTl13CaSO6FpA44PYSF2X9eiBwrHZQKBgQDcB4fzxQp8z5m8+zPCw6FSNXu1t5ruxyn6RMKh3jlYHF0NSY7Tqs/T+CwS99d8ji307qDicjI6jAGW3NodbllI03MvQphcwR2YRB3m6tnBavjEHB3sHZ3nBzMZVYiygTjXPPk/6toRpiO6P0aGmvhxc7y5+etnVd4Zgm+Yn1MN2wKBgQDJ+hDOEJlAuivgn36jHKyer01tfVvaqMmMGGHNDagCe1Imk9CtiE02DkbjvgEXC5qMN9n0bGA/VSnDiEYdPJnPiDCUr0jit5QjDgAU5SKbAsxIE/auyywBZn61x6/s+fV7Ia0e3wLGf/2kC7leJnRQ7/bJSqcuMGJW+iIOeSIqDwKBgDnRDMtkenYDgy1igN5r04croJ9GaMLXuNMXoGEyaLUbduQX8RzzpHrZmpM9ZvVG0xKqZcI7KbGyunQvAm17YqC9V2YSxMCSyjkJpSXZjnDBsC6wCLjTq3taq/W7QRlO1WXRktlV2AmNM5QsLlcOf7woIm5oGpBjwuHHIZXkP8nDAoGAFD0Zh/yDzseY8/Ync2LBLVl1kb4ZAS0enQooaqqupikDT1hKdckNq5f8pH96jnucLea+0U42ysHW4H/8Ppu+8du8unlh/U3V6zlQ6scXE59RJvvRISy8qRtDISX0S/O0FHWIamqAVbGnkdOW7Ic/6ohRG1R+shMpF3wTA45BzSMCgYEArqbasTtWlDZ2ACVw05CJfSTZkW2JhyLXuLiv3cNd1XFALADRvtp6uvGT7ph1PSyEBrGuYo9LZotwLY0LAj3v+VQH329stFBcrhix59ukXmhXDTWGpDasPdhVR2YOM/CI8NaQ25yyAFOUh8jSnMMORJ5boF7WEF6xb0VLeb0jL/8="
	# print(str(body))
	c = r.rsa_encrypt_sha256_msg_by_key(publicKey,str(body))
	print(c)
	c = "Ee4bMZfBP9bLRuyNtpmDCVVM47NtAhb4tqoqyrDPJN9qtusqPFOEEJF7QTo19v4P092nMfpQQIqdz31o/L5O7Dzh28Bat27IjVJ+1TRdKAUB5o1TROKp15EXFbFaJXxYKqpC1urH8zcUeS6pcoUJArNORuBmINCVXbMcHnaChlKfJcvBMV5NGflYFjaBZXrS4ACejUXEj3VBO90/gwISb4vV73En/tJvGwdAornYHPXTYettuMAHPiRmO64fCge5sdKMXdfyycYjOcy7VgOqxL0rL+MG5VxdvU54OzeZw8fQBRMtetxXiC/nqMaw0zmGPYkDIkAbZNv6nmK3ZjjNXw=="
	# print(c.encode(encoding=encode_gbk_utf8))

	c = "NUJbDKzznxYX+WIYqb48rutTCAcSIENSO09JBRbQzgoj4LYe3uhWfsHyPHW69ImnKyyAkZjHRcvc6OK/rMr4jy0BzeVwJoRciZkqTSrt+FHyigUB/SCIIqdDbFIDmSHHgT5Y2xkiYFy+1zgg0DLq6+MaPpk6ses1Vtsoxlw7jtgaf+Zse1w4rWyx76f+nYPgqx0HG+FLkcVYDRRT+HhLbwSmNA8Y33OvUnzH6dNC1oXDOs3xuXln5MZJKKJfCTsLOi5ZlI0Q3LAfSmwZl2JJT4IcJWnlGeFaCaU6Wtw/DYn1Z83oyQMYxVhW+NpSYmo232u1kjnvi4eg/KgVHuZhzA=="
	dd = "A58ARaP3CO8hW45I9IKdXKhYvo3Y8v3IL5pz297xg%2F9HbMCItOelncJz9ScXPQfs2HwZ32b%2FOcBhR%2Bl1mOohWx%2BwvxtQiYG10syR1EM5%2FeQ%2FOI1QBiOWpgqr%2FS9Q2cV67uysQBjEDm6k2bUiuufRLTt6ykin11t%2FoKmo5dUP%2BeJbco%2F5B%2F6R3z7kkmEi7iX%2FFk3ty3q%2BhHiFNoEDc5h2zA8vX1r0mebGPIoieRoIJ89eQSSmiliKN5bNkq5hOf2oGZ9xnuHbrPKQnlw5O%2Bw9tpm3tcLvgKmIFaKSufOAdrvrySTOyXhXQRoRpCwoX1zD%2B6BBf1dMRgPVtfFMb910wg%3D%3D"
	dd = r.url_decode_to_str(dd)
	# c = "Gm7pLaPsNU/iKzYN7b/A/FLL54IsY2MKAh19FjmcE1bUDAr5tb4wXrQB15o4p4VDn3slhVl4360j/WM1PQo/+N5j5vaDIHa31gqVTcWX5RPx0GfokMyQTcAzY9OOMcxEuHbzH+lJxL42Wd4cncUNVnoLyzFHOmNN0kn2/rBKMnKlRpzPQJb8mzkCdgQ9Dj62hKMPP+4xQp2ujQ5MCctA9TkcDZB+LynzoUddOgbqIfnZvS7mlBcj4+B+n/F4sdiT4Qpe+Qoc8x6Cz4Y/0RIbWhv5HuFf5rkl0aOhBmtllWuQ8wxO4RFdY9uj4WyLQ2HjHByacx44IklEPTRazdGqEA=="
	print(urllib.parse.quote(c))
	dd = "iRXZ8fQVDMA6gB4Pn5VCqUKG23dckcHqRwaeskCvqjbgNchgvXHW3ULT42wWb76KGwh+RkOK656x9wzLxA8Wdh7OyQWGW52fC41JNSZUd/jqvm4Uy/XnYXSSu/k1Z5RaSEpGWodFpLDyZLSlew9pXlVqf+G+RGBtbFUctOLgYkaN5an2JgScy9Xn1cJLP3AL8HTLDI8Evdn4l+V21fH80Hu7qwE4oKXOCG7j+YkCNZnA4ZfUJZlX+dTC1U/8ZUur0R4ggfr3u9l1COVV/jzyqcS7dc6kL18FZtW2VPHo5brQLH+R2pUHlkQ7X5MPY4sisF1+EaCa0VFxQsqv0RPSng=="
	# dd = r.url_decode_to_str(dd)
	d = r.rsa_decrypt_sha256_msg_by_key(pk, dd)
	print(d)
