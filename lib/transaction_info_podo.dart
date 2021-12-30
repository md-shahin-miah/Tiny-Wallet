class TransactionInfo {
  String amount;
  String id;
  String cardNumber;
  String cvv;
  String expireMY;
  String created;
  String reference;
  String merchantId;
  String status;

  TransactionInfo(
      this.amount,
      this.id,
      this.cardNumber,
      this.cvv,
      this.expireMY,
      this.created,
      this.reference,
      this.merchantId,
      this.status);
}
