pragma solidity ^0.4.13;

//Contract is meant to be used in calculations of hashes for blind auction contracts.
//It accepts integer, boolean and string in this particular order and packages them interaction
//sha3() function that is native to solidity.

//This version is tweaked as a workaround for Solidity 0.4.13 not supporting strings in structures.

contract sha3HashCalculatorIntBoolString{
  struct result{
    int integer;
    bool boolean;
    //string characters;
    bytes32 hashingresult;
  }
  uint256 public latestHashingOperationIdentifier;
  mapping(uint256 => result[]) public hashing;
  mapping(uint256 => string) public charactersOfHashing;

  function sha3HashCalculatorIntBoolString(uint256 startingIdentifier){
    latestHashingOperationIdentifier = startingIdentifier;
  }

  function hashIt(int _integer, bool _boolean, string _characters){
    latestHashingOperationIdentifier += 1;
    hashing[latestHashingOperationIdentifier].push(result({
      integer: _integer,
      boolean: _boolean,
      //characters: _characters,
      hashingresult: sha3(_integer, _boolean, _characters)
    }));
    charactersOfHashing[latestHashingOperationIdentifier] = _characters;
  }
}
