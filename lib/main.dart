import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safetravel/screens/Weather_screen.dart';
 // Import the translate screen
import 'package:safetravel/screens/FeedScreen.dart';
import 'package:safetravel/screens/currency_conversion_screen.dart';
import 'package:safetravel/screens/instant_translation_screen.dart';
import 'models/post.dart';
import 'providers/comments_provider.dart';
import 'providers/posts_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/advice_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/travel_tools_screen.dart';
import 'screens/post_detail_screen.dart';

void main() {
  runApp(SafeTravelApp());
}

class SafeTravelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PostsProvider()),
        ChangeNotifierProvider(create: (ctx) => CommentsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF162447),
          hintColor: Color(0xFF4077FF),
        ),
        home: SplashScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/alerts': (context) => AlertsScreen(),
          '/advice': (context) => AdviceScreen(),
          '/emergency': (context) => EmergencyScreen(),
          '/feed': (context) => FeedScreen(),
          '/travel-tools': (context) => TravelToolsScreen(),
          '/weather': (context) => WeatherScreen(),         // Define the route for the Weather screen
          '/currency': (context) => CurrencyConversionScreen(),
          '/translate': (context) => InstantTranslationScreen(),
            // Define the route for the Instant Translation screen
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/post-detail') {
            final post = settings.arguments as Post;
            return MaterialPageRoute(
              builder: (context) {
                return PostDetailScreen(post: post);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
