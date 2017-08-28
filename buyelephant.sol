pragma solidity ^0.4.0;
contract Main  {

    address public owner;
    address public buyer;
    address public seller;
    address public rosreestr;
    address public fds;
    address public dduorderContract;
     function Main(){
        owner = msg.sender;
    }

    function createUser(address _buyer,address _seller,address _rosreestr,address _fds )isOwner returns(bool){
        buyer = _buyer;
        seller = _seller;
        rosreestr = _rosreestr;
        fds = _fds;
        return true;
    }

    function createDdu(string _idObject,uint _cost)isOwner returns (address){

        dduorderContract = new DduOrder(_idObject, _cost,buyer,seller,rosreestr,fds);
        return dduorderContract;
    }

     modifier isOwner {
        if (msg.sender == owner)
        _;
    }
}

contract DduOrder  {

    address public buyer;
    address public seller;
    address public rosreestr;
    address public fds;
    string public idObject;
    uint public cost;
    uint public balanceSeller=0;
    uint public balanceFrost=0;
    uint public status=0;

    function DduOrder(string _idObject,uint _cost,address _buyer,address _seller,address _rosreestr,address _fds){
        idObject = _idObject;
        cost = _cost;
        buyer=_buyer;
        seller = _seller;
        rosreestr = _rosreestr;
        fds = _fds;

    }

    function depositMoneySeller() isSeller returns (uint) {
        if(status != 0)
            throw;
        else{
            status=1;
            balanceSeller = cost;
        }
        return status;
    }

    function requestAccepted() isRosreestr returns (uint) {
        if(status != 1)
            throw;
        else
            status=2;

        return status;
    }

    function reserveMoney(uint summ) isFds returns (uint) {
        if(status != 2)
            throw;
        else{
            status=3;
            balanceFrost = summ;}
        return status;
    }


    function reserveInRosreestr() isRosreestr returns (uint)  {
        if(status != 3)
            throw;
        else
            status=4;

        return status;
    }

    function chargedInFds() isFds returns (uint) {
        if(status != 4)
            throw;
        else{
            status=5;
            balanceSeller-=balanceFrost;
            balanceFrost=0;
    }
     return status;
    }

    function buerSendMoney() isBuyer returns (uint) {
        if(status != 5)
            throw;
        else
            status=6;

        return status;
    }

    function buildingIsComplete() isFds returns (uint)  {
        if(status != 6)
            throw;
        else
            status=7;
        return status;
    }

    function dduComplete() isRosreestr returns (uint) {
        if(status != 7)
            throw;
        else
            status=8;
        return status;
    }

    modifier isBuyer {
        if (msg.sender == buyer)
        _;
    }

    modifier isSeller {
        if (msg.sender == seller)
        _;
    }

    modifier isRosreestr {
        if (msg.sender == rosreestr)
        _;
    }

    modifier isFds {
        if (msg.sender == fds)
        _;
    }

}
