// SPDX-License-Identifier: MIT
// Creator: Chiru Labs

pragma solidity ^0.8.4;

import './extensions/ERC721ABurnable.sol';
import './extensions/ERC721AOwnersExplicit.sol';
import './extensions/ERC721APausable.sol';
import './extensions/ERC721AQueryable.sol';
import './extensions/access/roles/MinterRole.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract ERC721AMetanism is ERC721ABurnable, ERC721AOwnersExplicit, ERC721AQueryable, MinterRole {
    // To prevent bot attack, we record the last contract call block number.
    mapping(address => uint256) private _lastCallBlockNumber;
    uint256 private _antibotInterval;

    // If someone burns NFT in the middle of minting,
    // the tokenId will go wrong, so use the index instead of totalSupply().
    uint256 private _mintIndexForSale;

    uint256 private _mintLimitPerTx; // Maximum purchase nft per person per Tx
    uint256 private _mintLimitPerSale; // Maximum purchase nft per person per sale

    string private _tokenBaseURI;
    uint256 private _mintStartBlockNumber; // In blockchain, blocknumber is the standard of time.
    uint256 private _maxSaleAmount; // Maximum purchase volume of normal sale.
    uint256 private _mintPrice; // Could be 200 or 300.

    constructor(string memory name, string memory symbol) public ERC721A(name, symbol) {
        //init explicitly.
        _antibotInterval = 0;
        _mintLimitPerTx = 3;
        _mintLimitPerSale = 3;
        _tokenBaseURI = 'https://nft.metanism.ai/metadata/';
        _mintStartBlockNumber = 87338309;
        _maxSaleAmount = 1000;
        _mintPrice = 1e18; // 1 Klay
    }

    // 11am 1649212800
    // 3pm 1649224800
    function withdraw() external onlyMinter {
        payable(msg.sender).transfer(address(this).balance);
    }

    function mintingInformation() external view returns (uint256[7] memory) {
        uint256[7] memory info = [
            _antibotInterval,
            _mintIndexForSale,
            _mintLimitPerTx,
            _mintLimitPerSale,
            _mintStartBlockNumber,
            _maxSaleAmount,
            _mintPrice
        ];
        return info;
    }

    function mintMetanism(uint256 requestedCount) external payable {
        require(_lastCallBlockNumber[msg.sender] + _antibotInterval < block.number, 'Bot is not allowed');
        require(block.number >= _mintStartBlockNumber, 'Not yet started');
        require(requestedCount > 0 && requestedCount <= _mintLimitPerTx, 'Too many requests or zero request');
        require(msg.value == _mintPrice * requestedCount, 'Not enough Klay');
        require(_mintIndexForSale + requestedCount <= _maxSaleAmount, 'Exceed max amount');
        require(balanceOf(msg.sender) + requestedCount <= _mintLimitPerSale, 'Exceed max amount per person');

        _mint(msg.sender, requestedCount);
        _mintIndexForSale = _mintIndexForSale + requestedCount;

        _lastCallBlockNumber[msg.sender] = block.number;
    }

    function setupSale(
        uint256 newAntibotInterval,
        uint256 newMintLimitPerTx,
        uint256 newMintLimitPerSale,
        string calldata newTokenBaseURI,
        uint256 newMintStartBlockNumber,
        uint256 newMaxSaleAmount,
        uint256 newMintPrice
    ) external onlyMinter {
        _antibotInterval = newAntibotInterval;
        _mintLimitPerTx = newMintLimitPerTx;
        _mintLimitPerSale = newMintLimitPerSale;
        _tokenBaseURI = newTokenBaseURI;
        _mintStartBlockNumber = newMintStartBlockNumber;
        _maxSaleAmount = newMaxSaleAmount;
        _mintPrice = newMintPrice;
    }
}
