![RobustCoin](logo.png "RobustCoin")

# Robust Coin smart contract

* _Standart_        : ERC20
* _Name_            : RobustCoin
* _Ticket_          : RIC
* _Decimals_        : 18
* _Emission_        : Mintable
* _Crowdsales_      : 2
* _Fiat dependency_ : No
* _Tokens locked_   : Yes

## Smart-contracts description

Contract mint bounty and founders tokens after main sale stage finished. 
Crowdsale contracts have special function to retrieve transferred in errors tokens.
Also crowdsale contracts have special function to direct mint tokens in wei value (featue implemneted to support external pay gateway).

### Contracts contains
1. _RobustCoin_ - Token contract
2. _Presale_ - Presale contract
3. _Mainsale_ - ICO contract
4. _Configurator_ - contract with main configuration for production
4. _BountyWallet_ - wallet for freeze bounty tokens

### How to manage contract
To start working with contract you should follow next steps:
1. Compile it in Remix with enamble optimization flag and compiler 0.4.18
2. Deploy bytecode with MyEtherWallet. Gas 5100000 (actually 5073514).
3. Call 'deploy' function on addres from (3). Gas 4000000 (actually 3979551). 

Contract manager must call finishMinting after each crowdsale milestone!
To support external mint service manager should specify address by calling _setDirectMintAgent_. After that specified address can direct mint RIC tokens by calling _mintTokensByETHExternal_ and _mintTokensExternal_.

### How to invest
To purchase tokens investor should send ETH (more than minimum 0.1 ETH) to corresponding crowdsale contract.
Recommended GAS: 250000, GAS PRICE - 21 Gwei.

### Wallets with ERC20 support
1. MyEtherWallet - https://www.myetherwallet.com/
2. Parity 
3. Mist/Ethereum wallet

EXODUS not support ERC20, but have way to export key into MyEtherWallet - http://support.exodus.io/article/128-how-do-i-receive-unsupported-erc20-tokens

Investor must not use other wallets, coinmarkets or stocks. Can lose money.

## Main network configuration

* _Minimal insvested limit_     : 0.1 ETH
* _Bounty tokens percent_       : 5% 
* _Founders tokens percent_     : 10% 
* _For sale tokens percent_     : 85% 
* _Founders tokens wallet_      : 0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5
* _Bounty tokens wallet_        : 0x28732f6dc12606D529a020b9ac04C9d6f881D3c5
* _Contract owner_              : 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766

### Links
1. _Token_ -
2. _Presale_ -
3. _Mainsale_ -
3. _BountyWallet_ -

### Crowdsale stages

#### Features
Tokens can manually mint at any time untill ICO finished.

#### Bounty freeze wallet
* 30% tokens unlocked after 01 Dec 2018 00:00:00 GMT
* 70% tokens unlocked after 01 Sep 2019 00:00:00 GMT

#### Presale
* _Price_                      : 1 ETH = 6667 Tokens
* _Softcap_                    : 1000 ETH
* _Hardcap_                    : 11 250 ETH
* _Period_                     : 7 days
* _Start_                      : 12 Feb 2018 00:00:00 GMT
* _Wallet_                     : 0xa86780383E35De330918D8e4195D671140A60A74

#### ICO
* _Price_                      : 1 ETH = 5000 Tokens
* _Hardcap_                    : 47 500 ETH
* _Start_                      : 10 Mar 2018 00:00:00 GMT
* _Wallet_                     : 0x98882D176234AEb736bbBDB173a8D24794A3b085

_Milestones_
1. 6 days                      : bonus +10% 
2. 6 days                      : bonus +9% 
3. 6 days                      : bonus +8%
3. 6 days                      : bonus +7% 
3. 6 days                      : bonus +6% 
3. 6 days                      : bonus +5% 
3. 6 days                      : bonus +4% 
3. 6 days                      : bonus +3% 
3. 6 days                      : bonus +2% 
3. 3 days                      : bonus +1% 
4. 3 days                      : without bonus

