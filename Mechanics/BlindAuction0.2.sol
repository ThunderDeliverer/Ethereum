/// @title Blind auction v0.2
pragma solidity ^0.4.11;

contract BlindAuction{
	struct Bid {
		bytes32 blindedBid;
		uint deposit;
	}
	address public beneficiary;
	uint public auctionStart;
	uint public biddingEnd;
	uint public revealEnd;
	bool public ended;

	mapping(address => Bid[]) public bids;

	address public highestBidder;
	uint public highestBid;
	uint public numberOfParticipants;

	//Allowed withdrawals of previous bids
	mapping(address => uint) pendingReturns;
	//Maps all of the participating addresses in order to make the contract reusable.
	mapping(uint => address) public participatingAddresses;

	//Event to notify nodes that auction started and what is being acutioned.
	event AuctionStarted(address whereToDirectBids, string description);
	//Event to notify nodes about auction ending and who won.
	event AuctionEnded(address winner, uint highestBid);

	// Modifiers are a convenient way to validate inputs to functions. "onlyBefore" is applied
	// to "bid" below:
	// the new function body is the modifier's body there "_" is replaced by the old function body.
	modifier onlyBefore(uint _time){
		if(now >= _time) revert();
		_;
	}
	modifier onlyAfter(uint _time){
		if(now <= _time) revert();
		_;
	}

//🤔 === Feature in testing phase.
//🤠 === Feature tamed.
//😵 === Test failed.
//🚧 === Under construction.

//Reuse feature 😵
//Remove existing bid data and prepare to reuse auction contract. 🚧

	//Remember that one time unit is one second.
	function BlindAuction(uint biddingTime, uint revealTime, address contractBeneficiary, bool startNow, string descriptionOfAuction){
		if(contractBeneficiary == 0){
			beneficiary = msg.sender;
		}
		else{
			beneficiary = contractBeneficiary;
		}
		if(startNow){
			auctionStart = now;
			biddingEnd = now + biddingTime;
			revealEnd = biddingEnd + revealTime;
			AuctionStarted(this, descriptionOfAuction);
		}
		numberOfParticipants = 0;
	}

	function startAuction(uint _biddingTime, uint _revealTime, address _beneficiary, string descriptionOfAuction) onlyAfter(revealEnd){
		if(_beneficiary == 0){
			beneficiary = msg.sender;
		}
		else{
			beneficiary = _beneficiary;
		}
		auctionStart = now;
		biddingEnd = auctionStart + _biddingTime;
		revealEnd = biddingEnd + _revealTime;
		AuctionStarted(this, descriptionOfAuction);
		for(uint i = 0; i < numberOfParticipants; i++){
			delete bids[participatingAddresses[i]][0].blindedBid;
			delete bids[participatingAddresses[i]][0].deposit;
			delete participatingAddresses[i];
		}
		numberOfParticipants = 0;
		highestBidder = 0x0;
		highestBid = 0;
	}

	//Place a blinded bid with "_blindedbid" = sha3(value, fake, secret).
	//The sent ether is only refunded if the bid is correctly revealed in the revealing phase.
	//The bid is valid if the Ether sent together with the bid is at least "value" and "fake" is not
	//true. Setting "fake" to true and sending not the exact amount are ways to hide the real bid
	//but still make the required deposit. The same address can place multiple bids.
	//Use http://emn178.github.io/online-tools/keccak_256.html for calculating hash.
	//Value in the hashing mechanism is entered in wei, so take that into account when sending Ether.
	function bid(bytes32 _blindedBid) onlyBefore(biddingEnd) payable{
		//if(bids[msg.sender][0].blindedBid == 0x0){
				bids[msg.sender].push(Bid({
					blindedBid: _blindedBid,
					deposit: msg.value
				}));
		/*	}
		else{
			bids[msg.sender][0].blindedBid = _blindedBid;
			bids[msg.sender][0].deposit = msg.value;
		}*/
		numberOfParticipants += 1;
		participatingAddresses[numberOfParticipants] = msg.sender;
	}

	// Reveal your blinded bids. You will get a refund for all correctly blinded invalid bids and for
	// all bids except for the totally highest one.
	//Value here is entered in wei, so be sure to take that into account when calculating hash for blindedBid.
	function reveal(uint _value, bool _fake, string _secret) onlyAfter(biddingEnd) onlyBefore(revealEnd){
		uint refund;
		var bid = bids[msg.sender][0];
		if(bids[msg.sender][0].blindedBid == sha3(_value, !_fake, _secret)){
			refund += bid.deposit;
			if(!_fake && bid.deposit >= _value){
				if(placeBid(msg.sender, _value))
					refund -= _value;
			}
			//Make it impossible fot sender to reclaim the same deposit.
			bid.blindedBid = 0x0;
			if(!msg.sender.send(refund)){revert();}
		}
	}

	//This is an internal function and can only be called upon form the contract itself (or from derived contracts).
	function placeBid(address bidder, uint value) internal returns (bool success){
		if(value <= highestBid){
			return false;
		}
		if(highestBidder != 0){
			//Refund the previously highest bidder.
			pendingReturns[highestBidder] += highestBid;
		}
		highestBid = value;
		highestBidder = bidder;
		return true;
	}

	// Withdraw a bid that was overbid.
	function withdraw(){
		var amount = pendingReturns[msg.sender];
		// It is important to set this to zero because the recipient can call this function again as a part of the receiving call
		// before "send" returns (see the remark about conditions ---> effects ---> interaction).
		pendingReturns[msg.sender] = 0;
		if(!msg.sender.send(amount)) revert(); // If anything fails, this will revert the changes above
	}

	// End the auction and send the highest bid to the beneficiary.
	function auctionEnd() onlyAfter(revealEnd){
		if(ended) revert();
		AuctionEnded(highestBidder, highestBid);
		ended = true;
		//We send all the money we have, because some of the refunds might have failed.
		if(!beneficiary.send(this.balance)) revert();
	}

	//Refuse to collect any Ether sent to the Auction without it being part of the function.
	function(){
		revert();
	}
}
