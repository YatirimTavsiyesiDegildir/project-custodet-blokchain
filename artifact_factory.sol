pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

contract ArtifactFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewArtifact(uint artifactId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Artifact {
    string name;
    uint dna;
    uint32 level;
  }

  Artifact[] public artifacts;

  mapping (uint => address) public artifactToOwner;
  mapping (address => uint) ownerArtifactCount;

  modifier ownerOf(uint _artifactId) {
    require(msg.sender == artifactToOwner[_artifactId]);
    _;
  }

  function _createArtifact(string memory _name, uint _dna) internal {
    uint id = artifacts.push(Artifact(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    artifactToOwner[id] = msg.sender;
    ownerArtifactCount[msg.sender] = ownerArtifactCount[msg.sender].add(1);
    emit NewArtifact(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomArtifact(string memory _name) public {
    require(ownerArtifactCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createArtifact(_name, randDna);
  }

}
