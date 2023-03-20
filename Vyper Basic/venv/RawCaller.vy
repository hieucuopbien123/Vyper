# @version ^0.2.0

"""
VD trong uniswap, ta dùng dynamic array address[] để truyền vào 1 mảng các address để tìm ra address cặp pair nào 
đến được cái token cần lấy. Nhưng trong Vyper không có dynamic array => buộc dùng raw_call
"""
event Log:
    message: String[100]
    val: uint256

#ta dùng raw_call để gọi hàm của contract RawCallReceiver biết tham số truyền vào là dynamic array mà vyper k có
@external
def callTest(test: address, x: uint256, y: uint256):
    raw_call(
        test,#address contract muốn gọi hàm trong nó
        concat(
            method_id("test(uint256,uint256,uint256[])"),#lấy first 4 bytes hash of function signature
            convert(x, bytes32),#convert uint256 sang bytes32(kích thước tương đương nhau)
            convert(y, bytes32),
            convert(96, bytes32),# offset vị trí bắt đầu của dynamic array. Vì x,y tốn tổng 64 bytes và bản thân
            #tên biến của dynamic array take 32bytes nữa nên bắt đầu từ 96 bytes
            convert(2, bytes32),#kích thước của dynamic array
            convert(88, bytes32),#các thành phần trong dynamic array
            convert(99, bytes32)
        ),
        max_outsize=0#max output size
    )

@external
def callTest1(test: address, x: uint256, y: uint256):
    res: Bytes[128] = raw_call(
        test,
        concat(
            method_id("test(uint256,uint256,uint256[])"),
            convert(x, bytes32),#truyền param1
            convert(y, bytes32),#truyền param2
            #truyền param3 gồm (phải convert hết sang bytes32 trong raw call)
            convert(96, bytes32),#offset
            convert(2, bytes32),#length
            convert(88, bytes32),#giá trị ele1
            convert(99, bytes32)#giá trị ele2
        ),
        max_outsize=128
    )
    #lấy output cx như cách lấy input: offset, length, element 0, element 1,.. Output là 1 variable lưu 3 thứ đó
    #VD ở đây dynamic arr lấy ra có 2 phần tử thì cần 4*32=128 bytes vì offset+length+ele0+ele1
    offset: uint256 = extract32(res, 0, output_type=uint256)#lấy 32bytes từ res kể từ vị trí 0 ra type uint256
    l: uint256 = extract32(res, 32, output_type=uint256)
    y0: uint256 = extract32(res, 64, output_type=uint256)
    y1: uint256 = extract32(res, 96, output_type=uint256)
    #để check
    log Log("offset", offset)
    log Log("length", l)
    log Log("y0", y0)
    log Log("y1", y1)

"""
def raw_call(a, b, outsize=c, gas=d, value=e, delegate_call=f) -> g:
  :param a: the destination address to call to
  :type a: address
  :param b: the data to send the called address
  :type b: bytes
  :param c: the max-length for the bytes array returned from the call.
  :type c: fixed literal value
  :param d: the gas amount to attach to the call.
  :type d: uint256
  :param e: the wei value to send to the address (Optional, default: 0)
  :type e: uint256
  :param f: the bool of whether or not to use DELEGATECALL (Optional, default: False)
  :type f: bool

  :output g: bytes[outsize] => lấy ra output như VD trên là 1 mảng động
  => các params có thể bị miss và truyền params tiếp theo thoải mái
  """