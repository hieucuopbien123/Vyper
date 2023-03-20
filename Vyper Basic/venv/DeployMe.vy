# @version ^0.2.0

owner: public(address)
name: public(String[100])

@external
def __init__():
    self.owner = msg.sender
    self.name = "Foo bar"

@external
def setup(_name: String[100]):
    assert self.owner == ZERO_ADDRESS, "owner != zero address"
    self.owner = msg.sender
    self.name = _name

@external
def kill():
    selfdestruct(msg.sender)
# chú ý kbh dùng selfdestruct trong contract được dùng bởi hàm create_forwarder_to
# bởi vì các contract được tạo ra bởi create_forwarder_to sẽ dùng code của contract master copy khi muốn execute 1
# function. Nên nếu gọi selfdestruct master copy thì các contract được tạo ra từ create_forwarder_to từ nó sẽ 
# không thể execute được function nào nx
# điều thú vị là contract con dùng code của master copy nhưng storage riêng klq j đến master copy và khi deploy kiểu đó
# nó k chạy hàm init