// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9;

contract FlightInsurance {
    enum InsuranceTier {Basic, Enhanced}

    /** 
    * @dev Calculates the correct payout based on insurance tier
    * @param _userTier The insurance tier of the user
    */
    function calculatePayout(InsuranceTier _userTier) pure private returns (uint16) {
        uint16 payout;
        if (_userTier == InsuranceTier.Basic) {
            // XRP equal to SGD1000
            payout = 300;
        } else {
            if (_userTier == InsuranceTier.Enhanced) {
                // XRP equal to SGD3500
                payout = 1048;
            } else {
                revert();
            }
        }
        return payout;
    }
    
    /** 
    * @dev Event triggered when transaction is successful
    */
    event Sent(address receipient, uint16 amount);

    /** 
    * @dev Error triggered when this contract has insufficient funds
    */
    error InsufficientBalance(uint16 required, uint256 available);

    //Sends the funds to user
    function makePayout(address payable userAddress, InsuranceTier _userTier) public {
        uint16 payout = calculatePayout(_userTier);
        require(address(this).balance>=payout, InsufficientBalance(payout, address(this).balance));
        userAddress.transfer(payout);
        emit Sent(userAddress, payout);
    }
    
}