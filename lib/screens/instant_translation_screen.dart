import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class InstantTranslationScreen extends StatefulWidget {
  @override
  _InstantTranslationScreenState createState() => _InstantTranslationScreenState();
}

class _InstantTranslationScreenState extends State<InstantTranslationScreen> {
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  String _inputText = '';
  String _translatedText = '';
  bool _isLoading = false;
  bool _isListening = false;

  // Initialize _speech as nullable and lazy initialize
  stt.SpeechToText? _speech;

  final _languages = {
    'af': 'Afrikaans',
    'sq': 'Albanian',
    'am': 'Amharic',
    'ar': 'Arabic',
    'hy': 'Armenian',
    'az': 'Azerbaijani',
    'eu': 'Basque',
    'be': 'Belarusian',
    'bn': 'Bengali',
    'bs': 'Bosnian',
    'bg': 'Bulgarian',
    'ca': 'Catalan',
    'ceb': 'Cebuano',
    'zh': 'Chinese',
    'hr': 'Croatian',
    'cs': 'Czech',
    'da': 'Danish',
    'nl': 'Dutch',
    'en': 'English',
    'eo': 'Esperanto',
    'et': 'Estonian',
    'fi': 'Finnish',
    'fr': 'French',
    'gl': 'Galician',
    'ka': 'Georgian',
    'de': 'German',
    'el': 'Greek',
    'gu': 'Gujarati',
    'ht': 'Haitian Creole',
    'he': 'Hebrew',
    'hi': 'Hindi',
    'hu': 'Hungarian',
    'is': 'Icelandic',
    'id': 'Indonesian',
    'it': 'Italian',
    'ja': 'Japanese',
    'kn': 'Kannada',
    'ko': 'Korean',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'mk': 'Macedonian',
    'ml': 'Malayalam',
    'ms': 'Malay',
    'mr': 'Marathi',
    'ne': 'Nepali',
    'no': 'Norwegian',
    'fa': 'Persian',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'pa': 'Punjabi',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sr': 'Serbian',
    'si': 'Sinhala',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'es': 'Spanish',
    'sw': 'Swahili',
    'sv': 'Swedish',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    'vi': 'Vietnamese',
    'cy': 'Welsh',
    'xh': 'Xhosa',
    'yi': 'Yiddish',
    'zu': 'Zulu'
  };

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    // Initialize _speech and handle any errors
    _speech = stt.SpeechToText();
    bool available = await _speech!.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (!available) {
      print('The user has denied the use of speech recognition.');
    }
  }

  Future<void> _translateText() async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://api.mymemory.translated.net/get?q=$_inputText&langpair=$_sourceLanguage|$_targetLanguage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _translatedText = data['responseData']['translatedText'];
        });
      } else {
        print('Failed to load translation');
      }
    } catch (error) {
      print('Failed to load translation: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _listen() async {
    // Lazy initialization of _speech if it's null
    if (_speech == null) {
      _speech = stt.SpeechToText();
      _initializeSpeech(); // Ensure it initializes but does not await it
    }

    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(
          onResult: (val) => setState(() {
            _inputText = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instant Translation'),
        backgroundColor: Color(0xFF162447),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown(
              'From Language',
              _sourceLanguage,
                  (value) => setState(() => _sourceLanguage = value!),
            ),
            SizedBox(height: 20),
            _buildDropdown(
              'To Language',
              _targetLanguage,
                  (value) => setState(() => _targetLanguage = value!),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
              controller: TextEditingController(text: _inputText),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Translate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4077FF),
              ),
            ),
            SizedBox(height: 20),
            if (_translatedText.isNotEmpty)
              Text(
                _translatedText,
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

  Widget _buildDropdown(String label, String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: currentValue,
      items: _languages.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
