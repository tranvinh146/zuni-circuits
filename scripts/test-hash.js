const fs = require("fs");
const { pedersenHash, toHex } = require("./utils");
const { BN } = require("bn.js");
const { buildBabyjub, buildPedersenHash } = require("circomlibjs");

async function main() {
  const dataStringify = fs.readFileSync("./inputs/hash.json");
  const input = JSON.parse(dataStringify);

  const buff = new BN(input.data.slice(2), "hex").toBuffer();

  //   const babyJub = await buildBabyjub();
  //   const pedersen = await buildPedersenHash();
  //   const hash = toHex(babyJub.unpackPoint(pedersen.hash(buff))[1]);

  const hash = toHex(pedersenHash(Buffer.from([0x3a, 0x41, 0x00, 0x00])));

  const publicZkStr = fs.readFileSync("./proof/hash/public.json");
  const publicZk = JSON.parse(publicZkStr);
  const hashOfZk = toHex(publicZk[0]);

  console.log("\nOriginal:");
  console.log(input.data);
  console.log(hash);

  console.log("\nProof:");
  console.log("0x" + new BN(publicZk[1]).toString("hex"));
  console.log(hashOfZk);
}

main().catch((e) => console.log(e.message));
