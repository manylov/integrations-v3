/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  ICreditFacadeV2,
  ICreditFacadeV2Interface,
} from "../../ICreditFacade.sol/ICreditFacadeV2";

const _abi = [
  {
    inputs: [],
    name: "params",
    outputs: [
      {
        internalType: "uint128",
        name: "maxBorrowedAmountPerBlock",
        type: "uint128",
      },
      {
        internalType: "bool",
        name: "isIncreaseDebtForbidden",
        type: "bool",
      },
      {
        internalType: "uint40",
        name: "expirationDate",
        type: "uint40",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

export class ICreditFacadeV2__factory {
  static readonly abi = _abi;
  static createInterface(): ICreditFacadeV2Interface {
    return new utils.Interface(_abi) as ICreditFacadeV2Interface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ICreditFacadeV2 {
    return new Contract(address, _abi, signerOrProvider) as ICreditFacadeV2;
  }
}
