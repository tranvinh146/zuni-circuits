const path = require("path");
const fs = require("fs");
const genContract = require("circomlibjs/src/mimcsponge_gencontract.js");

// where Truffle will expect to find the results of the external compiler
// command
const outputPath = path.join(__dirname, "..", "contracts", "Hasher.json");

function main() {
  const contract = {
    contractName: "Hasher",
    abi: genContract.abi,
    bytecode: genContract.createCode("mimcsponge", 220),
  };

  fs.writeFileSync(outputPath, JSON.stringify(contract));
}

main();
