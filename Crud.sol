pragma solidity ^0.8.0;

contract Crud {
    struct User {
        uint256 id;
        string firstName;
        string lastName;
    }

    User[] public users;
    uint256 public count = 0;

    function addUser(string memory _firstName, string memory _lastName) public {
        users.push(User(count, _firstName, _lastName));
        count++;
    }

    
    function getUserById(uint id) public returns(uint,string memory){
        uint i = getUser(id);
        return(users[i].id,users[i].firstName);
    }

    function deleteUserById(uint256 id) public {
        uint256 i = getUser(id);
        delete users[i];
    }

    function update(
        uint256 id,
        string memory _newFirstName,
        string memory _newLasttName
    ) public {
        uint256 i = getUser(id);
        users[i].firstName = _newFirstName;
        users[i].lastName = _newLasttName;
    }

    function getID(uint256 id) internal view returns (uint256) {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i].id == id) {
                return i;
            }
        }
        revert("User doesn't exist!!!");
    }
}
 