pragma solidity 0.5.4;

contract TaskManager {
    uint public nTasks; // int public variable

    // enum TaskPhase {ToDo = 0, InProgress = 1, Done = 2, ...}
    enum TaskPhase {ToDo, InProgress, Done, Blocked, Review, Postponed, Canceled}

    // variable group
    struct TaskStruct {
        address owner;
        string name;
        TaskPhase phase;
        uint priority;
    }

    // making an strruct array, following above instructions
    TaskStruct[] private tasks;
    // TaskStruct[] public tasks;

    mapping (address => uint[]) private myTasks;
    // mapping (address => uint[]) public myTasks;

    event TaskAdded(address owner, string name, TaskPhase phase, uint priority);

    modifier onlyOwner (uint _taskIndex) {
        if (tasks[_taskIndex].owner == msg.sender) {
            _; // continue, keep going
        }
    }

    constructor() public {
        nTasks = 0;
        addTask ("Create task manager", TaskPhase.Done, 1);
        addTask ("Create your first task", TaskPhase.ToDo, 1);
        addTask ("Clean your house", TaskPhase.ToDo, 5);
    }

    function getTask(uint _taskIndex) public view
        returns (address owner, string memory name, TaskPhase phase, uint priority) {

            owner = tasks[_taskIndex].owner;
            name = tasks[_taskIndex].name;
            phase = tasks[_taskIndex].phase;
            priority = tasks[_taskIndex].priority;
        }

    function listMyTasks() public view returns(uint[] memory) {
        return myTasks[msg.sender];
    }

    function addTask(string memory _name, TaskPhase _phase, uint _priority) public returns (uint index) {
        require((_priority >= 1 && _priority <= 5), "priority must be between 1 and 5");
        TaskStruct memory taskAux = TaskStruct ({
            owner: msg.sender,
            name: _name,
            phase: _phase,
            priority: _priority
        });

        index = tasks.push (taskAux) - 1;
        nTasks++;
        myTasks[msg.sender].push(index);
        emit TaskAdded(msg.sender, _name, _phase, _priority);
    }

    function updatePhase(uint _taskIndex, TaskPhase _phase) public onlyOwner(_taskIndex) {
        tasks[_taskIndex].phase = _phase;
    }

}



/*
INTERACTIONS:

const accounts = await web3.eth.getAccounts()

truffle(ganache)> accounts
[ '0x3F3686f93f50e308a144e091c26dC56779c2e54b',
  '0xAF97bBCFe498386aF7b3dBEeAaB55C908bB77E27',
  '0xdA3961D77cA86c897Ff336bBa56613ed27BEdFaD',
  '0xC6CD75BaC636B9Fe4f919933A89Ae8Ed400BbFC3',
  '0xFEF1a3f8D103ac9AC116924bE624Cc7b87075153',
  '0x516a91d18C2Bfafba86aBEEd91b2Faa2C0Ecd2B9',
  '0x3258027Cfc70885c055092fbead7753452D6c08f',
  '0xfB525fF0169c193641521879630D93cD914A248B',
  '0x0B642659da467275F10f89d92888DB5FF3f7Aa79',
  '0xe3cBAd00f9d2731b123e9fE40Eb15643365143A0' ]

const taskManager = await TaskManager.deployed()

(await taskManager.nTasks()).toString()

taskManager.listMyTasks()

tx = await taskManager.addTask("Study solidity", 1, 2, {from: accounts[1]})

truffle(ganache)> tx
{ tx: '0x3b7afa4e4fc21e91ceeb422ca0ee1e7502c4839ca4e0d6b27091a1b00d5e4666',
  receipt: 
   { transactionHash: '0x3b7afa4e4fc21e91ceeb422ca0ee1e7502c4839ca4e0d6b27091a1b00d5e4666',
     transactionIndex: 0,
     blockHash: '0x6ba4cf26fd1a72fdb4f7b568ec867f9d2c6801990d0659bce4c57f053fd22455',
     blockNumber: 229,
     from: '0xaf97bbcfe498386af7b3dbeeaab55c908bb77e27',
     to: '0x2b5bae4bbdb916677aaea5aa79a8fc7bb958eac5',
     gasUsed: 161538,
     cumulativeGasUsed: 161538,
     contractAddress: null,
     logs: [ [Object] ],
     status: true,
     logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000004000000000000000080000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000',
     rawLogs: [ [Object] ] },
  logs: 
   [ { logIndex: 0,
       transactionIndex: 0,
       transactionHash: '0x3b7afa4e4fc21e91ceeb422ca0ee1e7502c4839ca4e0d6b27091a1b00d5e4666',
       blockHash: '0x6ba4cf26fd1a72fdb4f7b568ec867f9d2c6801990d0659bce4c57f053fd22455',
       blockNumber: 229,
       address: '0x2B5bae4Bbdb916677AaEA5Aa79A8fc7bB958eAC5',
       type: 'mined',
       id: 'log_ab215705',
       event: 'TaskAdded',
       args: [Result] } ] }

taskManager.listMyTasks({from: accounts[1]})

*/