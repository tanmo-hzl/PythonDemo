# 给你一个由若干括号和字母组成的字符串 s ，删除最小数量的无效括号，使得输入的字符串有效。 
# 
#  返回所有可能的结果。答案可以按 任意顺序 返回。 
# 
#  
# 
#  示例 1： 
# 
#  
# 输入：s = "()())()"
# 输出：["(())()","()()()"]
#  
# 
#  示例 2： 
# 
#  
# 输入：s = "(a)())()"
# 输出：["(a())()","(a)()()"]
#  
# 
#  示例 3： 
# 
#  
# 输入：s = ")("
# 输出：[""]
#  
# 
#  
# 
#  提示： 
# 
#  
#  1 <= s.length <= 25 
#  s 由小写英文字母以及括号 '(' 和 ')' 组成 
#  s 中至多含 20 个括号 
#  
# 
#  Related Topics 广度优先搜索 字符串 回溯 👍 886 👎 0


# leetcode submit region begin(Prohibit modification and deletion)
class Solution(object):
    def removeInvalidParentheses(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
# leetcode submit region end(Prohibit modification and deletion)
