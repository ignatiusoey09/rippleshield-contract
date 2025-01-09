// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9;

contract FlightInsurance {
    enum InsuranceTier {Basic, Enhanced}
    string public lastReceivedMessage;

    constructor(address companyWallet) {
        require(companyWallet != address(0), "Invalid sending wallet!");
    }  


    /** 
    * @dev Calculates the correct payout based on insurance tier
    * @param _userTier The insurance tier of the user
    */
    function calculatePayout(InsuranceTier _userTier) pure private returns (uint16) {
        uint16 payout;
        if (_userTier == InsuranceTier.Basic) {
            // XRP equal to SGD1000
            payout = 1;
        } else if (_userTier == InsuranceTier.Enhanced) {
            // XRP equal to SGD3500
                payout = 3;
        } else {
            revert("Invalid insurance tier!");
        }
        return payout;
    }

    /** 
    * @dev Event triggered when transaction is successful
    */
    event PayoutSent(address receipient, uint256 amount);

    /** 
    * @dev Event triggered when transaction failed
    */
    event PayoutFailed(address receipient, uint256 amount, string returnData);

    
    function initiatePayout( 
        uint8 _tier,
        address userWallet
    ) external {
        require(_tier>=0 && _tier <=1, "Invalid user tier!");

        InsuranceTier insuranceTier = InsuranceTier(_tier);
        uint16 payout = calculatePayout(insuranceTier);
        (bool sent, bytes memory data) = payable(userWallet).call{value: payout}("");
        if (sent) {
            emit PayoutSent(userWallet, payout);
        } else {
            string memory dataString = abi.decode(data, (string));
            emit PayoutFailed(userWallet, payout, dataString);
        }
    }

}