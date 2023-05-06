// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CheckBytes {
    function splitBytes32AndSwap(
        bytes32 input
    ) public pure returns (bytes16, bytes16) {
        bytes16 firstHalf = bytes16(input);
        bytes16 secondHalf = bytes16(input << 128);
        return (secondHalf, firstHalf);
    }

    function convertToLittleEndian(
        bytes32 input
    ) public pure returns (bytes32) {
        bytes32 output;
        for (uint256 i = 0; i < 32; i++) {
            bytes32 nextByte;
            nextByte = input[i];
            output |= nextByte >> ((31 - i) * 8);
        }

        return output;
    }

    function getInput(
        bytes32 input
    ) public pure returns (uint first, uint second) {
        bytes32 inputLe = convertToLittleEndian(input);
        (bytes16 firstHalfLe, bytes16 secondHalfLe) = splitBytes32AndSwap(
            inputLe
        );

        first = uint(bytes32(firstHalfLe) >> (16 * 8));
        second = uint(bytes32(secondHalfLe) >> (16 * 8));
    }
}
