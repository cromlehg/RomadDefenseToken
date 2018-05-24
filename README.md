![SafetyCoin](logo.png "SafetyCoin")

# RomadDefenseToken smart contract

* _Standart_        : ERC20
* _Name_            : ROMAD Defense token
* _Ticket_          : RDT
* _Decimals_        : 0
* _Emission_        : Mintable
* _Crowdsales_      : 2
* _Fiat dependency_ : No
* _Tokens locked_   : Yes

## Summary percentage distribution of tokens by all stages

* _Team_ - 15%
* _Bounty_ - 5%
* _For sale_ - 80%

## Smart-contracts description

The tokens for the bounty and the team are minted after the ICO  is finished.  
There is a special function to return 3rd party tokens that were sent by mistake (function retrieveTokens()).  
Each stage has a direct minting function in wei. This is made to support the external payment gateways.

### Contracts contain
1. _RomadDefenseToken_ - Token contract
2. _PreICO_ - PreICO contract
3. _ICO_ - ICO contract
4. _TeamWallet_ - wallet for freeze team tokens
5. _EarlyInvestorsWallet_ - wallet for freeze early investors tokens
6. _Configurator_ - contract with main configuration for production

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

* _Minimal insvested limit_         : 0.1 ETH
* _Team tokens percent_             : 10%
* _Advisors tokens percent_         : 5%
* _Bounty tokens percent_           : 5%
* _Early investors tokens percent_  : 5%
* _For sale tokens percent_         : 75%
* _Team tokens wallet_              : 0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5
* _Advisors tokens wallet_          : 0xE7260D4c2a6539910d47F91c9060B4269dF2bD45
* _Bounty tokens wallet_            : 0x28732f6dc12606D529a020b9ac04C9d6f881D3c5
* _Early investors tokens wallet_   : 0xf3Eafc283C0fFa5C60206bd65D9753474c1aE48a
* _Contract owner_                  : 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766

### Links
1. _Token_ -
2. _PreICO_ -
3. _ICO_ -
3. _TeamWallet_ -

### Crowdsale stages

#### Features
Tokens can manually mint at any time untill ICO finished.

#### Team freeze wallet
* 30% tokens unlocked after 01 Dec 2018 00:00:00 GMT
* 70% tokens unlocked after 01 Sep 2019 00:00:00 GMT

#### Early investors freeze wallet
* 50% tokens unlocked after 01 Dec 2018 00:00:00 GMT
* 50% tokens unlocked after 01 Sep 2019 00:00:00 GMT

#### PreICO
* _Price_                       : 1 RDT = 0.2 USD
* _Softcap_                     : 5 000 000 USD
* _Period_                      : 21 days
* _Start_                       : 27 May 2018 17:00:00 GMT
* _Wallet_                      : 0xa86780383E35De330918D8e4195D671140A60A74

_Milestones_
1. 1 day                        : bonus +20%, 10 ETH min 
2. 2 days                       : bonus +18%, 5 ETH min 
3. 4 days                       : bonus +16%, 1 ETH min 
4. 3 days                       : bonus +15%, 0.1 ETH min 
5. 3 days                       : bonus +14%, 0.1 ETH min 
6. 3 days                       : bonus +13%, 0.1 ETH min 
7. 3 days                       : bonus +12%, 0.1 ETH min 
8. 3 days                       : bonus +11%, 0.1 ETH min 

#### ICO
* _Price_                       : 1 RDT = 0.2 USD
* _Hardcap_                     : 28 000 000 USD
* _Start_                       : Jun 24 2018 17:00:00 GMT
* _Wallet_                      : 0x98882D176234AEb736bbBDB173a8D24794A3b085

_Milestones_
1. 6 days                       : bonus +10% 
2. 6 days                       : bonus +9% 
3. 6 days                       : bonus +8%
4. 6 days                       : bonus +7% 
5. 6 days                       : bonus +6% 
6. 6 days                       : bonus +5% 
7. 6 days                       : bonus +4% 
8. 6 days                       : bonus +3% 
9. 6 days                       : bonus +2% 
10. 6 days                      : bonus +1% 
11. 6 days                      : without bonus

## Ropsten network configuration #1

### links
1. _Token_ - https://ropsten.etherscan.io/address/0x862d5e57a1d803c1bccd8c5ca5b95212f5771f66
2. _Presale_ - https://ropsten.etherscan.io/address/0xee8f3a40522a6663f85c2428398ef047b8b30426
3. _Mainsale_ - https://ropsten.etherscan.io/address/0x9809325488deadf5cf8984de45a662c7919f6d97
4. _BountyWallet_ - https://ropsten.etherscan.io/address/0x66c8172e5f8004fe70bb933d74c3f4c3d0e2d207


### Crowdsale stages

#### Presale

