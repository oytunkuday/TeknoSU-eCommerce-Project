import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreditCard with ChangeNotifier {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  CreditCard(
      {required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvvCode});
}

class CreditCardInstance with ChangeNotifier {
  CreditCard _creditCard = CreditCard(
      cardNumber: '', expiryDate: '', cardHolderName: '', cvvCode: '');

  CreditCard get creditCard {
    return _creditCard;
  }

  void setCreditCard(
      {String cardNumber = "",
      String expiryDate = "",
      String cardHolderName = "",
      String cvvCode = ""}) {
    CreditCard loadedCard = CreditCard(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode);
    _creditCard = loadedCard;
  }
}
