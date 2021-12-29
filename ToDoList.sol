pragma solidity ^0.8.3;

contract ToDolist {
    struct Todo {
        string task;
        bool isCompleted;
    }

    Todo[] public todos;

    function createTas(string calldata _task) external {
        todos.push(Todo({task: _task, isCompleted: false}));
    }

    function updateTask(uint256 _index, string calldata _task) external {
        Todo storage todo = todos[_index];
        todo.task = _task;
    }

    function toggleTask(uint256 _index) external {
        Todo storage todo = todos[_index];
        todo.isCompleted = !todo.isCompleted;
    }

    //Below funnction is NOT needed as a funtion named todos() is automaically created
    function getTask(uint256 _index) 
        external
        view
        returns (string memory, bool)
    {
        Todo storage todo = todos[_index];
        return (todo.task, todo.isCompleted);
    }
}
