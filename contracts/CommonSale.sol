pragma solidity ^0.4.18;

import "./math/SafeMath.sol";
import "./MintableToken.sol";
import "./PercentRateProvider.sol";
import "./RetrieveTokensFeature.sol";
import "./RomadDefenseToken.sol";
import "./StagedCrowdsale.sol";
import "./WalletProvider.sol";

contract CommonSale is StagedCrowdsale, WalletProvider, PercentRateProvider, RetrieveTokensFeature {

  using SafeMath for uint;

  RomadDefenseToken public token;
  address public directMintAgent;
  uint public minInvestedLimit;
  uint public price;
  uint public start;
  uint public weiRaised;
  uint public weiApproved;
  bool public KYCAutoApprove = false;
  uint public USDPrice; // usd per token
  uint public ETHtoUSD; // usd per eth
  mapping(address => bool) public approvedCustomers;
  mapping(address => uint) public balances;

  modifier onlyDirectMintAgentOrOwner() {
    require(directMintAgent == msg.sender || owner == msg.sender);
    _;
  }

  modifier minInvestLimited(uint value) {
    require(value >= minInvestedLimit);
    _;
  }

  function setStart(uint newStart) public onlyOwner {
    start = newStart;
  }

  function endSaleDate() public view returns(uint) {
    return lastSaleDate(start);
  }

  function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
    minInvestedLimit = newMinInvestedLimit;
  }

  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
    directMintAgent = newDirectMintAgent;
  }

  function setPrice(uint newPrice) public onlyOwner {
    price = newPrice;
  }

  function setToken(address newToken) public onlyOwner {
    token = RomadDefenseToken(newToken);
  }

  function calculateTokens(uint _invested) internal returns(uint) {
    uint milestoneIndex = currentMilestone(start);
    Milestone storage milestone = milestones[milestoneIndex];
    require(_invested >= milestone.minInvestedLimit);
    uint tokens = _invested.mul(price).div(1 ether);
    if (milestone.bonus > 0) {
      tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
    }
    return tokens;
  }

  function mintTokens(address to, uint tokens) internal {
    token.mint(this, tokens);
    token.transfer(to, tokens);
  }

  function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
    mintTokens(to, tokens);
  }

  function mintTokensByETH(address to, uint invested) internal returns(uint) {
    weiRaised = weiRaised.add(invested);
    balances[to] = balances[to].add(invested);
    if (approvedCustomers[to]) {
      weiApproved = weiApproved.add(invested);
    } else if (KYCAutoApprove) {
      approveCustomer(to);
    } else {
      token.addToKYCPending(to);
    }
    uint tokens = calculateTokens(invested);
    mintTokens(to, tokens);
    return tokens;
  }

  function mintTokensByETHExternal(address to, uint invested) public onlyDirectMintAgentOrOwner returns(uint) {
    return mintTokensByETH(to, invested);
  }

  // --------------------------------------------------------------------------
  // KYC
  // --------------------------------------------------------------------------

  function switchKYCAutoApprove() public onlyOwner {
    KYCAutoApprove = !KYCAutoApprove;
  }

  function approveCustomer(address customer) public onlyOwner {
    require(!approvedCustomers[customer]);
    weiApproved = weiApproved.add(balances[customer]);
    approvedCustomers[customer] = true;
    token.removeFromKYCPending(customer);
  }

  function refund() public {
    require(!approvedCustomers[msg.sender] && balances[msg.sender] > 0);
    uint value = balances[msg.sender];
    balances[msg.sender] = 0;
    token.burnKYCPendingTokens(msg.sender);
    token.removeFromKYCPending(msg.sender);
    msg.sender.transfer(value);
  }

  // --------------------------------------------------------------------------
  // USD conversion
  // --------------------------------------------------------------------------

  function setUSDPrice(uint _USDPrice) public onlyOwner {
    USDPrice = _USDPrice;
  }

  function updatePrice() internal {
    price = ETHtoUSD.mul(1 ether).div(USDPrice);
  }

  function setETHtoUSD(uint _ETHtoUSD) public onlyOwner {
    ETHtoUSD = _ETHtoUSD;
    updatePrice();
  }

  // --------------------------------------------------------------------------
  // fallback
  // --------------------------------------------------------------------------

  function fallback() internal minInvestLimited(msg.value) returns(uint) {
    require(now >= start && now < endSaleDate());
    return mintTokensByETH(msg.sender, msg.value);
  }

  function () public payable {
    fallback();
  }

}

