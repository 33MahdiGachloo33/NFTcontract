// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//import erc1155 from openzeppelin
import"@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import"@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721Enumerable, Ownable{

    uint256 public constant MAX_SUPPLY = 100;
    //here is our max supply

    struct SaleConfig{
        bool saleStatus; // is false
        uint256 mintPrice;
    }

    SaleConfig public saleConfig;
    //and for accessing it we can use for example saleConfig.mintPrice

    constructor() ERC721("NFT Collection", "NFTC"){
        //first para is name and the second is symbol
        saleConfig.mintPrice = 0.1 ether;
    }

    function setSaleStatus(bool _saleStatus)public onlyOwner{
        saleConfig.saleStatus = _saleStatus;
    }
    function setMintPrice(uint256 _mintPrice)public onlyOwner{
        saleConfig.mintPrice = _mintPrice;
        //the uint is wei
        //we can use unit converter
    }
    //now mint function that run by user
    function Mint(uint256 _amount) public payable{
        //_amount is number of minting
        require(saleConfig.saleStatus, "sale is deactive");
        //it means saleConfig.saleStatus is true
        require(totalSupply() < MAX_SUPPLY, "Sold Out");
        //totalSupply is the function in ERC721 that counts the mintings
        require(totalSupply() + _amount <= MAX_SUPPLY, "Please try to mint lower amount");
        require(msg.value >= Price(_amount), "value that you want is wrong!!");

        //this is for minting
        for(uint256 i = 1; i<= _amount; i++){
            uint256 _id =totalSupply();
            _safeMint(msg.sender, _id);
             //if we want mint one NFT :
        // _safeMint(msg.sender,totalSupply());
        }

        refund(Price(_amount));
    }
        function refund(uint256 _price) private{
            if(msg.value >_price){
                payable(msg.sender).transfer(msg.value - _price);
            }
        }


    //function that show us mint price with the amount that we want
    function Price(uint256 _amount) public view returns(uint256){
        return _amount * saleConfig.mintPrice; 
    }

    function withdraw()public onlyOwner{
         payable(msg.sender).transfer(address(this).balance);
                                     //this is amount that we want transfer

    }
}