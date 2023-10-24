# 给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target 的那 两个 整数，并返回它们的数组下标。 
# 
#  你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。 
# 
#  你可以按任意顺序返回答案。 
# 
#  
# 
#  示例 1： 
# 
#  
# 输入：nums = [2,7,11,15], target = 9
# 输出：[0,1]
# 解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
#  
# 
#  示例 2： 
# 
#  
# 输入：nums = [3,2,4], target = 6
# 输出：[1,2]
#  
# 
#  示例 3： 
# 
#  
# 输入：nums = [3,3], target = 6
# 输出：[0,1]
#  
# 
#  
# 
#  提示： 
# 
#  
#  2 <= nums.length <= 10⁴ 
#  -10⁹ <= nums[i] <= 10⁹ 
#  -10⁹ <= target <= 10⁹ 
#  只会存在一个有效答案 
#  
# 
#  
# 
#  进阶：你可以想出一个时间复杂度小于 O(n²) 的算法吗？ 
# 
#  Related Topics 数组 哈希表 👍 17816 👎 0


# leetcode submit region begin(Prohibit modification and deletion)
# class Solution(object):
#     def twoSum(self, nums, target):
#         """
#         :type nums: List[int]
#         :type target: int
#         :rtype: List[int]
#         dd
#         """
from typing import List


class Solution:
    # 方法一：直接嵌套循环
    def two_sum_1(self, nums: List[int], target: int) -> List[int]:
        n = len(nums)
        for i in range(n):
            for j in range(i + 1, n):
                if nums[i] + nums[j] == target:
                    return [i, j]

        return []

    # 方法二：通过hash表来进行匹配
    def two_sum_2(self, nums: List[int], target: int) -> List[int]:
        hashtable = dict()
        for i, num in enumerate(nums):
            if target - num in hashtable:  # 判断"target-num"的数是否在hashtable中。如果在，直接返回当前数的下标和 “target-num”的下标
                return [hashtable[target - num], i]
            hashtable[nums[i]] = i  # 在hashtable中没有找到"target-num"这个数，则将{num : i } 存入hashtable中，供下次查找使用
        return []

    def two_sum_2_bak(self, nums: List[int], target: int) -> List[int]:
        hashtable = {}
        for i, num in enumerate(nums, 0):
            if target - num in hashtable:
                return [hashtable[target - num], i]
            hashtable[num] = i
        return []


if __name__ == '__main__':
    sol = Solution()
    nums = [3, 2, 4, 3]
    target = 6
    result = sol.two_sum_2_bak(nums, target)
    print(result)

# leetcode submit region end(Prohibit modification and deletion)
