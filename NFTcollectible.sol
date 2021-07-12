pragma solidity 0.8.1;

contract NFT {
    
    uint private _collectibleId;
    
    struct collectible {
        uint tokenId;
        string collectibleName;
        address owner;
        address collectibleApprovals;
        uint minCollectiblePrice;
        
    }
    
    
    mapping(uint => collectible) public collectibles;
    
    
    constructor() {
        _collectibleId = 0;
    }
    
    //This is to verify whether the collectible created is already present or not.
    function _exists(string memory _collectible) internal returns(bool){
        //incomplete function
        return false;
    }
    
    /*
    Creating a new collectible(in our case a collectible name)
    parameters: 
            str: _collectibleName   : name of the collectible to be created
            uint: _minCollectiblePrice  : Minimum price of the collectible created
    */
    function mintNFT(string memory _collectibleName , uint _minCollectiblePrice) external payable returns(uint) {
        _collectibleId++;
        
        require(msg.value > 1 ether , "Minimum amount create a collectible is 1 ether");
        require(_exists(_collectibleName) == false , "This name is already minted");
        
        collectibles[_collectibleId] = collectible( _collectibleId , _collectibleName , msg.sender , address(0) , _minCollectiblePrice);
        
        return _collectibleId;
    }
    
    /*
    Buying a collectible that is already created
    parameters:
            uint: _id  : collectibleId of the collectible that the user want to buy.
    */
    
    function buyCollectible(uint _id) external payable returns(bool){
        require(_collectibleId >= _id , "collectibleId is not available");
        
        collectible memory _collectible = collectibles[_id];
        require(msg.value >= _collectible.minCollectiblePrice , "price of the collectible is more than that");
        require(msg.sender != _collectible.owner , "owner to owner itself not possible");
        
        _collectible.collectibleApprovals = msg.sender;
        //sendEther(_collectible.owner , _collectible.minCollectiblePrice);
        transferCollectible(_collectible.owner , msg.sender , _collectibleId);
        
    }
    
    /*
    function sendEther(address payable _owner , uint amount) private {
        _owner.tranfer(amount);
    }
    */
    
    /*
    transfers the collectible from the owner to the new owner who bought
    parameters:
            address: _from  : the owner who hold the collectible
            address: _to    : the address for user who wants to buy the collectible.
    */
    function transferCollectible(address _from , address _to , uint _id) private{
        
        require( _to != address(0) , "tranfer not possible for zero address");
        //require(approval() == true , "Not approved by the owner");
        
        collectible memory _collectible = collectibles[_id];
        
        require(_collectible.owner == _from , "Not owned by the owner");
        
        _collectible.collectibleApprovals = address(0);
        _collectible.owner = _to;
        collectibles[_id] = _collectible;
        
    }
    
}