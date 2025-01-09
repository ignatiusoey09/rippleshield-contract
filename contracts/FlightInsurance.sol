// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlightInsurance {
    IERC20 xrpToken;
    enum InsuranceTier {Basic, Enhanced}
    string public lastReceivedMessage;
    address companyWallet;

    constructor(address _companyWallet, address _tokenAddress) payable {
        require(_companyWallet != address(0), "Invalid sending wallet!");
        companyWallet = _companyWallet;
        xrpToken = IERC20(_tokenAddress);
    }  

    event ReceivedFunding(uint256 amount);

    receive() external payable {
        emit ReceivedFunding(msg.value);
    }

    function depositXRP(uint256 amount) public {
        require(xrpToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
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
    event PayoutFailed(address receipient, uint256 amount);

    
    function initiatePayout( 
        uint8 _tier,
        address userWallet
    ) external {
        require(_tier>=0 && _tier <=1, "Invalid user tier!");

        InsuranceTier insuranceTier = InsuranceTier(_tier);
        uint16 payout = calculatePayout(insuranceTier);
        bool result = xrpToken.transferFrom(address(this), userWallet, payout * 10**18);
        if (result) {
            emit PayoutSent(userWallet, payout);
        } else {
            emit PayoutFailed(userWallet, payout);
        }
        
    }

}