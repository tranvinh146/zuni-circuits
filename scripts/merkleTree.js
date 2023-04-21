const MerkleTree = require("fixed-merkle-tree");
const { getInputFromDegree, getPedersenHashFromDegree } = require("./utils");
const { groth16 } = require("snarkjs");
const wc = require("./zk_calculator/witness_calculator.js");
const fs = require("fs");

const MERKLE_TREE_HEIGHT = 20;

async function main() {
  const leaf = getPedersenHashFromDegree();
  const tree = new MerkleTree(MERKLE_TREE_HEIGHT, [leaf]);

  const root = tree.root();
  console.log("🚀 ~ file: merkleTree.js:12 ~ main ~ root:", root);
  const { pathElements, pathIndices } = tree.path(0);

  const degreeInput = getInputFromDegree();
  const input = {
    root,
    pathElements,
    pathIndices,
    ...degreeInput,
    nonce: 1,
  };

  // build witness calculator with webassembly
  const buffer = fs.readFileSync("./scripts/zk_calculator/zuni.wasm");
  const witnessCalculator = await wc(buffer);

  const witnessFile = await witnessCalculator.calculateWTNSBin(input, 0);
  const zKeyFile = fs.readFileSync("./groth16/zuni_0000.zkey");

  const { proof, publicSignals } = await groth16.prove(zKeyFile, witnessFile);

  const verifyKey = JSON.parse(
    fs.readFileSync("./groth16/verification_key.json")
  );
  const isVerify = await groth16.verify(verifyKey, publicSignals, proof);
  console.log(isVerify);
}

main().catch((e) => console.log(e.message));
