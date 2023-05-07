// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IRegistryDID.sol";

contract RegistryDID is IRegistryDID, Ownable {
    mapping(string => IssuerInfo) public issuers;
    mapping(string => IssuerInfo) public waitingAcceptIssuers;

    function registerIssuer(
        string calldata did,
        IssuerInfo calldata issuerInfo
    ) public {}

    function acceptIssuer(string calldata did) public override onlyOwner {
        require(waitingAcceptIssuers[did].isRegistered, "DID did not register");

        delete waitingAcceptIssuers[did];

        issuers[did] = waitingAcceptIssuers[did];

        emit AcceptedIssuer(did);
    }

    function declineIssuer(string calldata did) public override onlyOwner {
        require(waitingAcceptIssuers[did].isRegistered, "DID did not register");

        delete waitingAcceptIssuers[did];

        emit DeclinedIssuer(did);
    }

    function removeIssuer(
        string calldata did,
        string calldata reason
    ) public override onlyOwner {
        delete issuers[did];

        emit RemovedIssuer(did, reason);
    }

    function getIssuer(
        string calldata did
    ) external view override returns (IssuerInfo memory) {
        return issuers[did];
    }
}
