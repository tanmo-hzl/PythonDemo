# 给定整数 n 和 k，返回 [1, n] 中字典序第 k 小的数字。 
# 
#  
# 
#  示例 1: 
# 
#  
# 输入: n = 13, k = 2
# 输出: 10
# 解释: 字典序的排列是 [1, 10, 11, 12, 13, 2, 3, 4, 5, 6, 7, 8, 9]，所以第二小的数字是 10。
#  
# 
#  示例 2: 
# 
#  
# 输入: n = 1, k = 1
# 输出: 1
#  
# 
#  
# 
#  提示: 
# 
#  
#  1 <= k <= n <= 10⁹ 
#  
# 
#  Related Topics 字典树 👍 580 👎 0


# leetcode submit region begin(Prohibit modification and deletion)
class Solution(object):
    def findKthNumber(self, n, k):
        """
        :type n: int
        :type k: int
        :rtype: int
        """
# leetcode submit region end(Prohibit modification and deletion)
