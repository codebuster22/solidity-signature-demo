// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SignatureChecker.sol";

contract SignatureCheckerTest is Test {
    SignatureChecker public signChecker;
    // Wallet signerAccount;
    address public signerAccount;
    uint256 public signerPrivateKey;

    function setUp() public {
        // create wallet
        (signerAccount, signerPrivateKey) = makeAddrAndKey("SignerAccount");
        signChecker = new SignatureChecker();
    }

    function signMessageEOA(
        bytes32 txHash,
        uint256 _signerPrivateKey
    ) public pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_signerPrivateKey, txHash);
        return abi.encodePacked(r, s, v);
    }

    function processAndGenerateSignature(
        uint256 field1,
        string memory field2
    )
    view
        public
        returns (bytes memory signature)
    {
        // generate params
        bytes32 messageHash;
            // generate encoded message data
            bytes memory messageHashData = abi.encodePacked(
                    field1, field2
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        // sign message hash
        signature = signMessageEOA(messageHash, signerPrivateKey);
    }

    function testSignature(uint256 field1, string memory field2) public {
        vm.assume(field1 > 0);
        string memory emptyString;
        vm.assume(keccak256(abi.encodePacked(field2))!=keccak256(abi.encodePacked(emptyString)));
        bytes memory signature = processAndGenerateSignature(field1, field2);
        bool isSignatureValid = signChecker.checkSignature(field1, field2, signature, signerAccount);
        assertTrue(isSignatureValid);
    }
}
