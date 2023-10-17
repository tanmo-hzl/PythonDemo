# 给你一个二叉树的根结点 root ，请返回出现次数最多的子树元素和。如果有多个元素出现的次数相同，返回所有出现次数最多的子树元素和（不限顺序）。 
# 
#  一个结点的 「子树元素和」 定义为以该结点为根的二叉树上所有结点的元素之和（包括结点本身）。 
# 
#  
# 
#  示例 1： 
# 
#  
# 
#  
# 输入: root = [5,2,-3]
# 输出: [2,-3,4]
#  
# 
#  示例 2： 
# 
#  
# 
#  
# 输入: root = [5,2,-5]
# 输出: [2]
#  
# 
#  
# 
#  提示: 
# 
#  
#  节点数在 [1, 10⁴] 范围内 
#  -10⁵ <= Node.val <= 10⁵ 
#  
# 
#  Related Topics 树 深度优先搜索 哈希表 二叉树 👍 233 👎 0


# leetcode submit region begin(Prohibit modification and deletion)
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution(object):
    def findFrequentTreeSum(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        
# leetcode submit region end(Prohibit modification and deletion)
