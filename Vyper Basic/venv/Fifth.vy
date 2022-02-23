# @version ^0.2.0

x: public(String[10])
owner: public(address)

@external 
def __init__():
    self.owner = msg.sender

@external
def setX(_x: String[10]):
    if self.owner != msg.sender:
        raise "!owner"
    assert self.owner == msg.sender, "!owner"
    self.x = _x

# trong internal function k có msg.sender gì hết nên muốn lấy ta phải truyền vào như dưới
# nếu 1 hàm gọi 1 hàm con mà hàm con báo lỗi thì hàm mẹ sẽ dừng hoạt động và báo ra lỗi của hàm con
@internal
def _setX(sender: address,_x: String[10]):
    if self.owner != sender:
        raise "!owner"
    assert self.owner == sender, "!owner"
    self.x = _x

@external
def setXtoFoo():
    self._setX(msg.sender, "Foo")
    # truyền như này để dùng msg.sender trong internal function
    # msg.sender != owner sẽ báo lỗi trong hàm _setX và hàm này cũng dừng và trả lỗi đó
    self.x = "Bar"

@external
def unreachable():
    raise UNREACHABLE
# trả ra lỗi unreachable và dùng hết gas => k dùng trong thực tế vì tốn gas