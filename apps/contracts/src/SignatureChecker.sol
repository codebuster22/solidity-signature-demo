// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignatureChecker {
    using ECDSA for bytes32;

    function checkSignature(uint256 field1, string memory field2, bytes memory signature, address signerAccountToCheck) pure public returns(bool _isValid) {
        bytes32 messageHash = keccak256(abi.encodePacked(field1, field2));
        (address signerAddress,) = messageHash.tryRecover(signature);
        return signerAddress == signerAccountToCheck;
    }
}
