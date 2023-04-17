const circomlib = require("circom-tor");
const { BN } = require("bn.js");

const stringToLeHex = (stringData, length = 32) => {
  const itemBuffer = Buffer.from(stringData);
  const itemBN = new BN(itemBuffer);
  const itemLe = itemBN.toBuffer("le", length);
  const itemLeHex = itemLe.toString("hex");

  return "0x" + itemLeHex;
};

const toHex = (number, length = 32) =>
  "0x" +
  (number instanceof Buffer
    ? number.toString("hex")
    : new BN(number).toString(16)
  ).padStart(length * 2, "0");

const pedersenHash = (data) =>
  circomlib.babyJub.unpackPoint(circomlib.pedersenHash.hash(data))[0];

module.exports = {
  stringToLeHex,
  toHex,
  pedersenHash,
};
