/*
 * Copyright (c) 2022. Gearbox
 */
import { CMConfig, PoolConfig } from "../core/pool";
import { mainnetCreditManagerV3s as mcm } from "./creditManagers";
import { mainnetPools as mp } from "./pools";

export const mainnetCreditManagerV3s: Array<CMConfig> = mcm;
export const mainnetPools: Array<PoolConfig> = mp;
