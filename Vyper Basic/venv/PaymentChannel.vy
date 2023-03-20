# @version ^0.2.0

sender: public(address)
receiver: public(address)

DURATION: constant(uint256) = 7*24*60*40
expiratesAt: public(uint256)

# A deploy ra thì A cx gửi vào đây 1 số tiền
@external
@payable
def __init__(_receiver: address):
    assert _receiver != ZERO_ADDRESS, "receiver == 0 address"
    self.sender = msg.sender
    self.receiver = _receiver
    self.expiratesAt = block.timestamp + DURATION

# để tránh signature replay attack, thêm address contract này
# mỗi lần deploy contract này là 1 payment channel giữa 2 người lập ra
@internal
@pure
def _getHash(_amount: uint256) -> bytes32:
    return keccak256(concat(
        convert(self, bytes32),
        convert(_amount, bytes32)
    ))
@external
@view
def getHash(_amount: uint256) -> bytes32:
    return self._getHash(_amount)

# thực sự nó signed cái dưới cơ
@internal
@view
def _getEthSignedHash(_amount: uint256) -> bytes32:
    hash: bytes32 = self._getHash(_amount)
    return keccak256(
        concat(
            b'\x19Ethereum Signed Message:\n32',
            hash
        )
    )
@external
@view
def getEthSignedHash(_amount: uint256) -> bytes32:
    return self._getEthSignedHash(_amount)

@internal
@view
def _verify(_amount: uint256, _sig: Bytes[65]) -> bool:
    ethSignedHash: bytes32 = self._getEthSignedHash(_amount)
    r: uint256 = convert(slice(_sig, 0, 32), uint256)
    s: uint256 = convert(slice(_sig, 32, 32), uint256)
    v: uint256 = convert(slice(_sig, 64, 1), uint256)
    return ecrecover(ethSignedHash, v, r, s) == self.sender
@external
@view
def verify(_amount: uint256, _sig: Bytes[65]) -> bool:
    return self._verify(_amount, _sig)

# Khi receiver close thì số tiền gửi cho receiver rút ra còn tiền thừa gửi lại sender. Tránh receiver gây reentrancy
@external
@nonreentrant("lock")
def close(_amount: uint256, _sig: Bytes[65]):
    assert msg.sender == self.receiver, "!receiver"
    assert self._verify(_amount, _sig), "invalid sig"
    raw_call(self.receiver, b'\x00', value=_amount)
    selfdestruct(self.sender)

# Thực tế, quyền lợi của sender k đảm bảo. VD A gửi B 1 ether là đúng luật nhưng B lại bảo A phải gửi cho mình
# 2 ether cơ. Chừng nó B k close cái channel thì ether của A sẽ lock trong contract này mãi. Do đó phải có tính
# năng expire. Ở đây nếu 7 ngày sau mà channel k được close thì A có quyền rút hết tiền của mình ra bằng hàm dưới
@external
def cancel():
    assert msg.sender == self.sender, "!sender"
    assert block.timestamp >= self.expiratesAt, "!expired"
    selfdestruct(self.sender)

# Điều đặc biệt là ta dùng selfdestruct nên mỗi khi B claim money thì channel sẽ đóng lại, anh ta k thể claim nhiều lần
# với nhiều chữ ký được.
# A deploy trans -> gọi getHash và dùng metamask ký cho phép B rút 1 ether r gửi sig cho B -> lại muốn gửi B 1 ether nx
# thì A lại gọi getHash dùng metamask ký cho phép B rút 2 ether và gửi B -> giao dịch xong B có 2 signature 1 ether và
# 2 ether thì dương nhiên B sẽ đóng trans với sig rút 2 ether rồi là contract tự huy luôn
# => Payment Channel cũng chỉ là smart contract ez như v

# Ở trên có hàm verify là 1 hàm external là để cho B có thể kiểm tra bất cứ lúc nào rằng sig mà A gửi cho mình có
# đúng hay không.Vì A bịa ra 1 sig gửi cho thì chết. Đó cx là NN có cặp hàm internal và external để bên ngoài check như v