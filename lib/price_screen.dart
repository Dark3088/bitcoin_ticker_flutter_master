import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> newList = [];
    for (String item in currenciesList)
      newList.add(DropdownMenuItem(child: Text(item), value: item));

    return DropdownButton(
      value: currentCurrency,
      items: newList,
      onChanged: (value) {
        setState(() {
          currentCurrency = value;
          getCryptoDetails(value);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCryptoDetails('USD');
  }

  Map<String, String> cryptoValues = {};
  bool isLoading = false;

  void getCryptoDetails(String value) async {
    cryptoValues =
        await CoinData().getAllCryptoExchangeFor(selectedCurrency: value);

    setState(() => isLoading = false);
  }

  CupertinoPicker iOSPicker() {
    List<Text> newList = [];
    for (String item in currenciesList) newList.add(Text(item));

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(
            () {
              currentCurrency = currenciesList[selectedIndex];
              getCryptoDetails(currenciesList[selectedIndex]);
            },
          );
        },
        children: newList);
  }

  String currentCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                value: isLoading ? '?' : cryptoValues['BTC'] ?? '?',
                selectedCurrency: currentCurrency,
                cryptoCurrency: "BTC",
              ),
              CryptoCard(
                value: isLoading ? '?' : cryptoValues['ETH'] ?? '?',
                selectedCurrency: currentCurrency,
                cryptoCurrency: "ETH",
              ),
              CryptoCard(
                value: isLoading ? '?' : cryptoValues['LTC'] ?? '?',
                selectedCurrency: currentCurrency,
                cryptoCurrency: "LTC",
              ),
            ],
          ),
          SizedBox(height: 300.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: 150.0,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightBlue,
                  child: Platform.isIOS ? iOSPicker() : androidDropdown()),
            ],
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
