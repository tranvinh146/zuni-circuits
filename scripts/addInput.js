const { buildEddsa, buildBabyjub } = require("circomlibjs");
const {
  getMsgFromDegree,
  getInputFromDegree,
  convertToLePartials,
} = require("./utils");
const fs = require("fs");

async function main() {
  const eddsa = await buildEddsa();
  const babyJub = await buildBabyjub();

  const msg = getMsgFromDegree();

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

  const degree = getInputFromDegree();
  const input = {
    pubKeyPartials,
    r8Partials,
    sPartials,
    ...degree,
  };

  fs.writeFileSync("./inputs/zuni.json", JSON.stringify(input));
  console.log("\nAdded `zuni.json` file to `inputs/`\n");
}

main().catch((e) => console.log(e.message));
