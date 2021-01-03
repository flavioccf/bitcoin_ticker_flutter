import 'package:bitcoin_ticker_flutter/services/currency_convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  CurrencyConversion convert = CurrencyConversion();
  List<Widget> bitCoins = [
    Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 BTC = ? 0',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 500,
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: ListView.builder(
                itemCount: bitCoins.length,
                itemBuilder: (context, index) {
                  return bitCoins[index];
                },
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (String cur in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(cur),
        value: cur,
      );
      items.add(item);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: items,
        onChanged: (value) async {
          selectedCurrency = value;
          dynamic conversions =
              await convert.getCurrencyConversion(selectedCurrency);
          bitCoins.clear();
          for (dynamic bitcoin in conversions) {
            print(bitcoin);
            String curUrl = bitcoin['logo_url'];
            String currency = bitcoin['currency'];
            String price = bitcoin['price'];
            Card bitcoinConv = Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.network(
                        curUrl,
                        placeholderBuilder: (BuildContext context) => Container(
                            padding: EdgeInsets.all(30.0),
                            child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $currency = $price $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
            bitCoins.add(bitcoinConv);
            print(bitCoins);
          }
          setState(() {});
        });
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }
}
