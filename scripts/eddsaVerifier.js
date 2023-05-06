const { getInputFromDegree, getMsgFromDegree } = require("./utils");
const { buildEddsa, buildBabyjub } = require("circomlibjs");
const fs = require("fs");
const { groth16 } = require("snarkjs");
const wc = require("./zk_calculator/witness_calculator.js");
const { BN } = require("bn.js");

function buffer2bits(buff) {
  const res = [];
  for (let i = 0; i < buff.length; i++) {
    for (let j = 0; j < 8; j++) {
      if ((buff[i] >> j) & 1) {
        res.push(1n);
      } else {
        res.push(0n);
      }
    }
  }
  return res;
}

const bufferLe = (buf) => {
  const itemBN = new BN(buf);
  const itemLe = itemBN.toBuffer("le");
  const itemLeHex = itemLe.toString("hex");

  return "0x" + itemLeHex;
};

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
  const pubKeyPartials = [
    bufferLe(pPubKey.slice(0, 16)),
    bufferLe(pPubKey.slice(16, 32)),
  ];

  const signature = eddsa.signPedersen(prvKey, msg);
  const pSignature = eddsa.packSignature(signature);

  const r8Bits = buffer2bits(pSignature.slice(0, 32));
  const sBits = buffer2bits(pSignature.slice(32, 64));
  const aBits = buffer2bits(pPubKey);

  const buffer = fs.readFileSync("./scripts/zk_calculator/verifier.wasm");
  const witnessCalculator = await wc(buffer);

  const witnessFile = await witnessCalculator.calculateWTNSBin(
    {
      pubKey: pubKeyPartials,
      A: aBits,
      R8: r8Bits,
      S: sBits,
      ...degree,
    },
    0
  );

  // const zKeyFile = fs.readFileSync("./groth16/zuni/zuni_0000.zkey");

  // const { proof, publicSignals } = await groth16.prove(zKeyFile, witnessFile);
}

main().catch((e) => console.log(e.message));
