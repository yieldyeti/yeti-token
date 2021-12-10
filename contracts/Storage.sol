//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Storage {
  string ipfsHash;

  struct Ipfs {
    string _ipfsHash;
  }

  event createIpfsHash (
    string ipfsHash
  );

  Ipfs[] public IpfsHash;

  function add(string memory _ipfsHash) public {
    ipfsHash = _ipfsHash;
    IpfsHash.push(Ipfs(ipfsHash));
    emit createIpfsHash(ipfsHash);
  }

  function get() public view returns (string memory) {
    return ipfsHash;
  }

  function size() public view returns (uint) {
    return IpfsHash.length;
  }
}