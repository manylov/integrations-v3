/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../common";
import type { DegenNFT, DegenNFTInterface } from "../DegenNFT";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_addressProvider",
        type: "address",
      },
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "string",
        name: "_symbol",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "CallerNotConfiguratorException",
    type: "error",
  },
  {
    inputs: [],
    name: "CallerNotPausableAdminException",
    type: "error",
  },
  {
    inputs: [],
    name: "CallerNotUnPausableAdminException",
    type: "error",
  },
  {
    inputs: [],
    name: "CreditFacadeOrConfiguratorOnlyException",
    type: "error",
  },
  {
    inputs: [],
    name: "InsufficientBalanceException",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidCreditFacadeException",
    type: "error",
  },
  {
    inputs: [],
    name: "MinterOnlyException",
    type: "error",
  },
  {
    inputs: [],
    name: "NotImplementedException",
    type: "error",
  },
  {
    inputs: [],
    name: "ZeroAddressException",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "approved",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "NewCreditFacadeAdded",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "NewCreditFacadeRemoved",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "NewMinterSet",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Paused",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Unpaused",
    type: "event",
  },
  {
    inputs: [],
    name: "_acl",
    outputs: [
      {
        internalType: "contract IACL",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "creditFacade_",
        type: "address",
      },
    ],
    name: "addCreditFacade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "baseURI",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "getApproved",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
    ],
    name: "isApprovedForAll",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "isSupportedCreditFacade",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "minter",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "ownerOf",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "creditFacade_",
        type: "address",
      },
    ],
    name: "removeCreditFacade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "baseURI_",
        type: "string",
      },
    ],
    name: "setBaseUri",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "minter_",
        type: "address",
      },
    ],
    name: "setMinter",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "tokenURI",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "version",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60c06040523480156200001157600080fd5b50604051620025cd380380620025cd833981016040819052620000349162000265565b828282600062000045838262000371565b50600162000054828262000371565b50506006805460ff19169055506001600160a01b0381166200008957604051635919af9760e11b815260040160405180910390fd5b806001600160a01b031663087376956040518163ffffffff1660e01b8152600401602060405180830381865afa158015620000c8573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190620000ee91906200043d565b6001600160a01b03166080816001600160a01b03168152505050826001600160a01b031663c513c9bb6040518163ffffffff1660e01b8152600401602060405180830381865afa15801562000147573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906200016d91906200043d565b6001600160a01b031660a0525062000462915050565b80516001600160a01b03811681146200019b57600080fd5b919050565b634e487b7160e01b600052604160045260246000fd5b600082601f830112620001c857600080fd5b81516001600160401b0380821115620001e557620001e5620001a0565b604051601f8301601f19908116603f01168101908282118183101715620002105762000210620001a0565b816040528381526020925086838588010111156200022d57600080fd5b600091505b8382101562000251578582018301518183018401529082019062000232565b600093810190920192909252949350505050565b6000806000606084860312156200027b57600080fd5b620002868462000183565b60208501519093506001600160401b0380821115620002a457600080fd5b620002b287838801620001b6565b93506040860151915080821115620002c957600080fd5b50620002d886828701620001b6565b9150509250925092565b600181811c90821680620002f757607f821691505b6020821081036200031857634e487b7160e01b600052602260045260246000fd5b50919050565b601f8211156200036c57600081815260208120601f850160051c81016020861015620003475750805b601f850160051c820191505b81811015620003685782815560010162000353565b5050505b505050565b81516001600160401b038111156200038d576200038d620001a0565b620003a5816200039e8454620002e2565b846200031e565b602080601f831160018114620003dd5760008415620003c45750858301515b600019600386901b1c1916600185901b17855562000368565b600085815260208120601f198616915b828110156200040e57888601518255948401946001909101908401620003ed565b50858210156200042d5787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b6000602082840312156200045057600080fd5b6200045b8262000183565b9392505050565b60805160a051612114620004b96000396000610a2501526000818161038601528181610630015281816107ef01528181610ea801528181610f9401528181611144015281816112e6015261149801526121146000f3fe608060405234801561001057600080fd5b50600436106101c45760003560e01c80636352211e116100f9578063a0bcfc7f11610097578063b88d4fde11610071578063b88d4fde146103a8578063c87b56dd146103b6578063e985e9c5146103c9578063fca3b5aa1461041257600080fd5b8063a0bcfc7f14610360578063a22cb46514610373578063a50cf2c81461038157600080fd5b80638456cb59116100d35780638456cb591461032a57806389406ff51461033257806395d89b41146103455780639dc29fac1461034d57600080fd5b80636352211e146102fc5780636c0360eb1461030f57806370a082311461031757600080fd5b80633f4ba83a116101665780634610f6ac116101405780634610f6ac146102b357806354fd4d50146102c6578063576cd2d1146102ce5780635c975abb146102f157600080fd5b80633f4ba83a1461029857806340c10f19146102a057806342842e0e1461028a57600080fd5b8063081812fc116101a2578063081812fc1461024b578063095ea7b31461025e57806318160ddd1461027357806323b872dd1461028a57600080fd5b806301ffc9a7146101c957806306fdde03146101f15780630754617214610206575b600080fd5b6101dc6101d7366004611b05565b610425565b60405190151581526020015b60405180910390f35b6101f961050a565b6040516101e89190611b4e565b6008546102269073ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020016101e8565b610226610259366004611bba565b61059c565b61027161026c366004611bf5565b6105d0565b005b61027c60075481565b6040519081526020016101e8565b61027161026c366004611c21565b610271610602565b6102716102ae366004611bf5565b6106f0565b6102716102c1366004611c62565b6107c1565b61027c600181565b6101dc6102dc366004611c62565b60096020526000908152604090205460ff1681565b60065460ff166101dc565b61022661030a366004611bba565b610c8d565b6101f9610d1e565b61027c610325366004611c62565b610dac565b610271610e7a565b610271610340366004611c62565b610f66565b6101f96110ec565b61027161035b366004611bf5565b6110fb565b61027161036e366004611c7f565b6112b8565b61027161026c366004611cff565b6102267f000000000000000000000000000000000000000000000000000000000000000081565b61027161026c366004611d67565b6101f96103c4366004611bba565b6113ae565b6101dc6103d7366004611e65565b73ffffffffffffffffffffffffffffffffffffffff918216600090815260056020908152604080832093909416825291909152205460ff1690565b610271610420366004611c62565b61146a565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f80ac58cd0000000000000000000000000000000000000000000000000000000014806104b857507fffffffff0000000000000000000000000000000000000000000000000000000082167f5b5e139f00000000000000000000000000000000000000000000000000000000145b8061050457507f01ffc9a7000000000000000000000000000000000000000000000000000000007fffffffff000000000000000000000000000000000000000000000000000000008316145b92915050565b60606000805461051990611e93565b80601f016020809104026020016040519081016040528092919081815260200182805461054590611e93565b80156105925780601f1061056757610100808354040283529160200191610592565b820191906000526020600020905b81548152906001019060200180831161057557829003601f168201915b5050505050905090565b60006105a7826115bd565b5060009081526004602052604090205473ffffffffffffffffffffffffffffffffffffffff1690565b6040517f24e46f7000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6040517fd4eb5db00000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff169063d4eb5db090602401602060405180830381865afa15801561068c573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906106b09190611ee6565b6106e6576040517f10332dee00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6106ee611648565b565b60085473ffffffffffffffffffffffffffffffffffffffff163314610741576040517f5c2967f500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600061074c83610dac565b905060005b828110156107a4576000816107858478ffffffffffffffffffffffffffffffffffffffff0000000000602889901b16611f32565b61078f9190611f32565b905061079b85826116c5565b50600101610751565b5081600760008282546107b79190611f32565b9091555050505050565b6040517f5f259aba0000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690635f259aba90602401602060405180830381865afa15801561084b573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061086f9190611ee6565b6108a5576040517f61081c1500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b73ffffffffffffffffffffffffffffffffffffffff811660009081526009602052604090205460ff16610c8a5773ffffffffffffffffffffffffffffffffffffffff81163b610920576040517f9c01f6a900000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60008173ffffffffffffffffffffffffffffffffffffffff1663c12c21c06040518163ffffffff1660e01b8152600401602060405180830381865afa9250505080156109a7575060408051601f3d9081017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe01682019092526109a491810190611f45565b60015b6109dd576040517f9c01f6a900000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6040517f6fbc6f6b00000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff80831660048301529192507f000000000000000000000000000000000000000000000000000000000000000090911690636fbc6f6b90602401602060405180830381865afa158015610a6e573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a929190611ee6565b1580610b3857503073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16639408b63f6040518163ffffffff1660e01b8152600401602060405180830381865afa158015610afb573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b1f9190611f45565b73ffffffffffffffffffffffffffffffffffffffff1614155b80610bdd57508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16632f7a18816040518163ffffffff1660e01b8152600401602060405180830381865afa158015610ba0573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610bc49190611f45565b73ffffffffffffffffffffffffffffffffffffffff1614155b15610c14576040517f9c01f6a900000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b73ffffffffffffffffffffffffffffffffffffffff821660008181526009602052604080822080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00166001179055517f8de8732e27fafa42885cd4371b667b9c76e3bfc2837f01ebe809e3a49f5fcbad9190a2505b50565b60008181526002602052604081205473ffffffffffffffffffffffffffffffffffffffff1680610504576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601860248201527f4552433732313a20696e76616c696420746f6b656e204944000000000000000060448201526064015b60405180910390fd5b600a8054610d2b90611e93565b80601f0160208091040260200160405190810160405280929190818152602001828054610d5790611e93565b8015610da45780601f10610d7957610100808354040283529160200191610da4565b820191906000526020600020905b815481529060010190602001808311610d8757829003601f168201915b505050505081565b600073ffffffffffffffffffffffffffffffffffffffff8216610e51576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602960248201527f4552433732313a2061646472657373207a65726f206973206e6f74206120766160448201527f6c6964206f776e657200000000000000000000000000000000000000000000006064820152608401610d15565b5073ffffffffffffffffffffffffffffffffffffffff1660009081526003602052604090205490565b6040517f3a41ec640000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690633a41ec6490602401602060405180830381865afa158015610f04573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610f289190611ee6565b610f5e576040517fd794b1e700000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6106ee6118ea565b6040517f5f259aba0000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690635f259aba90602401602060405180830381865afa158015610ff0573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906110149190611ee6565b61104a576040517f61081c1500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b73ffffffffffffffffffffffffffffffffffffffff811660009081526009602052604090205460ff1615610c8a5773ffffffffffffffffffffffffffffffffffffffff811660008181526009602052604080822080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00169055517febbf1afa794a370cdfc745705fb79430bd57343fe03fcfecfce9f9769e4e5f2f9190a250565b60606001805461051990611e93565b3360009081526009602052604090205460ff161580156111c657506040517f5f259aba0000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690635f259aba90602401602060405180830381865afa1580156111a0573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906111c49190611ee6565b155b156111fd576040517f1e0d048500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600061120883610dac565b905081811015611244576040517f90c9142d00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60005b828110156112a557600060018261127d8578ffffffffffffffffffffffffffffffffffffffff000000000060288a901b16611f32565b6112879190611f62565b6112919190611f62565b905061129c81611945565b50600101611247565b5081600760008282546107b79190611f62565b6040517f5f259aba0000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690635f259aba90602401602060405180830381865afa158015611342573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906113669190611ee6565b61139c576040517f61081c1500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600a6113a9828483611fc3565b505050565b60008181526002602052604090205460609073ffffffffffffffffffffffffffffffffffffffff16611462576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602f60248201527f4552433732314d657461646174613a2055524920717565727920666f72206e6f60448201527f6e6578697374656e7420746f6b656e00000000000000000000000000000000006064820152608401610d15565b610504611a1d565b6040517f5f259aba0000000000000000000000000000000000000000000000000000000081523360048201527f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1690635f259aba90602401602060405180830381865afa1580156114f4573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906115189190611ee6565b61154e576040517f61081c1500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600880547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff83169081179091556040517f49d62ab6a85289b2ebfd2d2384816f22284bc5ff5ae18c124df358e9db03158e90600090a250565b60008181526002602052604090205473ffffffffffffffffffffffffffffffffffffffff16610c8a576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601860248201527f4552433732313a20696e76616c696420746f6b656e20494400000000000000006044820152606401610d15565b611650611a2c565b600680547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b60405173ffffffffffffffffffffffffffffffffffffffff909116815260200160405180910390a1565b73ffffffffffffffffffffffffffffffffffffffff8216611742576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820181905260248201527f4552433732313a206d696e7420746f20746865207a65726f20616464726573736044820152606401610d15565b60008181526002602052604090205473ffffffffffffffffffffffffffffffffffffffff16156117ce576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601c60248201527f4552433732313a20746f6b656e20616c7265616479206d696e746564000000006044820152606401610d15565b60008181526002602052604090205473ffffffffffffffffffffffffffffffffffffffff161561185a576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601c60248201527f4552433732313a20746f6b656e20616c7265616479206d696e746564000000006044820152606401610d15565b73ffffffffffffffffffffffffffffffffffffffff8216600081815260036020908152604080832080546001019055848352600290915280822080547fffffffffffffffffffffffff0000000000000000000000000000000000000000168417905551839291907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908290a45050565b6118f2611a98565b600680547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a25861169b3390565b600061195082610c8d565b905061195b82610c8d565b600083815260046020908152604080832080547fffffffffffffffffffffffff000000000000000000000000000000000000000090811690915573ffffffffffffffffffffffffffffffffffffffff85168085526003845282852080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0190558785526002909352818420805490911690555192935084927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908390a45050565b6060600a805461051990611e93565b60065460ff166106ee576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601460248201527f5061757361626c653a206e6f74207061757365640000000000000000000000006044820152606401610d15565b60065460ff16156106ee576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601060248201527f5061757361626c653a20706175736564000000000000000000000000000000006044820152606401610d15565b600060208284031215611b1757600080fd5b81357fffffffff0000000000000000000000000000000000000000000000000000000081168114611b4757600080fd5b9392505050565b600060208083528351808285015260005b81811015611b7b57858101830151858201604001528201611b5f565b5060006040828601015260407fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f8301168501019250505092915050565b600060208284031215611bcc57600080fd5b5035919050565b73ffffffffffffffffffffffffffffffffffffffff81168114610c8a57600080fd5b60008060408385031215611c0857600080fd5b8235611c1381611bd3565b946020939093013593505050565b600080600060608486031215611c3657600080fd5b8335611c4181611bd3565b92506020840135611c5181611bd3565b929592945050506040919091013590565b600060208284031215611c7457600080fd5b8135611b4781611bd3565b60008060208385031215611c9257600080fd5b823567ffffffffffffffff80821115611caa57600080fd5b818501915085601f830112611cbe57600080fd5b813581811115611ccd57600080fd5b866020828501011115611cdf57600080fd5b60209290920196919550909350505050565b8015158114610c8a57600080fd5b60008060408385031215611d1257600080fd5b8235611d1d81611bd3565b91506020830135611d2d81611cf1565b809150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b60008060008060808587031215611d7d57600080fd5b8435611d8881611bd3565b93506020850135611d9881611bd3565b925060408501359150606085013567ffffffffffffffff80821115611dbc57600080fd5b818701915087601f830112611dd057600080fd5b813581811115611de257611de2611d38565b604051601f82017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0908116603f01168101908382118183101715611e2857611e28611d38565b816040528281528a6020848701011115611e4157600080fd5b82602086016020830137600060208483010152809550505050505092959194509250565b60008060408385031215611e7857600080fd5b8235611e8381611bd3565b91506020830135611d2d81611bd3565b600181811c90821680611ea757607f821691505b602082108103611ee0577f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b50919050565b600060208284031215611ef857600080fd5b8151611b4781611cf1565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b8082018082111561050457610504611f03565b600060208284031215611f5757600080fd5b8151611b4781611bd3565b8181038181111561050457610504611f03565b601f8211156113a957600081815260208120601f850160051c81016020861015611f9c5750805b601f850160051c820191505b81811015611fbb57828155600101611fa8565b505050505050565b67ffffffffffffffff831115611fdb57611fdb611d38565b611fef83611fe98354611e93565b83611f75565b6000601f841160018114612041576000851561200b5750838201355b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600387901b1c1916600186901b1783556120d7565b6000838152602090207fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0861690835b828110156120905786850135825560209485019460019092019101612070565b50868210156120cb577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff60f88860031b161c19848701351681555b505060018560011b0183555b505050505056fea2646970667358221220fd50414303320f1fe02cacbc6dcd19476fccaa8a683049682bcfa68d840cb72c64736f6c63430008110033";

type DegenNFTConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: DegenNFTConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class DegenNFT__factory extends ContractFactory {
  constructor(...args: DegenNFTConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
    this.contractName = "DegenNFT";
  }

  override deploy(
    _addressProvider: PromiseOrValue<string>,
    _name: PromiseOrValue<string>,
    _symbol: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<DegenNFT> {
    return super.deploy(
      _addressProvider,
      _name,
      _symbol,
      overrides || {}
    ) as Promise<DegenNFT>;
  }
  override getDeployTransaction(
    _addressProvider: PromiseOrValue<string>,
    _name: PromiseOrValue<string>,
    _symbol: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(
      _addressProvider,
      _name,
      _symbol,
      overrides || {}
    );
  }
  override attach(address: string): DegenNFT {
    return super.attach(address) as DegenNFT;
  }
  override connect(signer: Signer): DegenNFT__factory {
    return super.connect(signer) as DegenNFT__factory;
  }
  static readonly contractName: "DegenNFT";

  public readonly contractName: "DegenNFT";

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): DegenNFTInterface {
    return new utils.Interface(_abi) as DegenNFTInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): DegenNFT {
    return new Contract(address, _abi, signerOrProvider) as DegenNFT;
  }
}
