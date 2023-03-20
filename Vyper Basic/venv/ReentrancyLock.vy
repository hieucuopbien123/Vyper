# @version ^0.2.0

locked: bool

@external
def func():
    assert not self.locked, "locked"
    self.locked = True
    raw_call(msg.sender, b"", value=0)
    #more code here
    self.locked = False
#Hàm khi gọi tới func nó sẽ gọi raw_call lại cái fallback của contract gọi nó và gửi và 0 ether. reentrancy 
#ở chỗ hàm fallback sẽ lại call lại func khiến phần code dưới k được thực thi mà bị recursive lại luôn
# Có thể phòng nó với locked như trên nhưng trong Vyper có sẵn chống reentrancy rồi

event Log:
    message: String[100]
@external
@nonreentrant("lock")
def callMe():
    log Log("Here")
    raw_call(msg.sender, b"", value=0)
