// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9;

// Import IAxelarGateway from cgp library to access callContractWithToken. Aliased to cgpIAxelarGateway
import "https://github.com/axelarnetwork/axelar-cgp-solidity/blob/main/contracts/interfaces/IAxelarGateway.sol" as cgpIAxelarGateway;


contract FlightInsurance {
    cgpIAxelarGateway.IAxelarGateway public cgpGateway;
    enum InsuranceTier {Basic, Enhanced}
    string public lastReceivedMessage;

    constructor(address gatewayAddress) {
        require(gatewayAddress != address(0), "Invalid address!");
        cgpGateway = cgpIAxelarGateway.IAxelarGateway(gatewayAddress);
    }  


    /** 
    * @dev Calculates the correct payout based on insurance tier
    * @param _userTier The insurance tier of the user
    */
    function calculatePayout(InsuranceTier _userTier) pure private returns (uint16) {
        uint16 payout;
        if (_userTier == InsuranceTier.Basic) {
            // XRP equal to SGD1000
            payout = 300;
        } else if (_userTier == InsuranceTier.Enhanced) {
            // XRP equal to SGD3500
                payout = 1048;
        } else {
            revert();
        }
        return payout;
    }
    
    /** 
    * @dev Error triggered when this contract has insufficient funds
    */
    error InsufficientBalance(uint16 required, uint256 available);

    /** 
    * @dev Event triggered when transaction is successful
    */
    event PayoutSent(string receipient, uint256 amount);

    
    function execute(
        bytes32 commandId, 
        string calldata sourceChain, 
        string calldata sourceAddress, 
        bytes calldata payload
    ) external {
        //payload contains: insurance tier and user XRPL wallet address
        (uint8 tier, string memory userAddress) = abi.decode(payload, (uint8, string));
        require(tier>=0 && tier <=1, "Invalid user tier!");

        InsuranceTier insuranceTier = InsuranceTier(tier);
        uint256 payout = calculatePayout(insuranceTier);

        bytes memory returnPayload = abi.encode();
        cgpGateway.callContractWithToken(sourceChain, userAddress, returnPayload, "XRP", payout);
        emit PayoutSent(userAddress, payout);
    }
}