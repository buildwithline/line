import { createPublicClient, createWalletClient, custom, http } from "viem";
import { mainnet } from "viem/chains";

// Create a Viem client
const client = createPublicClient({
  chain: mainnet,
  transport: http(),
});

// Function to request wallet connection
export async function requestWalletConnection() {
  if (typeof window.ethereum !== "undefined") {
    const provider = window.ethereum;
    await provider.request({ method: "eth_requestAccounts" });

    const walletClient = createWalletClient({
      chain: mainnet,
      transport: custom(provider),
    });

    return walletClient;
  } else {
    throw new Error("No Ethereum provider found");
  }
}

// Function to transfer funds between sender and receiver wallets
export async function transferFunds(sender, receiver, amount) {
  if (sender.balance < amount) {
    throw new Error("Insufficient funds");
  }

  // Deduct the amount from the sender's balance
  sender.balance -= amount;

  // Add the amount to the receiver's balance
  receiver.balance += amount;

  // Return the updated wallets
  return {
    sender,
    receiver,
  };
}

// Function to send a transfer from one wallet to another
export async function sendContributionTransaction(
  senderAddress,
  recipientAddress,
  amount,
  walletClient
) {
  try {
    // Convert amount to the correct format for Viem (Wei)
    const amountInWei = BigInt(amount * 10 ** 18); // Convert ETH to Wei

    // Create the transaction
    const tx = await walletClient.sendTransaction({
      to: recipientAddress,
      value: amountInWei,
    });

    return tx;
  } catch (error) {
    console.error("Error sending transaction:", error);
    throw new Error("Transaction failed");
  }
}
