pragma circom 2.0.0;

include "merkleTree.circom";
include "commitmentHasher.circom";

// Verify the commitment that corresponds to the Degree is included in the merkle tree
template Zuni(levels) {
    signal input root;
    signal input name;              
    signal input dateOfBirth[3];    
    signal input school;            
    signal input yearGraduation;    
    signal input major;             
    signal input modeOfStudy;       
    signal input decisionNumber;    
    signal input classification;
    signal input nonce; // not taking part in any computations
    signal input pathElements[levels];
    signal input pathIndices[levels];

    component hasher = CommitmentHasher();
    hasher.name             <== name;
    for (var i = 0; i < 3; i++) {
        hasher.dateOfBirth[i]   <== dateOfBirth[i];
    }
    hasher.school           <== school;
    hasher.yearGraduation   <== yearGraduation;
    hasher.major            <== major;
    hasher.modeOfStudy      <== modeOfStudy;
    hasher.decisionNumber   <== decisionNumber;
    hasher.classification   <== classification;

    component tree = MerkleTreeChecker(levels);
    tree.leaf <== hasher.commitment;
    tree.root <== root;
    for (var i = 0; i < levels; i++) {
        tree.pathElements[i] <== pathElements[i];
        tree.pathIndices[i] <== pathIndices[i];
    }

    // Add hidden signals to make sure that tampering with nonce will invalidate the snark proof
    // It's used to create an unique proof to prevent replay attack
    // Squares are used to prevent optimizer from removing those constraints
    signal nonceSquare;
    nonceSquare <== nonce * nonce;
}

component main { public[root, major, nonce] } = Zuni(20);