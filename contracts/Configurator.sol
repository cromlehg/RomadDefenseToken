pragma solidity ^0.4.18;

import './ownership/Ownable.sol';
import './MintableToken.sol';
import './RomadDefenseToken.sol';
import './PreICO.sol';
import './ICO.sol';
import './DoubleStageFreezeTokensWallet.sol';

contract Configurator is Ownable {

  MintableToken public token;

  PreICO public preICO;

  ICO public ico;

  DoubleStageFreezeTokensWallet public teamTokensWallet;
  DoubleStageFreezeTokensWallet public earlyInvestorsTokensWallet;

  function deploy() public onlyOwner {

    token = new RomadDefenseToken();

    preICO = new PreICO();

    preICO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
    preICO.setStart(1527440400); // 27 May 2018 17:00:00 GMT
    preICO.addMilestone(1, 20, 10000000000000000000); // 1 day, 20% bonus, 10 ETH min
    preICO.addMilestone(2, 18, 5000000000000000000); // 2 days, 20% bonus, 5 ETH min
    preICO.addMilestone(4, 16, 1000000000000000000); // 4 days 16%, 1 ETH min
    preICO.addMilestone(3, 15, 0);
    preICO.addMilestone(3, 14, 0);
    preICO.addMilestone(3, 13, 0);
    preICO.addMilestone(3, 12, 0);
    preICO.addMilestone(3, 11, 0);
    preICO.setUSDPrice(200); // 0.2 USD
    preICO.setUSDSoftcap(5000000000); //  5 000 000 USD
    preICO.setETHtoUSD(67508); // 675.08 USD per ETH
    preICO.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    preICO.setToken(token);

    token.setSaleAgent(preICO);

    ico = new ICO();

    ico.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
    ico.setStart(1529798400); // Jun 24 2018 00:00:00 GMT
    ico.addMilestone(6, 10, 0);
    ico.addMilestone(6, 9, 0);
    ico.addMilestone(6, 8, 0);
    ico.addMilestone(6, 7, 0);
    ico.addMilestone(6, 6, 0);
    ico.addMilestone(6, 5, 0);
    ico.addMilestone(6, 4, 0);
    ico.addMilestone(6, 3, 0);
    ico.addMilestone(6, 2, 0);
    ico.addMilestone(3, 1, 0);
    ico.addMilestone(3, 0, 0);
    ico.setUSDPrice(200); // 0.2 USD
    ico.setUSDHardcap(28000000000); // 28 000 000 USD
    ico.setETHtoUSD(67508); // 675.08 USD per ETH
    ico.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
    ico.setBountyTokensPercent(5);
    ico.setTeamTokensPercent(15);
    ico.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    ico.setToken(token);

    teamTokensWallet = new DoubleStageFreezeTokensWallet();
    teamTokensWallet.setMasterPercent(30);
    teamTokensWallet.setWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
    teamTokensWallet.setToken(token);
    teamTokensWallet.setFirstDate(1543622400); // 01 Dec 2018 00:00:00 GMT
    teamTokensWallet.setSecondDate(1567296000); // 01 Sep 2019 00:00:00 GMT
    teamTokensWallet.activate();

    earlyInvestorsTokensWallet = new DoubleStageFreezeTokensWallet();
    earlyInvestorsTokensWallet.setMasterPercent(50);
    earlyInvestorsTokensWallet.setWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
    earlyInvestorsTokensWallet.setToken(token);
    earlyInvestorsTokensWallet.setFirstDate(1543622400); // 01 Dec 2018 00:00:00 GMT
    earlyInvestorsTokensWallet.setSecondDate(1567296000); // 01 Sep 2019 00:00:00 GMT
    earlyInvestorsTokensWallet.activate();

    ico.setTeamTokensWallet(teamTokensWallet);
    ico.setEarlyInvestorsTokensWallet(earlyInvestorsTokensWallet);

    preICO.setNextSaleAgent(ico);

    address manager = 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766;

    teamTokensWallet.transferOwnership(manager);
    token.transferOwnership(manager);
    preICO.transferOwnership(manager);
    ico.transferOwnership(manager);
  }

}
