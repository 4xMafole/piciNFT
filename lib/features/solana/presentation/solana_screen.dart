import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/core/utils/app_strings.dart';

import '../../../core/presentation/widgets/custom_text_field.dart';
import '../domain/NFT_attribute_entity.dart';
import '../domain/metadata_NFT.dart';
import 'cubit/phantom_wallet_cubit.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController symbolController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController labelController1 = TextEditingController();
  TextEditingController valueController1 = TextEditingController();
  TextEditingController labelController2 = TextEditingController();
  TextEditingController valueController2 = TextEditingController();
  TextEditingController labelController3 = TextEditingController();
  TextEditingController valueController3 = TextEditingController();

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
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.03),
              ),
              _buildMainData(context),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.03),
              ),
              const Center(
                child: Text(AppStrings.attributeString,
                    style: TextStyle(color: Colors.black)),
              ),
              _buildAttributes(context),
              _buildCreateButton(context),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.03),
              ),

              //ANCHOR - Extra Data timeline
              //ANCHOR - Create and Build buttons
            ]),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return BlocConsumer<Web3StorageCubit, Web3StorageState>(
        bloc: context.read<Web3StorageCubit>(),
        listener: (context, state) {
          if (state is Web3StorageFailure) {
            // _showSnackBar(context, state.errorMessage, 'error');
            print(state.message);
          }
          if (state is Web3StorageImageSuccess) {
            // _showSnackBar(context, state.dataUrl, 'success');
            print(state.data);
          }
        },
        builder: (context, state) {
          if (state is Web3StorageDataInProgress) {
            return const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            );
          } else if (state is Web3StorageDataSuccess) {
            return _buildMintButton(context, state.data);
          }

          return BlocBuilder(
              bloc: context.read<Web3StorageCubit>(),
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * (0.6),
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (state is Web3StorageImageSuccess) {
                        context.read<Web3StorageCubit>().uploadData(
                          image: state.data,
                          name: nameController.text.trim(),
                          description: descController.text.trim(),
                          attributes: [
                            NFTAttributeEntity(
                              traitType: labelController1.text.trim(),
                              value: valueController1.text.trim(),
                            ),
                            NFTAttributeEntity(
                              traitType: labelController2.text.trim(),
                              value: valueController2.text.trim(),
                            ),
                            NFTAttributeEntity(
                              traitType: labelController3.text.trim(),
                              value: valueController3.text.trim(),
                            ),
                          ],
                        );
                      } else {
                        // _showSnackBar(context, addImageSnack, 'error');
                        if (kDebugMode) {
                          print("Add Image");
                        }
                      }
                    },
                    child: const Text(AppStrings.createNFT),
                  ),
                );
              });
        });
  }

  Column _buildMainData(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
            controller: nameController, label: AppStrings.nameFieldString),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
        CustomTextField(
            controller: symbolController, label: AppStrings.symbolFieldString),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
        CustomTextField(
            controller: descController, label: AppStrings.descriptionString),
      ],
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

  Widget _buildAttributes(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
        _buildAttributeTextFieldContainer(context,
            labelController: labelController1,
            valueController: valueController1,
            labelType: AppStrings.traitTypeString,
            value: AppStrings.traitValueString),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
        _buildAttributeTextFieldContainer(context,
            labelController: labelController2,
            valueController: valueController2,
            labelType: AppStrings.traitTypeString,
            value: AppStrings.traitValueString),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
        _buildAttributeTextFieldContainer(context,
            labelController: labelController3,
            valueController: valueController3,
            labelType: AppStrings.traitTypeString,
            value: AppStrings.traitValueString),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.03),
        ),
      ],
    );
  }

  Widget _buildAttributeTextFieldContainer(BuildContext context,
      {TextEditingController? labelController,
      TextEditingController? valueController,
      required String labelType,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade200,
          ),
          width: MediaQuery.of(context).size.width * (0.4),
          height: 60.0,
          alignment: Alignment.center,
          child: TextField(
            controller: labelController,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: labelType,
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: Colors.grey.shade400, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.height * (0.03),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade200,
          ),
          width: MediaQuery.of(context).size.width * (0.4),
          height: 60.0,
          alignment: Alignment.center,
          child: TextField(
            controller: valueController,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: value,
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: Colors.grey.shade400, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMintButton(BuildContext context, String dataUrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (0.6),
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                context.read<PhantomWalletCubit>().mintingNFT(
                      MetadataNFT(
                        name: nameController.text.trim(),
                        symbol: symbolController.text.trim(),
                        dataUri: dataUrl,
                      ),
                    );
              },
              child: const Text(AppStrings.mintNFT),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          BlocBuilder(
              bloc: context.read<PhantomWalletCubit>(),
              builder: (context, state) {
                if (state is PhantomWalletInProgress) {
                  return const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PhantomWalletSignAndSendTransaction) {
                  if (state.signCounter == 5) {
                    return const Text(
                      AppStrings.mintSuccessString,
                      style: TextStyle(color: Colors.green),
                    );
                  }
                } else if (state is PhantomWalletFailure) {
                  if (state.errorMessage.contains(AppStrings.walletConnectError)) {
                    return TextButton(
                      onPressed: () =>
                          context.read<PhantomWalletCubit>().connectWallet(),
                      child: Text(
                        AppStrings.walletReconnectingString,
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    );
                  } else {
                    return Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.red.shade200),
                    );
                  }
                }
                return const SizedBox();
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
