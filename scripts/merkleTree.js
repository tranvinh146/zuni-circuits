const MerkleTree = require("fixed-merkle-tree");
const { getInputFromDegree, getPedersenHashFromDegree } = require("./utils");
const { groth16 } = require("snarkjs");
const wc = require("./zk_calculator/witness_calculator.js");
const fs = require("fs");
const { AbiCoder } = require("ethers");
const { BN } = require("bn.js");
const { MERKLE_TREE_HEIGHT } = require("./constant");

async function main() {
  const leaf = await getPedersenHashFromDegree();
  const tree = new MerkleTree(MERKLE_TREE_HEIGHT, [leaf]);

  const root = tree.root();
  const { pathElements, pathIndices } = tree.path(0);

  const degreeInput = getInputFromDegree();
  const input = {
    root,
    pathElements,
    pathIndices,
    ...degreeInput,
    nonce: 0,
  };

  // build witness calculator with webassembly
  const buffer = fs.readFileSync("./scripts/zk_calculator/zuni.wasm");
  const witnessCalculator = await wc(buffer);

  const witnessFile = await witnessCalculator.calculateWTNSBin(input, 0);
  const zKeyFile = fs.readFileSync("./groth16/zuni/zuni_0000.zkey");

  const { proof, publicSignals } = await groth16.prove(zKeyFile, witnessFile);

  const dataStr = await groth16.exportSolidityCallData(proof, publicSignals);
  const data = JSON.parse("[" + dataStr + "]");

  const abiCoder = new AbiCoder();

  const bytes = abiCoder.encode(
    ["uint256[2]", "uint256[2][2]", "uint256[2]"],
    [data[0], data[1], data[2]]
  );

  console.log("Solidity Calldata");
  console.log("proof: " + bytes);
  console.log("major: 0x" + degreeInput.major.slice(2).padStart(64, "0"));
  console.log("nonce: 0x" + input.nonce.toString().padStart(64, "0"));
  console.log("root: 0x" + new BN(root).toString("hex").padStart(64, "0"));

  const verifyKey = JSON.parse(
    fs.readFileSync("./groth16/zuni/verification_key.json")
  );
  const isVerify = await groth16.verify(verifyKey, publicSignals, proof);
  console.log("Verify:", isVerify);
}

main().catch((e) => console.log(e.message));
