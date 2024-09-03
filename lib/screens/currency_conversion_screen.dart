import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConversionScreen extends StatefulWidget {
  @override
  _CurrencyConversionScreenState createState() => _CurrencyConversionScreenState();
}

class _CurrencyConversionScreenState extends State<CurrencyConversionScreen> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _inputAmount = 1.0;
  double? _convertedAmount;
  bool _isLoading = false;

  final _apiKey = 'f19694d21959874a32c68965'; // Your ExchangeRateAPI key

  List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR', 'BRL', 'MXN', 'RUB', 'ZAR',
    'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN',
    'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CDF',
    'CHE', 'CHW', 'CLF', 'CLP', 'COP', 'COU', 'CRC', 'CUC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK',
    'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'FJD', 'FKP', 'FOK', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD',
    'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'IQD', 'IRR',
    'ISK', 'JEP', 'JMD', 'JOD', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT',
    'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP',
    'MRU', 'MUR', 'MVR', 'MWK', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR',
    'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RWF', 'SAR', 'SBD',
    'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLL', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL',
    'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TZS', 'UAH', 'UGX', 'UYI', 'UYU',
    'UYW', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZMW',
    'ZWL'
  ];

  List<String> _filteredFromCurrencies = [];
  List<String> _filteredToCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredFromCurrencies = _currencies;
    _filteredToCurrencies = _currencies;
  }

  void _filterCurrencies(String input, bool isFromCurrency) {
    setState(() {
      if (isFromCurrency) {
        _filteredFromCurrencies = _currencies.where((currency) =>
            currency.toLowerCase().startsWith(input.toLowerCase())).toList();
        // Ensure the selected currency is in the list
        if (!_filteredFromCurrencies.contains(_fromCurrency)) {
          _fromCurrency = _filteredFromCurrencies.isNotEmpty ? _filteredFromCurrencies.first : '';
        }
      } else {
        _filteredToCurrencies = _currencies.where((currency) =>
            currency.toLowerCase().startsWith(input.toLowerCase())).toList();
        // Ensure the selected currency is in the list
        if (!_filteredToCurrencies.contains(_toCurrency)) {
          _toCurrency = _filteredToCurrencies.isNotEmpty ? _filteredToCurrencies.first : '';
        }
      }
    });
  }

  Future<void> _convertCurrency() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        'https://v6.exchangerate-api.com/v6/$_apiKey/pair/$_fromCurrency/$_toCurrency/$_inputAmount';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _convertedAmount = data['conversion_result'];
        });
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Conversion'),
        backgroundColor: Color(0xFF162447),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search From Currency',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterCurrencies(value, true);
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'From Currency',
                border: OutlineInputBorder(),
              ),
              value: _filteredFromCurrencies.contains(_fromCurrency) ? _fromCurrency : null,
              items: _filteredFromCurrencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fromCurrency = value!;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search To Currency',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterCurrencies(value, false);
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'To Currency',
                border: OutlineInputBorder(),
              ),
              value: _filteredToCurrencies.contains(_toCurrency) ? _toCurrency : null,
              items: _filteredToCurrencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _toCurrency = value!;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inputAmount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4077FF),
              ),
            ),
            SizedBox(height: 20),
            if (_convertedAmount != null)
              Text(
                '$_inputAmount $_fromCurrency = $_convertedAmount $_toCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF162447),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
