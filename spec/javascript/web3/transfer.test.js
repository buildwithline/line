import { transferFunds } from "../../../app/javascript/web3/transfer";

describe("Wallet Transfer", () => {
  let mockSenderWallet, mockReceiverWallet, mockAmount;

  beforeEach(() => {
    mockSenderWallet = {
      address: "0xSenderAddress",
      balance: 100,
    };
    mockReceiverWallet = {
      address: "0xReceiverAddress",
      balance: 50,
    };
    mockAmount = 20;
  });

  it("should transfer funds between wallets successfully", async () => {
    const result = await transferFunds(
      mockSenderWallet,
      mockReceiverWallet,
      mockAmount
    );

    expect(result.sender.balance).toBe(80);
    expect(result.receiver.balance).toBe(70);
  });

  it("should fail if sender has insufficient funds", async () => {
    mockSenderWallet.balance = 10;

    try {
      await transferFunds(mockSenderWallet, mockReceiverWallet, mockAmount);
    } catch (error) {
      expect(error.message).toBe("Insufficient funds");
    }
  });
});
