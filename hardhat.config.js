/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
const { API_URL, PRIVATE_KEY } =process.env;
module.exports = {
  solidity: "0.8.20",
	defaultNetwork: "goerli",
	networks: {
		hardhat:{},
		goerli: {
			url: API_URL,
			accounts: [`0x${PRIVATE_KEY}`]
		}
	},
};
//合约地址 0x803d678cc6b61ea0b6c706bfd064671cd508fdd3
//领取水龙头账户 0xc65853babec8f0b00be25ef2d29bd4da9ab64b9c

//https://gateway.pinata.cloud/ipfs/QmS93nc4rFDAh9AJrxt34HRucV4LGf5UhR8h9Z1TZSdpfr