* _Price_                       : 1 ETH = 6667 Tokens
* _Minimal investment limit_    : 0.1 ETH
* _Softcap_                     : 3 ETH
* _Hardcap_                     : 11 250 ETH
* _Period_                      : 7 days
* _Wallet_                      : 0x8fd94be56237ea9d854b23b78615775121dd1e82
* _Developer wallet_            : 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770
* _Developer limit_             : 0.045 ETH

##### Purchasers

* 3.3 ETH => 22001.1 tokens, gas = 148207
https://ropsten.etherscan.io/tx/0x14033dfd3bfe23edcf1aa136a2b28e13307e3b0c47d1da30a904f14b34f29858

* 0.01 ETH => rejected txn, less then mininal investment limit, gas = 21297
https://ropsten.etherscan.io/tx/0xed3eb6df1e6a1818652a2fbbc00c91ce721b611f7f66e5ed94698600fe97efaa

* 0.01 ETH => 666.7 tokens, gas = 67570
https://ropsten.etherscan.io/tx/0x4a1b2e3887839b962277864210b11f8001fc48b547e607012ee7a7156849345d

* 1 ETH => rejected txn, end of Presale, gas = 22102
https://ropsten.etherscan.io/tx/0x75bcd1e57a0f37a60c754a485c6eda09ba38a60ea9a16c628c07395aba45dfe1

##### Service operations

* setStart, gas = 27824
https://ropsten.etherscan.io/tx/0xa3a512d2a4e028c4e59928833a06dfef811e5d47b1dab989f6d0bce90d390567

* finish, gas = 47133
https://ropsten.etherscan.io/tx/0xed4bc1bdbdaa8afa575a944e5c9c80f925d353fb03aa2be9f3e5668dc8c495ab

#### Mainsale

* _Price_                       : 1 ETH = 5000 Tokens
* _Minimal investment limit_    : 0.1 ETH
* _Hardcap_                     : 47 500 ETH
* _Wallet_                      : 0x8fd94be56237ea9d854b23b78615775121dd1e82
* _Bounty tokens percent_       : 5% 
* _Founders tokens percent_     : 10% 
* _For sale tokens percent_     : 85% 
* _Founders tokens wallet_      : 0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5
* _Bounty tokens wallet_        : 0x8fd94be56237ea9d854b23b78615775121dd1e82

_Bounty freeze wallet_

* 30% tokens unlocked after 12 Feb 2018 00:00:00 GMT
* 70% tokens unlocked after 01 Sep 2019 00:00:00 GMT

_Milestones_

1. 6 days                       : bonus +10% 
2. 6 days                       : bonus +9% 
3. 6 days                       : bonus +8%
4. 6 days                       : bonus +7% 
5. 6 days                       : bonus +6% 
6. 6 days                       : bonus +5% 
7. 6 days                       : bonus +4% 
8. 6 days                       : bonus +3% 
9. 6 days                       : bonus +2% 
10. 3 days                       : bonus +1% 
11. 3 days                       : without bonus

##### Purchasers
  
* 2 ETH => rejected txn, it is not Start yet, gas = 21548
https://ropsten.etherscan.io/tx/0xfd9bd509edcaf7f69c02c99f46e0c536c878daadebbef9c314788aa7df59f595

* 2 ETH =>  10000 tokens + 1000 bonus tokens(10%), gas = 86826
https://ropsten.etherscan.io/tx/0x1feef2399654ed00a52cebf66d63f554f9f4d4464a1e80e731f8c4ed6a59fd0c

##### Service operations

* setStart, gas = 27912
https://ropsten.etherscan.io/tx/0xa22aee57db5c8ac340b01510b5dc7edb4c7b4d53bcfb1f8b09ecd2c30496cce5

* finish, gas = 131119
https://ropsten.etherscan.io/tx/0xb35ddad79657852a1cdf027f938ea7b1085b1389d18aa21181412631e5368278

* setWallet, gas = 28880
https://ropsten.etherscan.io/tx/0xc211a8b8881c2498690b4972930bbf599a9652bc0429ef4fc85d07e63b202907

* withdraw from bounty wallet, gas = 42637
https://ropsten.etherscan.io/tx/0x15079de0013cf36855f7d1e0180c48adf000eb4114501443c09d34e03e6bb1f9

##### Token holders
https://ropsten.etherscan.io/token/0x862d5e57a1d803c1bccd8c5ca5b95212f5771f66


## Ropsten network configuration #2

### links
1. _Token_ - https://ropsten.etherscan.io/address/0xf4ccc1a01689d336af59ba96a9ba83c5bf6cdc3e
2. _Presale_ - https://ropsten.etherscan.io/address/0x3149e96f4146c55a4bb1fce8d1d5d5ffb97ed432
3. _Mainsale_ - https://ropsten.etherscan.io/address/0x2e44ada0dbf3b7ed7dc3b860c61abe10907b5bef
4. _teamTokensWallet_ - https://ropsten.etherscan.io/address/0x463124766f0bfa4a6afaa2994df3518b31fafd3e
5. _earlyInvestorsTokensWallet_ - https://ropsten.etherscan.io/address/0x4628e2f0ebf0e4ff613a39fa306a3908838a6f70

