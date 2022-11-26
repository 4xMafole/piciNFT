import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/core/utils/app_strings.dart';

import 'cubit/web3storage_cubit.dart';

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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //!SECTION Use timelines for this app
              //ANCHOR - Image Timeline
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.01),
              ),
              Center(
                child: _buildUploadImageContainer(context),
              ),

              //ANCHOR - Extra Data timeline
              //ANCHOR - Create and Build buttons
            ]),
      ),
    );
  }

  _buildUploadImageContainer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (0.5),
      height: MediaQuery.of(context).size.width * (0.5),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (0.5),
              height: MediaQuery.of(context).size.width * (0.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                shape: BoxShape.rectangle,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(constraints.maxWidth * (0.15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<Web3StorageCubit>().getImageFromGallery(),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(
                              constraints.maxWidth * (0.15))),
                      height: constraints.maxWidth * (0.3),
                      width: constraints.maxWidth * (0.3),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).primaryColor,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
