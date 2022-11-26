import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pici_nft/core/utils/app_dimensions.dart';
import 'package:pici_nft/core/utils/app_strings.dart';

import '../../../core/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<dynamic> route(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text(AppStrings.appTitle),
      )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingAll),
          margin: const EdgeInsets.all(AppDimensions.marginAll),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildChainButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildChainButtons(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSolanaButton(context),
        ],
      ),
    );
  }

  _buildSolanaButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(Routes.solana),
        child: const Text(AppStrings.solanaChain),
      ),
    );
  }
}
