// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[3] memory input
    ) external view returns (bool r);
}

contract ZUni is AccessControl {
    bytes32 public root;
    mapping(bytes32 => bool) public usedNonces;

    IVerifier public verifier;
    bytes32 public constant UPDATE_ROLE = keccak256("UPDATE_ROLE");

    event UpdatedRoot(bytes32 indexed root);
    event VerifiedDegree(bytes32 nonce);

    constructor(IVerifier _verifier) {
        verifier = _verifier;

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(UPDATE_ROLE, _msgSender());
    }

    function updateRoot(bytes32 _root) public onlyRole(UPDATE_ROLE) {
        root = _root;

        emit UpdatedRoot(_root);
    }

    function verifyDegree(
        bytes memory proof,
        bytes32 major,
        bytes32 nonce
    ) public {
        require(usedNonces[nonce] == false, "Nonce is used");

        (uint256[2] memory a, uint256[2][2] memory b, uint256[2] memory c) = abi
            .decode(proof, (uint256[2], uint256[2][2], uint256[2]));

        uint256[3] memory input = [
            uint256(root),
            uint256(major),
            uint256(nonce)
        ];

        bool result = verifier.verifyProof(a, b, c, input);
        require(result == true, "Verify Degree Fail");

        usedNonces[nonce] = true;

        emit VerifiedDegree(nonce);
    }

    function updateVerifier(
        IVerifier _verifier
    ) public onlyRole(getRoleAdmin(UPDATE_ROLE)) {
        verifier = _verifier;
    }

    function grantUpdateRole(
        address account
    ) public onlyRole(getRoleAdmin(UPDATE_ROLE)) {
        _grantRole(UPDATE_ROLE, account);
    }

    function revokeUpdateRole(
        address account
    ) public onlyRole(getRoleAdmin(UPDATE_ROLE)) {
        _revokeRole(UPDATE_ROLE, account);
    }
}
