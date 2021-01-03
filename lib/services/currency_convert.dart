import 'package:bitcoin_ticker_flutter/services/networking.dart';

class CurrencyConversion {
  Future<dynamic> getCurrencyConversion(currency) async {
    const API_KEY = '17129b4f386e89977610b2efcfeb3534';
    String url =
        'https://api.nomics.com/v1/currencies/ticker?key=$API_KEY&ids=BTC,ETH,LTC&interval=1d,30d&convert=$currency';
    NetworkHelper networkHelper = NetworkHelper(url);

    var currencyData = await networkHelper.getData().catchError((e) {
      print(e);
      return null;
    });
    return currencyData;
  }
}
