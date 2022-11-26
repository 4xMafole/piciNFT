import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/core/routes.dart';
import 'package:pici_nft/features/solana/data/repository/phantom_wallet_repository.dart';
import 'package:pici_nft/features/solana/data/repository/web3storage_repository.dart';
import 'package:pici_nft/features/solana/presentation/cubit/phantom_wallet_cubit.dart';
import 'package:pici_nft/features/solana/presentation/cubit/web3storage_cubit.dart';

import 'utils/ui_utils.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));

  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => PhantomWalletCubit(PhantomWalletRepository())),
          //Provide global providers
          BlocProvider(create: (_) => Web3StorageCubit(Web3StorageRepository()))
        ],
        child: Builder(
          builder: ((context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: Routes.home,
                navigatorKey: UiUtils.navigatorKey,
                onGenerateRoute: Routes.onGenerateRouted,
              )),
        ));
  }
}