### Crowdsale stages

#### Presale

* _USD Price_                   : 0.2 USD
* _Minimal investment limit_    : 0.1 ETH
* _USD Softcap_                 : 500 USD
* _ETH to USD_                  : 675.08 USD per ETH
* _Wallet_                      : 0x8fd94be56237ea9d854b23b78615775121dd1e82
* _Developer wallet_            : 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770
* _Developer limit_             : 0.0195 ETH

_Milestones_

1. 1 day, 20% bonus, 1 ETH min
2. 2 days, 18% bonus, 0.5 ETH min
3. 4 days 16%, 0.1 ETH min
4. 3 days 15%, 0.1 ETH min
5. 3 days 14%, 0.1 ETH min
6. 3 days 13%, 0.1 ETH min
7. 3 days 12%, 0.1 ETH min
8. 3 days 11%, 0.1 ETH min

##### Purchasers

* 1 ETH => 4050.48 tokens, gas = 153690
https://ropsten.etherscan.io/tx/0x33a8c609b8a0dba34af905ca9cd9e2b196282322f2e5953fadcbeecafe5572a7

* 0.5 ETH => rejected txn, less then mininal investment limit, gas = 73782
https://ropsten.etherscan.io/tx/0xcdccd4e7d19169851f71a69df5f65445a814044bb8de14a79a6d5acf87c96c44

* 0.5 ETH => 1991.486 tokens, gas = 125122
https://ropsten.etherscan.io/tx/0x2d3b5efff006b7a6a02ce211d653f94d3d0b8dbe7b1df36123b0b8904cf94664

* refund from approved customer after softcap reached => reject, gas = 22480
https://ropsten.etherscan.io/tx/0x70346a33522bc0e0e60913497213fc27adb2c76e03a1136ebc59166c7e9e2252

* refund from unapproved customer, gas = 31929
https://ropsten.etherscan.io/tx/0x141196602ea2a5d4ed4d78171daf20b0cb112cfb9544a80298eb51f2ff7b3fe5

##### Service operations

* setStart, gas = 28262
https://ropsten.etherscan.io/tx/0xfc1a47297f94caeb787233d4e6287f54fdf30bcd0792e158abbc01af90d35aaa

* approveCustomer, gas = 64883
https://ropsten.etherscan.io/tx/0xe533da4e4dd425c009fef403cc36680e0c7ea4a928736785c991dacddd662398

* finish, gas = 47576
https://ropsten.etherscan.io/tx/0x8bc7a051f444ae770423423da85a35923e4ebfb60098222c7f32835a356240e4

#### Mainsale

* _USD Price_                   : 0.2 USD
* _Minimal investment limit_    : 0.1 ETH
* _USD Hardcap_                 : 28 000 000 USD
* _Wallet_                      : 0x8fd94be56237ea9d854b23b78615775121dd1e82
* _BountyTokensPercent_         : 5% 
* _TeamTokensPercent_           : 10% 
* _AdvisorsTokensPercent_       : 5% 
* _EarlyInvestorsTokensPercent_ : 15%
* _BountyTokensWallet_          : 0x8Ba7Aa817e5E0cB27D9c146A452Ea8273f8EFF29
* _AdvisorsTokensWallet_        : 0x24a7774d0eba02846580A214eeca955214cA776C

_freeze wallets_

* 30% tokens unlocked after 24 May 2018 00:00:00 GMT
* 70% tokens unlocked after 25 May 2018 00:00:00 GMT

_Milestones_

1. 6 days                       : bonus +10% 
2. 6 days                       : bonus +9% 
3. 6 days                       : bonus +8%
4. 6 days                       : bonus +7% 
5. 6 days                       : bonus +6% 
6. 6 days                       : bonus +5% 
7. 6 days                       : bonus +4% 
8. 6 days                       : bonus +3% 
9. 6 days                       : bonus +2% 
10. 3 days                      : bonus +1% 
11. 3 days                      : without bonus

##### Purchasers
  
* 0.1 ETH =>  371,294 tokens, gas = 231048
https://ropsten.etherscan.io/tx/0xe3a545d4505fa7e8acb068f7055cf99a91fdb915325b4be8a5ff0c92fbf213a1

##### Service operations

* approveCustomer, gas = 67039
https://ropsten.etherscan.io/tx/0xd3013d3eff742844a72d00aa237321c25d4d98fdf2a9ca9c8c81bd0f6acff2a2

* finish, gas = 230257
https://ropsten.etherscan.io/tx/0x9e3032d0d7070114b0c82bee4cf9098dcf59ef356a2997414214be3fbbbc4527
