async function runProof() {
  const vkey = await fetch("verification_key.json").then(res => res.json());
  const proof = await fetch("proof.json").then(res => res.json());
  const publicSignals = await fetch("public.json").then(res => res.json());

  const res = await snarkjs.groth16.verify(vkey, publicSignals, proof);

  document.getElementById("output").textContent = res
    ? "✅ Proof is valid!"
    : "❌ Invalid proof!";
}