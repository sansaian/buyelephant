pragma solidity ^0.4.0;
contract Main  {

    /*/
     *  Contract fields
    /*/
    address public owner;
    address public buyer;
    address public seller;
    address public rosreestr;
    address public fds;
    address public dduorderContract;
     
    function Main(){
        owner = msg.sender;
    }

    /*/
     *  Public functions
    /*/
    // @dev assign roles to public keys
    // @returns success flag
    // @param _buyer role building buyer
    // @param _seller role building seller
    // @param _rosreestr role ROSREESTR
    // @param _fds role Fond dolevogo stroitelstva :)
    function createUser(address _buyer,address _seller,address _rosreestr,address _fds )isOwner returns(bool){
        buyer = _buyer;
        seller = _seller;
        rosreestr = _rosreestr;
        fds = _fds;
        return true;
    }

    /*/
     *  Public functions
    /*/
    // @dev registers DDU document inside the system
    // @returns created ddu address contract
    // @param _idObject Building identity
    // @param _cost DDU price
    function createDdu(string _idObject,uint _cost)isOwner returns (address){
        dduorderContract = new DduOrder(_idObject, _cost,buyer,seller,rosreestr,fds);
        return dduorderContract;
    }

    /*/
     *  Modifiers
    /*/
     modifier isOwner {
        if (msg.sender == owner)
        _;
    }
}

contract DduOrder  {

    /*/
     *  Contract fields
    /*/
    address public buyer;
    address public seller;
    address public rosreestr;
    address public fds;
    string public idObject;
    uint public cost;
    uint public balanceSeller=0;
    uint public balanceFrost=0;
    uint public status=0;

    /*/
     *  Сonstructor
    /*/
    function DduOrder(string _idObject,uint _cost,address _buyer,address _seller,address _rosreestr,address _fds){
        idObject = _idObject;
        cost = _cost;
        buyer=_buyer;
        seller = _seller;
        rosreestr = _rosreestr;
        fds = _fds;

    }

    /*/
     *  Public functions
    /*/

    // @dev deposit money to seller account
    function depositMoneySeller() isSeller returns (uint) {
        if(status != 0)
            throw;
        else{
            status=1;
            balanceSeller = cost;
        }
        return status;
    }

    // @dev request rosreestr to register the DDU document
    function requestAccepted() isRosreestr returns (uint) {
        if(status != 1)
            throw;
        else
            status=2;

        return status;
    }

    // @dev "freeze" money of seller inside FDS fund
    // @param summ amount of money to hold
    function reserveMoney(uint summ) isFds returns (uint) {
        if(status != 2)
            throw;
        else{
            status=3;
            balanceFrost = summ;}
        return status;
    }

    // @dev register DDU inside Rosreestr
    function reserveInRosreestr() isRosreestr returns (uint)  {
        if(status != 3)
            throw;
        else
            status=4;

        return status;
    }

    // @dev charge "frozen" money from account
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

    // @dev pay money for the DDU registration
    function buerSendMoney() isBuyer returns (uint) {
        if(status != 5)
            throw;
        else
            status=6;

        return status;
    }

    // @dev launch building in production mode!
    function buildingIsComplete() isFds returns (uint)  {
        if(status != 6)
            throw;
        else
            status=7;
        return status;
    }

    // @dev done with DDU document registration
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