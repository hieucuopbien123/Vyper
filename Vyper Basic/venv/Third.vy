# @version ^0.2.0

# tạo constructor payable
owner: public(address)
value: public(uint256)
pivVar: String[20] # đây là 1 private var

@external
@payable
def __init__():
    self.owner = msg.sender
    self.value = msg.value
    self.pivVar = "Hello World"

# local var và param truyen vào function k đc có tên trùng với bất kỳ state var nào trong contract -> name shadowing
# trong vyper có các var có san mà ta k the đat 1 bien moi cung ten như v VD balance

MY_CONSTANT: constant(uint256) = 123

@external
@pure
def getBuiltInConstants() -> (address, uint256):
    return (ZERO_ADDRESS, MAX_UINT256)

@external
@payable
def returnEnvironmentVars() -> (
    uint256, address, uint256, uint256, uint256, address
):
    return (
        self.balance,
        msg.sender,
        msg.value,
        block.number,
        block.timestamp,
        tx.origin
    )