const { byteLengthOfData } = require("./constant");
const { BN } = require("bn.js");
const fs = require("fs");
const { buildBabyjub, buildPedersenHash } = require("circomlibjs");

const stringToLeHex = (stringData, length = 32) => {
  const itemBuffer = Buffer.from(stringData);
  const itemBN = new BN(itemBuffer);
  const itemLe = itemBN.toBuffer("le", length);
  const itemLeHex = itemLe.toString("hex");

  return "0x" + itemLeHex;
};

const bufferLe = (buf) => {
  const itemBN = new BN(buf);
  const itemLe = itemBN.toBuffer("le");
  const itemLeHex = itemLe.toString("hex");

  return "0x" + itemLeHex;
};

const toHex = (number, length = 32) =>
  "0x" +
  (number instanceof Buffer
    ? number.toString("hex")
    : new BN(number).toString(16)
  ).padStart(length * 2, "0");

const pedersenHash = async (data) => {
  const babyJubBuilder = await buildBabyjub();
  const pedersenHashBuilder = await buildPedersenHash();
  const hashed = pedersenHashBuilder.hash(data);

  const unpackedPoint = babyJubBuilder.unpackPoint(hashed)[0];

  return babyJubBuilder.F.toString(unpackedPoint);
};

const getPedersenHashFromDegree = async () => {
  const dataStringify = fs.readFileSync("./scripts/data.json");
  const data = JSON.parse(dataStringify);
  let totalData = "";

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];
        const length = byteLengthOfData[key][childKey];

        const itemLeHex = stringToLeHex(value, length);

        totalData += itemLeHex.slice(2);
      }
    } else {
      const value = data[key];
      const length = byteLengthOfData[key];

      const itemLeHex = stringToLeHex(value, length);

      totalData += itemLeHex.slice(2);
    }
  }

  const buff = new BN(totalData, "hex").toBuffer();

  return pedersenHash(buff);
};

const getInputFromDegree = () => {
  const dataStringify = fs.readFileSync("./scripts/data.json");
  const data = JSON.parse(dataStringify);

  const input = {};

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];
      const values = [];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];

        const itemBuf = Buffer.from(value);
        const itemHex = "0x" + itemBuf.toString("hex");

        values.push(itemHex);
      }

      input[key] = values;
    } else {
      const value = data[key];

      const itemBuf = Buffer.from(value);
      const itemHex = "0x" + itemBuf.toString("hex");

      input[key] = itemHex;
    }
  }

  return input;
};

const getMsgFromDegree = () => {
  const dataStringify = fs.readFileSync("./scripts/data.json");
  const data = JSON.parse(dataStringify);
  let totalData = "";

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];
        const length = byteLengthOfData[key][childKey];

        const itemLeHex = stringToLeHex(value, length);

        totalData += itemLeHex.slice(2);
      }
    } else {
      const value = data[key];
      const length = byteLengthOfData[key];

      const itemLeHex = stringToLeHex(value, length);

      totalData += itemLeHex.slice(2);
    }
  }

  const buff = new BN(totalData, "hex").toBuffer();

  return buff;
};

module.exports = {
  stringToLeHex,
  toHex,
  pedersenHash,
  getPedersenHashFromDegree,
  getInputFromDegree,
  getMsgFromDegree,
  bufferLe,
};
