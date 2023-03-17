# @version ^0.2.0

"""
các biến này toàn là value, kp reference tức là ta có thể gán copy trực tiếp VD gán a = b với a và b là biến 
Bytes[100] tương đương chạy vòng for 100 turns copy 100 giá trị b cho a. Trong solidity nó là reference type
"""

# variable store on blockchain
b: public(bool)
i: public(int128) #-2**127 -> 2**127-1
d: public(decimal) #range giống int128, cung max đến 10 decimal places => solidity k có, remix lỗi hiển thị
b32: public(bytes32)
u: public(uint256)
addr: public(address)
bs: public(Bytes[100])# values type nhieu ptu k được dùng mảng đong, buoc có sl phần tử
s: public(String[100])

@external
def __init__():#ham init tu được goi duy nhat 1 lan khi deploy contract
    self.b = True
    self.i = -1
    self.d = 3.14
    self.addr = 0x67cFdC7B43eF8d8b2893db504Da3Ab0c29BFb461
    self.b32 = 0xada1b75f8ae9a65dcc16f95678ac203030505c6b465c8206e26ae84b525cdacb
    self.bs = b"\x01"
    self.s = "This is a string"
    self.u = 123
