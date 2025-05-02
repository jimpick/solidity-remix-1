---
title: "Specifications"
sidebar_position: 1
---

## Actors and methods supported

| Actor/method                             | Supported?               | Read-Only?         |
| :--------------------------------------- | :----------------------- | ------------------ |
| **Account**                              |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| PubkeyAddress                            | :heavy_multiplication_x: |                    |
| AuthenticateMessage                      | :heavy_check_mark:       | :heavy_check_mark: |
| UniversalReceiverHook                    | :heavy_check_mark:       |                    |
|                                          |                          |                    |
| **Cron**                                 |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| EpochTick                                | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Datacap Token**                        |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| Mint                                     | :heavy_multiplication_x: |                    |
| Destroy                                  | :heavy_multiplication_x: |                    |
| Name                                     | :heavy_check_mark:       | :heavy_check_mark: |
| Symbol                                   | :heavy_check_mark:       | :heavy_check_mark: |
| TotalSupply                              | :heavy_check_mark:       | :heavy_check_mark: |
| BalanceOf                                | :heavy_check_mark:       | :heavy_check_mark: |
| Transfer                                 | :heavy_check_mark:       |                    |
| TransferFrom                             | :heavy_check_mark:       |                    |
| IncreaseAllowance                        | :heavy_check_mark:       |                    |
| DecreaseAllowance                        | :heavy_check_mark:       |                    |
| RevokeAllowance                          | :heavy_check_mark:       |                    |
| Burn                                     | :heavy_check_mark:       |                    |
| BurnFrom                                 | :heavy_check_mark:       |                    |
| Allowance                                | :heavy_check_mark:       | :heavy_check_mark: |
|                                          |                          |                    |
| **Init**                                 |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| Exec                                     | :heavy_check_mark:       |                    |
| Exec4                                    | :heavy_check_mark:       |                    |
|                                          |                          |                    |
| **Market**                               |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| AddBalance                               | :heavy_check_mark:       |                    |
| WithdrawBalance                          | :heavy_check_mark:       |                    |
| PublishStorageDeals                      | :heavy_check_mark:       |                    |
| VerifyDealsForActivation                 | :heavy_multiplication_x: |                    |
| ActivateDeals                            | :heavy_multiplication_x: |                    |
| OnMinerSectorsTerminate                  | :heavy_multiplication_x: |                    |
| ComputeDataCommitment                    | :heavy_multiplication_x: |                    |
| CronTick                                 | :heavy_multiplication_x: |                    |
| GetBalance                               | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealDataCommitment                    | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealClient                            | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealProvider                          | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealLabel                             | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealTerm                              | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealEpochPrice                        | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealClientCollateral                  | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealProviderCollateral                | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealVerified                          | :heavy_check_mark:       | :heavy_check_mark: |
| GetDealActivation                        | :heavy_check_mark:       | :heavy_check_mark: |
|                                          |                          |                    |
| **Miner**                                |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| ControlAddresses                         | :heavy_multiplication_x: |                    |
| ChangeWorkerAddress                      | :heavy_check_mark:       |                    |
| ChangePeerID                             | :heavy_check_mark:       |                    |
| SubmitWindowedPoSt                       | :heavy_multiplication_x: |                    |
| PreCommitSector                          | :heavy_multiplication_x: |                    |
| ProveCommitSector                        | :heavy_multiplication_x: |                    |
| ExtendSectorExpiration                   | :heavy_multiplication_x: |                    |
| TerminateSectors                         | :heavy_multiplication_x: |                    |
| DeclareFaults                            | :heavy_multiplication_x: |                    |
| DeclareFaultsRecovered                   | :heavy_multiplication_x: |                    |
| OnDeferredCronEvent                      | :heavy_multiplication_x: |                    |
| CheckSectorProven                        | :heavy_multiplication_x: |                    |
| ApplyRewards                             | :heavy_multiplication_x: |                    |
| ReportConsensusFault                     | :heavy_multiplication_x: |                    |
| WithdrawBalance                          | :heavy_check_mark:       |                    |
| ConfirmSectorProofsValid                 | :heavy_multiplication_x: |                    |
| ChangeMultiaddrs                         | :heavy_check_mark:       |                    |
| CompactPartitions                        | :heavy_multiplication_x: |                    |
| CompactSectorNumbers                     | :heavy_multiplication_x: |                    |
| ConfirmUpdateWorkerKey                   | :heavy_multiplication_x: |                    |
| RepayDebt                                | :heavy_check_mark:       |                    |
| ChangeOwnerAddress                       | :heavy_check_mark:       |                    |
| DisputeWindowedPoSt                      | :heavy_multiplication_x: |                    |
| PreCommitSectorBatch                     | :heavy_multiplication_x: |                    |
| ProveCommitAggregate                     | :heavy_multiplication_x: |                    |
| ProveReplicaUpdates                      | :heavy_multiplication_x: |                    |
| PreCommitSectorBatch2                    | :heavy_multiplication_x: |                    |
| ProveReplicaUpdates2                     | :heavy_multiplication_x: |                    |
| ChangeBeneficiary                        | :heavy_check_mark:       |                    |
| GetBeneficiary                           | :heavy_check_mark:       | :heavy_check_mark: |
| ExtendSectorExpiration2                  | :heavy_multiplication_x: |                    |
| GetOwner                                 | :heavy_check_mark:       | :heavy_check_mark: |
| IsControllingAddress                     | :heavy_check_mark:       | :heavy_check_mark: |
| GetSectorSize                            | :heavy_check_mark:       | :heavy_check_mark: |
| GetVestingFunds                          | :heavy_check_mark:       | :heavy_check_mark: |
| GetAvailableBalance                      | :heavy_check_mark:       | :heavy_check_mark: |
| Read peer ID, multiaddr                  | :heavy_check_mark:       | :heavy_check_mark: |
| Read pre-commit deposit                  | :heavy_multiplication_x: |                    |
| Read initial pledge total                | :heavy_multiplication_x: |                    |
| Read fee debt                            | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Multisig**                             |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| Propose                                  | :heavy_check_mark:       |                    |
| Approve                                  | :heavy_check_mark:       |                    |
| Cancel                                   | :heavy_check_mark:       |                    |
| AddSigner                                | :heavy_check_mark:       |                    |
| RemoveSigner                             | :heavy_check_mark:       |                    |
| SwapSigner                               | :heavy_check_mark:       |                    |
| ChangeNumApprovalsThreshold              | :heavy_multiplication_x: |                    |
| LockBalance                              | :heavy_check_mark:       |                    |
| UniversalReceiverHook                    | :heavy_check_mark:       |                    |
| List signers and threshold               | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Payment Channel**                      |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| UpdateChannelState                       | :heavy_multiplication_x: |                    |
| Settle                                   | :heavy_multiplication_x: |                    |
| Collect                                  | :heavy_multiplication_x: |                    |
| List from/to                             | :heavy_multiplication_x: |                    |
| Get redeemed amount                      | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Power**                                |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| CreateMiner                              | :heavy_check_mark:       |                    |
| UpdateClaimedPower                       | :heavy_multiplication_x: |                    |
| EnrollCronEvent                          | :heavy_multiplication_x: |                    |
| OnEpochTickEnd                           | :heavy_multiplication_x: |                    |
| UpdatePledgeTotal                        | :heavy_multiplication_x: |                    |
| SubmitPoRepForBulkVerify                 | :heavy_multiplication_x: |                    |
| CurrentTotalPower                        | :heavy_multiplication_x: |                    |
| NetworkRawPower                          | :heavy_check_mark:       | :heavy_check_mark: |
| MinerRawPower                            | :heavy_check_mark:       | :heavy_check_mark: |
| Get miner count, consensus count         | :heavy_check_mark:       | :heavy_check_mark: |
| Compute pledge collateral for new sector | :heavy_multiplication_x: |                    |
| Get network bytes committed?             | :heavy_multiplication_x: |                    |
| Get network total pledge collateral?     | :heavy_multiplication_x: |                    |
| Get network epoch QA power               | :heavy_multiplication_x: |                    |
| Get network epoch pledge collateral      | :heavy_multiplication_x: |                    |
| Get miner's QA power                     | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Reward**                               |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| AwardBlockReward                         | :heavy_multiplication_x: |                    |
| ThisEpochReward                          | :heavy_multiplication_x: |                    |
| UpdateNetworkKPI                         | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **System**                               |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
|                                          |                          |                    |
| **Verified Registry**                    |                          |                    |
| Constructor                              | :heavy_multiplication_x: |                    |
| AddVerifier                              | :heavy_multiplication_x: |                    |
| RemoveVerifier                           | :heavy_multiplication_x: |                    |
| AddVerifiedClient                        | :heavy_check_mark:       |                    |
| RemoveVerifiedClientDataCap              | :heavy_multiplication_x: |                    |
| RemoveExpiredAllocations                 | :heavy_check_mark:       |                    |
| ClaimAllocations                         | :heavy_multiplication_x: |                    |
| GetClaims                                | :heavy_check_mark:       | :heavy_check_mark: |
| ExtendClaimTerms                         | :heavy_check_mark:       |                    |
| RemoveExpiredClaims                      | :heavy_check_mark:       |                    |
| UniversalReceiverHook                    | :heavy_check_mark:       |                    |
| List/get allocations                     | :heavy_multiplication_x: |                    |
| List claims                              | :heavy_multiplication_x: |                    |
| List/check verifiers                     | :heavy_multiplication_x: |                    |
