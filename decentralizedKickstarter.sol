pragma solidity ^0.8.1;

contract CampaignFactory{
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
       address newCampaign = address( new Campaign(minimum, msg.sender));
       deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[] memory){
        return deployedCampaigns;
    }
}

contract Campaign{
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    address public manager;
    uint public minimumContribution;
    // Request[] public requests;
    mapping(address => bool) public approvers;
    // uint id;
    mapping(uint => Request) public requests;
    uint private currentIndex = 0;
    uint public approversCount;
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    constructor(uint minimum, address creator){
        manager = creator;
        minimumContribution = minimum;
        // id = 0;
        approversCount = 0;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;        
        approversCount++;
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
        Request storage newRequest = requests[currentIndex];
            newRequest.description= description;
            newRequest.value= value;
            newRequest.recipient= recipient;
            newRequest.complete= false;
            newRequest.approvalCount= 0;
            currentIndex++;

        //  requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]); //check if contributed
        require(!request.approvals[msg.sender]); //check if has already voted

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finaliseRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }
}