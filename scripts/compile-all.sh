#!/bin/bash
mkdir -p build
for f in circuits/*.circom; do
  circom "$f" --r1cs --wasm --sym -o build/
done
echo "Circuits compiled."