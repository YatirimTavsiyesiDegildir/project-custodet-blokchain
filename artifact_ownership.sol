pragma solidity >=0.5.0 <0.6.0;

import "./artifact_helper.sol";
import "./erc721.sol";
import "./safemath.sol";

/// TODO: Replace this with natspec descriptions
contract ArtifactOwnership is ArtifactHelper, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) artifactApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerArtifactCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return artifactToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerArtifactCount[_to] = ownerArtifactCount[_to].add(1);
    ownerArtifactCount[msg.sender] = ownerArtifactCount[msg.sender].sub(1);
    artifactToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (artifactToOwner[_tokenId] == msg.sender || artifactApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    artifactApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
