// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskManager {
    address public admin;
    uint256 public totalTasksCompleted;

    mapping(address => uint256) public robotTasks;
    mapping(address => uint256) public robotRewards;

    event TaskCompleted(address indexed robot, uint256 rewardAmount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    modifier onlyAuthorized() {
        // Replace this logic with actual authorization (e.g., check a whitelist)
        require(msg.sender == admin, "Caller is not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerTaskCompletion(address robot, uint256 rewardAmount) external onlyAuthorized {
        require(robotTasks[robot] > 0, "Invalid robot");
        robotRewards[robot] += rewardAmount;
        totalTasksCompleted++;
        emit TaskCompleted(robot, rewardAmount);
    }

    function assignTask(address robot) external onlyAdmin {
        robotTasks[robot]++;
    }

    function getRobotRewards(address robot) external view returns (uint256) {
        return robotRewards[robot];
    }
}
