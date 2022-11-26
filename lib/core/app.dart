import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/core/routes.dart';
import 'package:pici_nft/features/solana/data/repository/web3storage_repository.dart';
import 'package:pici_nft/features/solana/presentation/cubit/web3storage_cubit.dart';

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
          //Provide global providers
          BlocProvider(create: (_) => Web3StorageCubit(Web3StorageRepository()))
        ],
        child: Builder(
          builder: ((context) => const MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: Routes.home,
                onGenerateRoute: Routes.onGenerateRouted,
              )),
        ));
  }
}
