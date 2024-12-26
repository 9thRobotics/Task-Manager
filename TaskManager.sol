// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TaskManager is Ownable, ReentrancyGuard {
    uint256 public totalTasksCompleted;

    mapping(address => uint256) public robotTasks;
    mapping(address => uint256) public robotRewards;
    mapping(address => bool) public authorizedRobots;

    event TaskCompleted(address indexed robot, uint256 rewardAmount);
    event TaskAssigned(address indexed robot);
    event RobotAuthorized(address indexed robot);
    event RobotDeauthorized(address indexed robot);

    modifier onlyAuthorized() {
        require(authorizedRobots[msg.sender], "Caller is not authorized");
        _;
    }

    constructor() {
        authorizeRobot(msg.sender); // Automatically authorize the admin
    }

    function registerTaskCompletion(address robot, uint256 rewardAmount) external onlyAuthorized nonReentrant {
        require(robotTasks[robot] > 0, "Invalid robot");
        robotRewards[robot] += rewardAmount;
        totalTasksCompleted++;
        emit TaskCompleted(robot, rewardAmount);
    }

    function assignTask(address robot) external onlyOwner {
        robotTasks[robot]++;
        emit TaskAssigned(robot);
    }

    function authorizeRobot(address robot) public onlyOwner {
        authorizedRobots[robot] = true;
        emit RobotAuthorized(robot);
    }

    function deauthorizeRobot(address robot) public onlyOwner {
        authorizedRobots[robot] = false;
        emit RobotDeauthorized(robot);
    }

    function getRobotRewards(address robot) external view returns (uint256) {
        return robotRewards[robot];
    }

    function withdrawRewards() external nonReentrant {
        uint256 reward = robotRewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");
        robotRewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }

    receive() external payable {}
}
