async function runProof() {
  const circuit = document.getElementById("circuitSelect").value;
  const output = document.getElementById("output");

  try {
    const vkey = await loadJSON(document.getElementById("vkeyFile"), `${circuit}_verification_key.json`);
    const proof = await loadJSON(document.getElementById("proofFile"), `${circuit}_proof.json`);
    const publicSignals = await loadJSON(document.getElementById("publicFile"), `${circuit}_public.json`);

    const verified = await snarkjs.groth16.verify(vkey, publicSignals, proof);

    if (verified) {
      output.textContent = ` Proof is valid for circuit: ${circuit}\nPublic Inputs: ${JSON.stringify(publicSignals)}`;
      output.className = "success";
    } else {
      output.textContent = ` Proof is invalid for circuit: ${circuit}`;
      output.className = "error";
    }
  } catch (e) {
    console.error(e);
    output.textContent = " Error loading files or verifying proof. Please ensure correct JSON structure and matching files.";
    output.className = "error";
  }
}

async function loadJSON(fileInput, fallback) {
  if (fileInput.files.length > 0) {
    const text = await fileInput.files[0].text();
    return JSON.parse(text);
  } else {
    return fetch(fallback).then(res => res.json());
  }
}
