# 给定两个单词 word1 和
#  word2 ，返回使得
#  word1 和 
#  word2 相同所需的最小步数。 
# 
#  每步 可以删除任意一个字符串中的一个字符。 
# 
#  
# 
#  示例 1： 
# 
#  
# 输入: word1 = "sea", word2 = "eat"
# 输出: 2
# 解释: 第一步将 "sea" 变为 "ea" ，第二步将 "eat "变为 "ea"
#  
# 
#  示例 2: 
# 
#  
# 输入：word1 = "leetcode", word2 = "etco"
# 输出：4
#  
# 
#  
# 
#  提示： 
#  
# 
#  
#  1 <= word1.length, word2.length <= 500 
#  word1 和 word2 只包含小写英文字母 
#  
# 
#  Related Topics 字符串 动态规划 👍 629 👎 0


# leetcode submit region begin(Prohibit modification and deletion)
class Solution(object):
    def minDistance(self, word1, word2):
        """
        :type word1: str
        :type word2: str
        :rtype: int
        """
# leetcode submit region end(Prohibit modification and deletion)
