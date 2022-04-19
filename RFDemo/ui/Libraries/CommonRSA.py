#!/usr/bin/python3
# python version 3.6
# pycryptodome进行RSA生成公钥、私钥，加密、解密、签名、验签
# 参考1 https://blog.csdn.net/u010693827/article/details/78629268
# 参考2 https://www.cnblogs.com/huxianglin/p/6387045.html
# 参考3 https://blog.csdn.net/orangleliu/article/details/72964948
import json
import urllib.parse,base64
from Crypto.Hash import SHA
from Crypto import Random
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as Cipher_pkcs1_v1_5
from Crypto.Signature import PKCS1_v1_5 as Signature_pkcs1_v1_5
from Crypto.Cipher import PKCS1_OAEP
from Crypto.Hash import SHA256
from urllib.parse import quote


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
		pubkey = '-----BEGIN '+'PUBLIC'+' KEY-----\n' + public_key + '\n-----END '+'PUBLIC'+' KEY-----'
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
		privatekey = '-----BEGIN'+' RSA PRIVATE '+'KEY-----\n' + private_key + '\n-----END'+' RSA PRIVATE '+'KEY-----'
		key = bytes(privatekey, encoding=encode_gbk_utf8)
		rsa_key = RSA.importKey(key)  # 导入读取到的私钥
		cipher = PKCS1_OAEP.new(rsa_key, SHA256)  # 生成对象
		message = cipher.decrypt(base64.b64decode(sign_data.encode(encoding=encode_gbk_utf8)))
		# cc = bstr(cipher_text)
		return str(message, encoding=encode_gbk_utf8)

	@staticmethod
	def encrypt(user_info,pub_key):
		content=json.dumps(user_info).encode()
		key = f"-----BEGIN PUBLIC KEY-----\n{pub_key}\n-----END PUBLIC KEY-----"
		rsa_key = RSA.import_key(key)
		cipher = PKCS1_OAEP.new(
			rsa_key,
			hashAlgo=SHA256,
		)
		return quote(base64.b64encode(cipher.encrypt(content)), safe="")
		
	@staticmethod
	def str_to_url_encode(msg):
		return urllib.parse.quote(msg)

	@staticmethod
	def url_decode_to_str(msg):
		return urllib.parse.unquote(msg)


if __name__ == '__main__':
	r = CommonRSA()
