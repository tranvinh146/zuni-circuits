const {
  getInputFromDegree,
  getMsgFromDegree,
  convertToLePartials,
} = require("./utils");
const { buildEddsa, buildBabyjub } = require("circomlibjs");
const fs = require("fs");
const { groth16 } = require("snarkjs");
const wc = require("./zk_calculator/witness_calculator.js");
const { AbiCoder } = require("ethers");
const { BN } = require("bn.js");

async function main() {
  const eddsa = await buildEddsa();
  const babyJub = await buildBabyjub();

  const msg = getMsgFromDegree();
  const degree = getInputFromDegree();

  const prvKey = Buffer.from(
    "0001020304050607080900010203040506070809000102030405060708090001",
    "hex"
  );

  const pubKey = eddsa.prv2pub(prvKey);

  const pPubKey = babyJub.packPoint(pubKey);
  const signature = eddsa.signPedersen(prvKey, msg);
  const pSignature = eddsa.packSignature(signature);
  const r8 = pSignature.slice(0, 32);
  const s = pSignature.slice(32, 64);

  const pubKeyPartials = convertToLePartials(pPubKey);
  const r8Partials = convertToLePartials(r8);
  const sPartials = convertToLePartials(s);

  console.log(new BN(pPubKey));
  console.log(new BN(pubKeyPartials[0].slice(2), "hex").toString());
  console.log(new BN(pubKeyPartials[1].slice(2), "hex").toString());

  // const buffer = fs.readFileSync("./scripts/zk_calculator/zuni.wasm");
  // const witnessCalculator = await wc(buffer);

  // const witnessFile = await witnessCalculator.calculateWTNSBin(
  //   {
  //     pubKeyPartials,
  //     r8Partials,
  //     sPartials,
  //     ...degree,
  //   },
  //   0
  // );

  // const zKeyFile = fs.readFileSync("./groth16/zuni/zuni_0000.zkey");
  // const { proof, publicSignals } = await groth16.prove(zKeyFile, witnessFile);

  // const dataStr = await groth16.exportSolidityCallData(proof, publicSignals);
  // const data = JSON.parse("[" + dataStr + "]");

  // const abiCoder = new AbiCoder();
  // const bytes = abiCoder.encode(
  //   ["uint256[2]", "uint256[2][2]", "uint256[2]"],
  //   [data[0], data[1], data[2]]
  // );

  // console.log("Solidity Calldata");
  // console.log("proof: " + bytes);

  // const verifyKey = JSON.parse(
  //   fs.readFileSync("./groth16/zuni/verification_key.json")
  // );
  // const isVerify = await groth16.verify(verifyKey, publicSignals, proof);
  // console.log("Verify:", isVerify);
}

main().catch((e) => console.log(e.message));
