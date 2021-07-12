pragma solidity 0.8.1;

contract nftContract {
    
    uint private _id;
    
    struct nft {
        uint tokenId;
        string link;
        address payable owner;
        bool forSale;
        uint minPrice;
    }
    
    mapping(string => nft) public nfts;
    mapping(string => bool) nftExists;
    
    constructor(){
        _id = 0;
    }
    
    //This is to verify whether the collectible created is already present or not.
    function _exists(string memory _nftlink) internal {
        require(!nftExists[_nftlink] , "NFT already minted");
    }
    
    //mint a nft and put it on sale
    function mintNFtAndSell(string memory _nftlink, uint _minPrice) public payable returns(uint) {
        _exists(_nftlink);
        
        require(bytes(_nftlink).length !=0 , "link is invalid" );
        
        _id++;
        nfts[_nftlink] = nft(_id, _nftlink, payable(msg.sender), true, _minPrice);
        nftExists[_nftlink] = true;
        
        return _id;
        
    }
    
    //Mint nft and store in the wallet
    function mintNFT(string memory _nftlink) public returns(uint){
        _exists(_nftlink);
        
        require(bytes(_nftlink).length !=0 , "link is invalid" );
        
        _id++;
        nfts[_nftlink] = nft(_id, _nftlink, payable(msg.sender), false, 0);
        nftExists[_nftlink] = true;
        
        return _id;
    }
    
    
    function buyNFT(string memory _nftlink, uint _minPrice) public payable returns(uint) {
        require(nftExists[_nftlink] , "link doesnot exists in market place");
        //require() , "Require more than that to buy this nft");
        
        nft memory _nft = nfts[_nftlink];
        _nft.owner.transfer(_nft.minPrice);
        
        
        _nft.owner = payable(msg.sender);
        _nft.minPrice = _minPrice;
        nfts[_nftlink] = _nft;
        
        return _nft.tokenId;
    }
    
    /*
    function transferNFT(address _from , string memory _nftlink) private{
        
        require( _to != address(0) , "tranfer not possible for zero address");
        //require(approval() == true , "Not approved by the owner");
        
        nft memory _nft = nfts[_nftlink];
        
        require(_nft.owner == _from , "Not owned by the owner");
        
        _nft.owner = msg.sender;
        nfts[_nftlink] = _nft;
        
    }
    */
}