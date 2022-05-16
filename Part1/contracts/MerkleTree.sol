//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[15] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        uint256 currentZero = 0;
        for (uint8 i = 0; i < 8; i++) {
            hashes[i] = currentZero;
        }
        hashes[8]= PoseidonT3.poseidon([currentZero, currentZero]);
        //hashes[9]= PoseidonT3.poseidon([currentZero, currentZero]);
        //hashes[10]= PoseidonT3.poseidon([currentZero, currentZero]);
       // hashes[11]= PoseidonT3.poseidon([currentZero, currentZero]);
       hashes[9] = hashes[8];
       hashes[10] = hashes[8];
       hashes[11] = hashes[8];

        hashes[12]= PoseidonT3.poseidon([hashes[8], hashes[9]]);
        hashes[13]=hashes[12];
        //hashes[13]= PoseidonT3.poseidon([hashes[10], hashes[11]]);

        hashes[14]= PoseidonT3.poseidon([hashes[12], hashes[13]]);
        //uint256 hashed = PoseidonT3.poseidon([currentZero, currentZero]);
        //currentZero = hashed;
        root = hashes[14];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        hashes[index] = hashedLeaf;
        hashes[8]=PoseidonT3.poseidon([hashes[index], hashes[1]]);
        hashes[9]=PoseidonT3.poseidon([hashes[2], hashes[3]]);
        hashes[10]=PoseidonT3.poseidon([hashes[4], hashes[5]]);
        hashes[11]=PoseidonT3.poseidon([hashes[6], hashes[7]]);
        hashes[12]=PoseidonT3.poseidon([hashes[8], hashes[9]]);
        hashes[13]=PoseidonT3.poseidon([hashes[10], hashes[11]]);
        root = PoseidonT3.poseidon([hashes[12], hashes[13]]);
        index += 1; 
        return root;
       
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        return this.verifyProof(
            a, b, c, input
        );
    }
}
