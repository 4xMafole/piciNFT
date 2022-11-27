import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/core/utils/app_dimensions.dart';
import 'package:pici_nft/core/utils/app_strings.dart';
import 'package:pici_nft/features/solana/presentation/cubit/phantom_wallet_cubit.dart';

import '../../../core/routes.dart';
import '../../../core/utils/ui_utils.dart';

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
    watchWalletStates(context.read<PhantomWalletCubit>().state);

    super.initState();
  }

  void watchWalletStates(PhantomWalletState state) {
    if (state is PhantomWalletConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UiUtils.navigatorKey.currentState!.pushReplacementNamed(Routes.solana);
      });
    } else if (state is PhantomWalletSignAndSendTransaction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UiUtils.navigatorKey.currentState!.pop(context);
      });
    } else if (state is PhantomWalletFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UiUtils.navigatorKey.currentState!.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingAll),
          margin: const EdgeInsets.all(AppDimensions.marginAll),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                AppStrings.appTitle,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.1),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * (0.2),
              ),
              _buildChainButtons(context)
              // _buildChainButtons(context),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSolanaButton(context),
        ],
      ),
    );
  }

  _buildSolanaButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 50,
      child: ElevatedButton(
        onPressed: () => context.read<PhantomWalletCubit>().connectWallet(),
        child: const Text(AppStrings.solanaChain),
      ),
    );
  }
}
