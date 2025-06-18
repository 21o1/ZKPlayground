#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <circuit_name>"
  exit 1
fi
CIRCUIT=$1
cd build
snarkjs groth16 setup ${CIRCUIT}.r1cs ../powersOfTau28_hez_final_10.ptau ${CIRCUIT}_setup.zkey
snarkjs zkey export verificationkey ${CIRCUIT}_setup.zkey ${CIRCUIT}_vkey.json
snarkjs wtns calculate ${CIRCUIT}.wasm ../input.json ${CIRCUIT}.wtns
snarkjs groth16 prove ${CIRCUIT}_setup.zkey ${CIRCUIT}.wtns proof.json public.json