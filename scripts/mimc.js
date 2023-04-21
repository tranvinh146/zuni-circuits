const { BN } = require("bn.js");
const { multiHash } = require("circom-tor/src/mimcsponge");

async function main() {
  const res = multiHash([0x123456789, 0xabcdef]);

  console.log(
    new BN(
      "11716918849379777349750823705379626300511972578535408025767449890146951125453"
    )
  );
  console.log(new BN(res));
}

main().catch((e) => console.log(e.message));
