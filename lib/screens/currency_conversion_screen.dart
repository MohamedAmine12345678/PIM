import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _filteredFromCurrencies = _currencies;
    _filteredToCurrencies = _currencies;

    // Initialize the video background
    _controller = VideoPlayerController.asset('assets/7579667-uhd_2160_4096_25fps.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterCurrencies(String input, bool isFromCurrency) {
    setState(() {
      if (isFromCurrency) {
        _filteredFromCurrencies = _currencies
            .where((currency) => currency.toLowerCase().startsWith(input.toLowerCase()))
            .toList();
        if (!_filteredFromCurrencies.contains(_fromCurrency)) {
          _fromCurrency = _filteredFromCurrencies.isNotEmpty ? _filteredFromCurrencies.first : '';
        }
      } else {
        _filteredToCurrencies = _currencies
            .where((currency) => currency.toLowerCase().startsWith(input.toLowerCase()))
            .toList();
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
      extendBodyBehindAppBar: true, // Extend the body behind the transparent AppBar
      appBar: AppBar(
        title: Text(
          'Currency Conversion',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        backgroundColor: Colors.black.withOpacity(0.3), // Transparent black header
        elevation: 0,
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              } else {
                return Container(color: Colors.black);
              }
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildClearTextField('Search From Currency', (value) => _filterCurrencies(value, true)),
                    SizedBox(height: 20),
                    _buildClearDropdown('From Currency', _filteredFromCurrencies, _fromCurrency, (value) {
                      setState(() {
                        _fromCurrency = value!;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildClearTextField('Search To Currency', (value) => _filterCurrencies(value, false)),
                    SizedBox(height: 20),
                    _buildClearDropdown('To Currency', _filteredToCurrencies, _toCurrency, (value) {
                      setState(() {
                        _toCurrency = value!;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildClearTextField('Amount', (value) {
                      setState(() {
                        _inputAmount = double.tryParse(value) ?? 1.0;
                      });
                    }, keyboardType: TextInputType.number),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _convertCurrency,
                      child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Convert'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent button
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
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearTextField(String label, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.85)), // Brighter transparent label
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)), // Transparent border
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2), // Lighter transparent background
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      onChanged: onChanged,
    );
  }

  Widget _buildClearDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.85)), // Brighter transparent label
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)), // Transparent border
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2), // Lighter transparent background
      ),
      dropdownColor: Colors.black.withOpacity(0.8), // Set dropdown background color
      value: value,
      items: items.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(
            currency,
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
