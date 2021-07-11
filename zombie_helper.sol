pragma solidity >=0.5.0 <0.6.0;

import "./artifact_factory.sol";

contract ArtifactHelper is ArtifactFactory {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _artifactId) {
    require(artifacts[_artifactId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _artifactId) external payable {
    require(msg.value == levelUpFee);
    artifacts[_artifactId].level = artifacts[_artifactId].level.add(1);
  }

  function changeName(uint _artifactId, string calldata _newName) external aboveLevel(2, _artifactId) onlyOwnerOf(_artifactId) {
    artifacts[_artifactId].name = _newName;
  }

  function changeDna(uint _artifactId, uint _newDna) external aboveLevel(20, _artifactId) onlyOwnerOf(_artifactId) {
    artifacts[_artifactId].dna = _newDna;
  }

  function getArtifactsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerArtifactCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < artifacts.length; i++) {
      if (artifactToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
