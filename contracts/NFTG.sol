// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import 'hardhat/console.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import './IMarket.sol';

contract NFTG is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  address contractAddress;

  constructor(string memory _name, string memory _symbol, address marketplaceAddress) ERC721(_name, _symbol) {
    contractAddress = marketplaceAddress;
  }

  event MarketItemCreated(
    uint256 indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

  // public
  function createToken(string memory tokenURI, uint256 price) public  returns (uint256) {
    //validating listing price
    require(price > 0, 'Price must be at least 1 wei');

    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();

    _mint(msg.sender, newItemId);
    _setTokenURI(newItemId, tokenURI);
    setApprovalForAll(contractAddress, true);
    transferFrom(msg.sender, contractAddress, newItemId);

    uint256 marketList = IMarket(contractAddress).createMarketItem(address(this), newItemId, price);

    emit MarketItemCreated(marketList, address(this), newItemId, msg.sender, address(0), price, false);

    return newItemId;
  }
}
