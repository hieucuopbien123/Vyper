# @version ^0.2.0

# Reference types trong Vyper khác với các ngôn ngữ khác vì khi gán nó copy chứ k đổi được giá trị gốc
struct Person:
    name: String[100]
    age: uint256

nums: public(uint256[10])#list
myMap: public(HashMap[address, uint256])#mapping
person: public(Person)#struct
@external
def __init_():
    self.nums[5] = 123
    self.myMap[msg.sender] = 456
    self.person.name = "Vyper"
    
    arr: uint256[10] = self.nums
    arr[0] = 999 #k đổi nums[0]

    #mapping k thể dùng local var

    p: Person = self.person
    p.name = "Solidity" #struct reference cũng không đổi

# trong Vyper thì visibility chỉ có internal or external, k thể có hàm vua goi trong contract, vua goi ngoài contract đc
# trong Vyper chỉ có 4 mutability: nonpayable, view, pure, payable.
# VD pure k truy cập được msg.sender còn view thì có
@external
@pure
def simple(x: uint256, b: bool, s: String[10]) -> (uint256, bool, String[100]):
    return (x + 1, not b, concat(s, "?"))# concat string trong Vyper

@internal
@pure
def intFunc(x: uint256, y: uint256) -> (uint256, bool):
    return (x*y, True)

@external
@view
def extFunc(x: uint256) -> uint256:
    i: uint256 = 1
    b: bool = False
    (i, b) = self.intFunc(1,2)
    return x*x

num: public(uint256)
@external
@view
def viewFunc(x: uint256) -> (uint256, address, bool):
    return(x + self.num, msg.sender, x > 2)

message: public(String[10])
# K khai báo thì hàm đổi state var được, mặc định mutability là nonpayable 
@external
def writeSomething(_message: String[10]):
    self.message = _message

value: public(uint256)
@external
@payable
def receiveEther():
    self.value = msg.value
