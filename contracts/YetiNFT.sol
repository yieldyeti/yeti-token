//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./@rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol";
import "./@rarible/royalties/contracts/LibPart.sol";
import "./@rarible/royalties/contracts/LibRoyaltiesV2.sol";

contract YetiNFT is ERC721Enumerable, Ownable, RoyaltiesV2Impl {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    struct details {
        string tokenSymbol;
        string tokenURL;
        string tokenAttributes;
        uint256 tokenPrice;
    }

    mapping(uint256 => details) private _properties;

    constructor() ERC721("YetiNFT", "YNFT") {}

    function getTokenProperties(uint256 tokenId)
        public
        view
        returns (details memory)
    {
        require(
            super._exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );

        return _properties[tokenId];
    }

    function _setProperties(
        uint256 tokenId,
        string memory tokenURI,
        string memory tokenSYM,
        string memory tokenAttributes,
        uint256 tokenPrice
    ) private {
        require(
            super._exists(tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        details memory detail = details(
            tokenSYM,
            tokenURI,
            tokenAttributes,
            tokenPrice
        );
        _properties[tokenId] = detail;
    }

    function mint(
        string memory tokenURI,
        string memory tokenSYM,
        string memory tokenAttributes,
        uint256 tokenPrice,
        uint96 _percentagePoints
    ) public onlyOwner {
        uint256 newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _setProperties(
            newTokenID,
            tokenURI,
            tokenSYM,
            tokenAttributes,
            tokenPrice
        );
        if (_percentagePoints != 0) {
            address payable royaltyowner = payable(address(msg.sender));
            _percentagePoints = _percentagePoints * 100;
            setRoyalties(newTokenID, royaltyowner, _percentagePoints);
        }
        _tokenIds.increment();
    }

    function setRoyalties(
        uint256 _tokenId,
        address payable _royaltiesReceipientAddress,
        uint96 _percentageBasisPoints
    ) private {
        LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = _percentageBasisPoints;
        _royalties[0].account = _royaltiesReceipientAddress;
        _saveRoyalties(_tokenId, _royalties);
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        LibPart.Part[] memory _royalties = royalties[_tokenId];
        if (_royalties.length > 0) {
            return (
                _royalties[0].account,
                (_salePrice * _royalties[0].value) / 10000
            );
        }
        return (address(0), 0);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
            return true;
        }
        if (interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    }

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function withdraw() public payable onlyOwner {
        Address.sendValue(payable(address(msg.sender)), address(this).balance);
    }
}
