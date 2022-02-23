# @version ^0.2.0

# event thg use là storage data cho các ứng dung; đe ứng dụng bat các sự kien của smart contract
# VD có ngưoi gui tien thì báo ve máy chang hạn thì đieu này chỉ làm được bằng event
event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: indexed(uint256)
# chỉ max 3 tham số của event có indexed, lon hơn sẽ báo loi

@external
def transfer(to: address, amount: uint256):
    log Transfer(msg.sender, to, amount)

# Probs: we have an app with function to confirm and unconfirm for each person in smart contract. But then we want
# to get the list of person which are confirmed -> we can store it on array confirmations and when we unconfirm, we can
# remove that from array -> but we can do it cheaper with event because it allow us to store data
event Authorized:
    addr: indexed(address)
    authorized: bool
# mỗi lần confirm ta sẽ: log Authorized(address, True)
# mỗi lần unconfirm ta sẽ: log Authorized(address, False)
# mỗi lần muốn lấy cái list được confirm => duyệt mọi block từ đầu tới lastest block lấy mọi event tên là Authorized
# và lấy mọi address -> nếu True thì thêm vào mảng, nếu False thì bỏ ra khỏi mảng, cuối cùng là có list address -> thao
# tác này tùy vào lúc đó viết bằng gì, thg là JS

event Payment:
    sender: indexed(address)
    amount: uint256
    bal: uint256
    gasLeft: uint256

@external
@payable
def __default__():
    log Payment(msg.sender, msg.value, self.balance, msg.gas)
    #trước khi gọi log thì số dư đã tăng lên
#default là hàm đặc biệt k params, k return được gọi khi call non-existing func or gửi ether vào contract này

# send ether vào address khác. Hàm send sẽ forward 2300 gas có nghĩa là VD nó gửi cho 1 contract khác có hàm 
#__default__ thì hàm __default__ đó chỉ được sử dụng max 2300 gas nên msg.gas trả lượng gas remain của nó luôn 
#< 2300, còn bth thì gasLeft rất lớn 
@external
@payable
def sendEther(to: address):
    send(to, msg.value)