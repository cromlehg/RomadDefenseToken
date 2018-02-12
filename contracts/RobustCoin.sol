pragma solidity ^0.4.18;

import './MintableToken.sol';

contract RobustCoin is MintableToken {

  string public constant name = "RobustCoin";

  string public constant symbol = "RIC";

  uint32 public constant decimals = 18;

}
