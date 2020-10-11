const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",     // Localhost (default: none)
            port: 8545,            // Standard Ethereum port (default: none)
            network_id: "*",       // Any network (default: none)
        },
        mainnet: {
            provider: () => {return new HDWalletProvider(
                "KEY",
                "wss://mainnet.infura.io/ws/v3/"
            )},
            network_id: "*",
            gas: 2500000,
            gasPrice: 120000000000,
            confirmations: 1,
            timeoutBlocks: 500,
            skipDryRun: true
        }
    },
    mocha: {},
    compilers: {
        solc: {
            version: "0.7.0",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 250
                }
            }
        }
    }
};
