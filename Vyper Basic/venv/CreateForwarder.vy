# @version ^0.2.0

interface DeployMe:
    def setup(name: String[100]): nonpayable

@external
def deploy(_masterCopy: address, _name: String[100]) -> address:
    addr: address = create_forwarder_to(_masterCopy)
    DeployMe(addr).setup(_name)
    return addr
#Vđ là ta muốn deploy contract DeployMe 10 lần -> nhưng phí của 1 lần deploy rất cao. Hàm create_forwarder_to
#nhận vào address của hàm đã deploy rồi và deploy ra 1 contract tương tự như nó ra 1 địa chỉ mới với giá rẻ
#nên ta luôn dùng nó nó nếu muốn deploy 1 contract nhiều lần. Nhưng khi gọi trong Vyper thì nó sẽ k gọi vào
#constructor __init__ nên ta phải thêm hàm setup để gán cho nó bên dưới, nhưng dù v giá gas vẫn rẻ hơn
#contract gốc được deploy để create_forwarder_to deploy theo được gọi là master copy contract