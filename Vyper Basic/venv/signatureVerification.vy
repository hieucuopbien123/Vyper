# @version ^0.2.0
"""
Quy trình: hash message to sign -> sign message hash offchain by metamask -> verify signature onchain by this contract

Cách thực hiện: deploy contract-> getHash cái message của ta-> console của browser gõ ethereum.enable().then(consol.log)
-> ethereum.request({method: "personal_sign",params:[account,hash]}).then(console.log); -> có signature
-> lấy getEthSignedHash của cái hash và gọi verify
Ở đây ta ký bằng piv key của ta và mọi người đều vào xác nhận được rằng ta đã ký cái message bằng cách đưa cho
họ signature và message, họ sẽ cho ra đúng pubkey của ta vì phải ký từ pivkey của ta mới cho ra pubkey cặp vs nó đc
"""

@external
@pure
def getHash(_str: String[100]) -> bytes32:
    return keccak256(_str)

@external
@pure
def getEthSignedHash(_hash: bytes32) -> bytes32:
    return keccak256(
        concat(
            b'\x19Ethereum Signed Message:\n32',
            _hash
        )
    )

@external
@pure
def verify(_ethSignedHash: bytes32, _sig: Bytes[65]) -> address:
    r: uint256 = convert(slice(_sig, 0, 32), uint256)
    s: uint256 = convert(slice(_sig, 32, 32), uint256)
    v: uint256 = convert(slice(_sig, 64, 1), uint256)
    #từ position 64 của sig ta lấy 1 bytes(ra uint8) và convert sang uint256
    return ecrecover(_ethSignedHash, v, r, s)