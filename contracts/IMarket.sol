// SPDX-License-Identifier: MIT 

pragma solidity >=0.7.0 <0.9.0;

interface IMarket {
    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external payable returns (uint256);

    function createMarketSale(address nftContract, uint256 itemId) external;

    function fetchMarketItems() external view returns (MarketItem[] memory);

    function fetchUnsoldMarketItems() external view returns (MarketItem[] memory);

    function fetchMyNFTs() external view returns (MarketItem[] memory);

    function fetchItemsCreated() external view returns (MarketItem[] memory);
}