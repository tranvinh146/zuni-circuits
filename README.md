# Source code structure:

- `circuits`: includes circom files.
- `compilers`: compile from circuits.
- `inputs`: input data to compile witness.
- `groth16`: includes keys to create and verify proof.
- `proofs`: includes proofs.
- `contracts`: smart contracts.

# Guide

1. Download [file key](https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau).
2. Create `groth16` folder in root directory, then store downloaded key in `groth16` folder.
3. Run `npm run zuni:build` to build zk-snark.
4. Run `npm run zuni:mt` to verify and get calldata.
5. Deploy `Verifier.sol` in Remix.
6. Deploy `Zuni.sol` with address `Verifier` as an argument of constructor.
7. Call `updateRoot` with `root` in step4.
8. Call `verifyDegree` with outputs in step4.
