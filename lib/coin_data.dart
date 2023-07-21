import 'package:bitcoin_ticker/services/network_helper.dart';
import 'package:flutter/material.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getAllCryptoExchangeFor({String selectedCurrency = 'USD'}) async {
    NetworkHandler networkHelper = NetworkHandler();
    Map<String, String> currencyList = {};
    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () async {
          for (String crypto in cryptoList) {
            Uri url = Uri(
              scheme: 'https',
              host: 'rest.coinapi.io',
              path: '/v1/exchangerate/$crypto',
              queryParameters: {
                'apikey': APIKEY,
                'invert': 'false',
                'filter_asset_id': selectedCurrency,
              },
            );
            var result = await networkHelper.getData(url);
            String exchangeRate = result['rates'][0]['rate'].toStringAsFixed(0);
            currencyList[crypto] = exchangeRate;

            debugPrint('Crypto request: ${result}');
            debugPrint('Crypto value: ${exchangeRate}');
          }
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
    ;

    return currencyList;
  }
}
