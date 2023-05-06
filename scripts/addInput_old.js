const fs = require("fs");
const { getInputFromDegree, getPedersenHashFromDegree } = require("./utils");
const MerkleTree = require("fixed-merkle-tree");
const { MERKLE_TREE_HEIGHT } = require("./constant");

async function main() {
  console.log("\nAdding new file...");
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

  fs.writeFileSync("./inputs/zuni_old.json", JSON.stringify(input));
  console.log("\nAdded `zuni_old.json` file to `inputs/`\n");
}

main().catch((e) => console.log(e.message));
