# @version ^0.2.0

@external
@pure
def ifElse(i:uint256) -> uint256:
    if i < 10:
        return 0
    elif i < 20:
        return 1
    else:
        return 2

# loop 1 array
# @external
# @pure
# def forLoop() -> (uint256):
#     x: uint256 = 0
#     for i in [1, 2, 3]:
#         x += convert(i, uint256)
#     return x
#do x là kiểu uint256 mà i lấy từng phần tử của mảng k rõ kiểu nên phải convert nó như trên. Compiler trong VSC bị lỗi

nums: public(uint256[3])
@external
def __init__():
    self.nums[0] = 1
    self.nums[1] = 2
    self.nums[2] = 3

#loop state var
@external
@view
def forLoop() -> (uint256, uint256, uint256):
    y: uint256 = 0
    for i in self.nums:
        y += i
    # ở đây ta k cần convert vì nums explicitly là uint256 r

    #loop 1 range
    z: uint256 = 0
    for i in range(10):
        z += 1

    w: uint256 = 0
    for i in range(1, 10):
        w = convert(i, uint256)
    #range co the dùng for tu 1 đến 9 như này nhưng i phải explicit kieu là uint256
    #đieu đb là giá tri 10 nó éo chạy
    return (y, z, w)

@external
@pure
def continueAndBreak() -> (uint256):
    x: uint256 = 0
    for i in [1, 2, 3, 4, 5]:
        if(i < 3)
            continue
        if i == 4:
            break
        x = convert(i, uint256) # 3
    return x

@external
def blank():
    pass
# pass giúp khai báo 1 hàm trống