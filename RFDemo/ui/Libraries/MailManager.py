# -*- coding:utf-8 -*-
import re
from email.mime.text import MIMEText

import poplib

import smtplib
import imaplib
import email


class MailManager(object):
    def pop3_server(self):

        self.popHost = "pop.126.com"

        self.smtpHost = "smtp.126.com"

        self.port = 110

        self.userName = "autotest12366@126.com"

        self.passWord = "BCUEPCDKUOFWBIGU"

        self.bossMail = "xxxxxx@qq.com"
        self.mailLink_server = poplib.POP3(host=self.popHost, port=self.port)
        self.login()

        # self.configMailBox()

    # 登录邮箱
    @staticmethod
    def imap_login(
        email_address="testyixian666@qq.com",
        password="pamjwrbqjugneafa",
        server="imap.qq.com",
    ):
        imap_server = imaplib.IMAP4_SSL(server)
        try:
            imap_server.login(email_address, password)
            print("login imap server successful!")
            return imap_server
        except Exception as e:
            print("login error: %s" % e)
            imap_server.close()

    @classmethod
    def imap_email_init_inbox(
        cls,
        email_address="testyixian666@qq.com",
        password="pamjwrbqjugneafa",
        server="imap.qq.com",
    ):
        try:
            imap_server = cls.imap_login(
                email_address=email_address,
                password=password,
                server=server,
            )
            # imap_server.select()
            print(imap_server.list())
            imap_server.select()
            # print(result, message)
            result, message = imap_server.search(None, "ALL")
            print(result, message)
            for num in message[0].split():

                typ, data = imap_server.fetch(num, "(RFC822)")
                print(typ, data[0][1].decode("utf-8"))
                if data[0] is not None:
                    msg = email.message_from_string(data[0][1].decode("utf-8"))
                else:
                    return 0

                # From_mail = email.utils.parseaddr(msg.get("from"))[1]
                # mail_title, mail_charset = email.header.decode_header(
                #     msg.get("Subject")
                # )[0]
                # if mail_charset is not None:
                #     mail_title = mail_title.decode(mail_charset)
                # From_mail_name = From_mail.split("@")[0]
                print("Date", msg["Date"])
                # print("From", msg["From"], From_mail, From_mail_name)
                # print("content", msg["content"])
                # print(msg["Subject"], mail_title, mail_charset)
                # print("****************" * 8)
                pattern_uid = re.compile("\d+ \(UID (?P<uid>\d+)\)")
                resp, data = imap_server.fetch(num, "(UID)")
                match = pattern_uid.match(data[0].decode("utf-8"))
                msg_uid = match.group("uid")
                imap_server.select("INBOX", readonly=False)
                # type_, data = imap_server.search(None, "ALL")
                # rsp, mesgs = imap_server.select("new_box")
                # print(333333333333,rsp,mesgs)
                # if rsp=="NO":
                #     ddddd=M.create("new_box")
                #     print(4445444444,ddddd)
                # imap_server.select()
                result = imap_server.uid("COPY", msg_uid, "Drafts")
                print("email save to Drafts", result)
                mov, data = imap_server.uid("STORE", msg_uid, "+FLAGS", "(\\Deleted)")
                print("Deleted email", mov, data)

                result, message = imap_server.search(None, "ALL")
                print(result, message)
            message, data = imap_server.select()
            imap_server.expunge()
            result, message = imap_server.search(None, "ALL")
            print(result, message)
            imap_server.close()
            imap_server.logout()
            print("close email imap server!")
            return data[0].decode()
            # M.close()
        except Exception as e:
            imap_server.close()
            raise Exception("imap error: %s" % e)

    @classmethod
    def imap_inbox_in_class_email(
        cls,
        class_name="test special word",
        order_number="7877942376883486",
        email_address="testyixian666@qq.com",
        password="pamjwrbqjugneafa",
        server="imap.qq.com",
    ):
        imap_server = cls.imap_login(
            email_address=email_address,
            password=password,
            server=server,
        )
        result, message = imap_server.select()
        if message[0].decode() != "1":
            raise Exception("预期收到一封邮件，收件箱收到邮件不止一件")
        for num in message[0].split():
            typ, data = imap_server.fetch(num, "(RFC822)")
            print(typ, data[0][1].decode("utf-8"))
            if data[0] is not None:
                msg = email.message_from_string(data[0][1].decode("utf-8"))
                if (
                    msg["Subject"]
                    == f"Class Enrollment Confirmation for - {class_name}"
                ):
                    pattern_class_name = re.compile("CLASS NAME ([\w ]+) \(")
                    class_result = pattern_class_name.findall(
                        data[0][1].decode("utf-8")
                    )
                    pattern_order_number = re.compile("ORDER (\d+)")
                    order_result = pattern_order_number.findall(
                        data[0][1].decode("utf-8")
                    )
                    if class_result[0] != class_name or order_result[0] != str(
                        order_number
                    ):
                        raise Exception(
                            f"email in class name:{class_result[0]}!={class_name} or email_order_number:{order_result[0]}!={order_number}"
                        )
            else:
                raise Exception("inbox no email!")

    @classmethod
    def imap_inbox_in_scheduled_within_24_hours_email(
        cls,
        class_name="test special word",
        order_number="7877942376883486",
        email_address="testyixian666@qq.com",
        password="pamjwrbqjugneafa",
        server="imap.qq.com",
    ):
        imap_server = cls.imap_login(
            email_address=email_address,
            password=password,
            server=server,
        )
        imap_server.select()
        result, message = imap_server.search(None, "ALl")
        if message[0].decode() != "1 2":
            raise Exception("预期收到2封邮件，收件箱收到邮件不是2封")
        for num in message[0].split():
            typ, data = imap_server.fetch(num, "(RFC822)")
            print(typ, data[0][1].decode("utf-8"))
            if data[0] is not None:
                msg = email.message_from_string(data[0][1].decode("utf-8"))
                if (
                    msg["Subject"]
                    == f"Class Enrollment Confirmation for - {class_name}"
                ):
                    pattern_class_name = re.compile("CLASS NAME ([\w ]+) \(")
                    class_result = pattern_class_name.findall(
                        data[0][1].decode("utf-8")
                    )
                    pattern_order_number = re.compile("ORDER (\d+)")
                    order_result = pattern_order_number.findall(
                        data[0][1].decode("utf-8")
                    )
                    if class_result[0] != class_name or order_result[0] != str(
                        order_number
                    ):
                        raise Exception(
                            f"email in class name:{class_result[0]}!={class_name} or email_order_number:{order_result[0]}!={order_number}"
                        )
                elif(msg["Subject"]
                    == "Your class starts in less than 24 hours!"):
                    pattern_order_number = re.compile("ORDER (\d+)")
                    order_result = pattern_order_number.findall(
                        data[0][1].decode("utf-8")
                    )
                    if order_result[0] != str(
                        order_number
                    ):
                        raise Exception(f"email in order_number:{order_result[0]}!={order_number}")

            else:
                raise Exception("inbox no email!")

    def login(self):

        try:
            print(111)
            # self.mailLink_server = poplib.POP3(host=self.popHost, port=self.port)
            self.mailLink_server.set_debuglevel(0)

            self.mailLink_server.user(self.userName)

            self.mailLink_server.pass_(self.passWord)

            print(self.mailLink_server.list())

            print("login success!")

        except Exception as e:

            print("login fail! " + str(e))

            quit()

    # 获取邮件

    def retrMail(self):

        try:

            mail_list = self.mailLink_server.list()[1]

            if len(mail_list) == 0:
                return None

            mail_info = mail_list[0].split(" ")

            number = mail_info[0]

            mail = self.mailLink_server.retr(number)[1]

            self.mailLink_server.dele(number)

            subject = ""

            sender = ""

            for i in range(0, len(mail)):

                if mail[i].startswith("Subject"):
                    subject = mail[i][9:]

                if mail[i].startswith("X-Sender"):
                    sender = mail[i][10:]

            content = {"subject": subject, "sender": sender}

            return content

        except Exception as e:

            print(str(e))

            return None

    def configMailBox(self):

        try:

            self.mail_box = smtplib.SMTP(self.smtpHost, self.port)

            self.mail_box.login(self.userName, self.passWord)

            print("config mailbox success!")

        except Exception as e:

            print("config mailbox fail! " + str(e))

            quit()

    # 发送邮件

    def sendMsg(self, mail_body="Success!"):

        try:

            msg = MIMEText(mail_body, "plain", "utf-8")

            msg["Subject"] = mail_body

            msg["from"] = self.userName

            self.mail_box.sendmail(self.userName, self.bossMail, msg.as_string())

            print
            "send mail success!"

        except Exception as e:

            print
            "send mail fail! " + str(e)


# if __name__ == "__main__":

# mailManager = MailManager()
# # mailManager.login()
# mail = mailManager.retrMail()
# print(mail)
# if mail != None:
#     print(mail)
#
#     mailManager.sendMsg()
