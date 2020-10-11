module.exports = {
    defaultNetwork: "localhost",
    networks: {
        buidlerevm: {
        },
        localhost: {
          url: "http://localhost:8545"
        },
    },
  // This is a sample solc configuration that specifies which version of solc to use
  solc: {
    version: "0.7.0",
    optimizer: {enabled: true, runs: 200},
  },
};
