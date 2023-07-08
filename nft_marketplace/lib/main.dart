import 'package:flutter/material.dart';
import 'package:nft_marketplace/features/article/presentation/index.dart';
import 'package:nft_marketplace/features/contract/application/nft_provider.dart';
import 'package:nft_marketplace/features/create_article/presentation/index.dart';
import 'package:nft_marketplace/features/home/presentation/index.dart';
import 'package:nft_marketplace/features/landing/presentation/index.dart';
import 'package:nft_marketplace/features/publish_article/presentation/index.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NftProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing(),
        '/home': (context) => const Home(),
        '/article': (context) => const Article(),
        '/createArticle': (context) => const CreateArticle(),
        '/publishArticle': (context) => const PublishArticle(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
