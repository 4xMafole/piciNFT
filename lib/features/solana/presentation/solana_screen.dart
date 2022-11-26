import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pici_nft/core/utils/app_strings.dart';

class SolanaScreen extends StatefulWidget {
  const SolanaScreen({super.key});

  static Route<dynamic> route(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (_) => const SolanaScreen());
  }

  @override
  State<SolanaScreen> createState() => _SolanaScreenState();
}

class _SolanaScreenState extends State<SolanaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(AppStrings.solanaAppTitle),
        ),
      ),
      body: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(),
      child: Column(children: [
        //!SECTION Use timelines for this app
        //ANCHOR - Image Timeline
        //ANCHOR - Extra Data timeline
        //ANCHOR - Create and Build buttons
      ]),
      ),

    );
  }
}
