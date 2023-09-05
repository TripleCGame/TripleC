// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../interface/IMedal.sol";
import "../../library/EIP712.sol";
import "../../library/ECDSA.sol";

contract TriplecMedal is
    EIP712,
    Pausable,
    ITriplecMedal,
    ERC721Enumerable,
    Ownable
{
    using Strings for uint256;

    bool private initialized;
    address public signer;
    string private baseURI;
    uint256 private _tokenId;

    mapping(uint256 => Pinfo) public pinfos;
    mapping(uint256 => bool) private isClaimed;

    event TriplecMedalMint(
        address indexed account,
        uint256 indexed tokenId,
        Pinfo pinfo
    );

    event URIPrefix(string indexed baseURI);

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721Enumerable, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function initialize(address _owner) external {
        require(!initialized, "initialize: Already initialized!");
        _transferOwnership(_owner);
        eip712Initialize("TripleC", "1.0.0");
        initialized = true;
    }

    function claimHash(
        uint256 _pid,
        uint256 _dummyId,
        uint256 _level,
        address _to,
        bool _canTranster
    ) internal view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "Claim(uint256 pid,uint256 dummyId,uint256 level,address mintTo,bool canTransfer)"
                        ),
                        _pid,
                        _dummyId,
                        _level,
                        _to,
                        _canTranster
                    )
                )
            );
    }

    function verifySignature(
        bytes32 hash,
        bytes calldata signature
    ) internal view returns (bool) {
        return ECDSA.recover(hash, signature) == signer;
    }

    function setSinger(address _signer) external onlyOwner {
        signer = _signer;
    }

    function claim(
        uint256 _pid,
        uint256 _dummyId,
        uint256 _level,
        address _to,
        bool _canTranster,
        bytes calldata _signature) external returns(uint256){
        require(!isClaimed[_dummyId], "Already Claimed!");
        require(verifySignature(
            claimHash(
                _pid,
                _dummyId,
                _level,
                _to,
                _canTranster
        ), _signature),"Invalid signature!");
        isClaimed[_dummyId] = true;
        Pinfo memory pinfo = Pinfo(_pid,_level,_to,_canTranster);
        return mintNft(_to, pinfo);
    }

    function mint(
        address to,
        Pinfo calldata pinfo
    ) external override onlyOwner returns (uint256) {
       return mintNft(to, pinfo);
    }

    function mintNft(address to,Pinfo memory pinfo) private returns (uint256){
        _tokenId++;
        pinfos[_tokenId] = pinfo;
        _mint(to, _tokenId);
        emit TriplecMedalMint(to, _tokenId, pinfo);
        return _tokenId;
    }

    function burn(uint256 _id) external onlyOwner {
        _burn(_id);
        delete pinfos[_id];
    }

    function getPinfo(
        uint256 tokenId
    ) external view override returns (Pinfo memory pinfo) {
        require(_exists(tokenId), "TriplecMedal: nonexistent token");
        pinfo = pinfos[tokenId];
    }

    function pause() external onlyOwner {
        super._pause();
    }

    function unpause() external onlyOwner {
        super._unpause();
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if (paused()) {
            require(false, "pause transfer");
        } else {
            Pinfo memory pinfo = pinfos[tokenId];
            require(pinfo.canTranster, "only for owner");
        }
        super._transfer(from, to, tokenId);
    }

    function updateURIPrefix(string memory baseURI_) external onlyOwner {
        baseURI = baseURI_;
        emit URIPrefix(baseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            _exists(tokenId),
            "TriplecMedal: URI query for nonexistent token"
        );
        string memory baseURI_ = _baseURI();
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(baseURI_, tokenId.toString()));
    }

    function name() public view virtual override returns (string memory) {
        return "MEDAL.TripleC";
    }

    function symbol() public view virtual override returns (string memory) {
        return "MEDAL";
    }
}

