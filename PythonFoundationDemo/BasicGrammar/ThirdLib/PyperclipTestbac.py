'''
pyperclip 模块有copy()和paste()函数，可以向计算机的剪贴板发送文本，或从
它接收文本。将程序的输出发送到剪贴板，使它很容易粘贴到邮件、文字处理程序
或其他软件中。pyperclip 模块不是Python 自带的。要安装它，请遵从附录A 中安
装第三方模块的指南。安装pyperclip 模块后，在交互式环境中输入以下代码：
>>> import pyperclip
>>> pyperclip.copy('Hello world!')
>>> pyperclip.paste()
'Hello world!'
当然，如果你的程序之外的某个程序改变了剪贴板的内容，paste()函数就会返
回它。例如，如果我将这句话复制到剪贴板，然后调用paste()，看起来就会像这样：
>>> pyperclip.paste()
'For example, if I copied this sentence to the clipboard and then called
paste(), it would look like this:'

'''