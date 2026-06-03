import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_loop/core/helper/show_custom_dialog.dart';
import 'package:green_loop/core/helper/show_qr_dialog.dart';
import 'package:green_loop/core/utilies/colors/app_colors.dart';
import 'package:green_loop/core/utilies/styles/app_text_styles.dart';
import 'package:green_loop/features/company/redeem/views/widgets/redeem_list_tile.dart';
import 'package:green_loop/features/customer/buy_redeem/view_models/cubit/buy_redeem_cubit.dart';
import 'package:green_loop/generated/locale_keys.g.dart';

class RedeemsListView extends StatelessWidget {
  const RedeemsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<BuyRedeemCubit, BuyRedeemState>(
        listener: (context, state) {
          if (state is NotEnoughPoints) {
            showCustomDialog(
                title: LocaleKeys.Redeem_dialog_Hint.tr(),
                description: state.errorMessage,
                dialogType: DialogType.noHeader);
          }
          if (state is EnoughPoints) {
            showQrCodeDialog(
              context,
              qrData: state.qrCode,
              itemName: state.redeemName,
            );
          }
        },
        builder: (context, state) {
          if (state is BuyRedeemLoading || state is CheckPoints) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else if (state is BuyRedeemFailure) {
            return Center(
              child: Text(
                state.errorMessage,
                style: AppTextStyles.title24PrimaryColorW500,
                textAlign: TextAlign.center,
              ),
            );
          }
          final redeemCubit = context.read<BuyRedeemCubit>();
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: redeemCubit.redeemList.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return state is CheckPoints
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : RedeemListTile(
                      redeemModel: redeemCubit.redeemList[index],
                      iconData: Icons.shopify_outlined,
                      onPressed: () {
                        showCustomDialog(
                          title: LocaleKeys.Redeem_dialog_Hint.tr(),
                          description:
                              "Are you sure you want to buy this item?",
                          dialogType: DialogType.question,
                          btnOkOnPress: () {
                            redeemCubit.buyRedeem(
                              redeemModel: redeemCubit.redeemList[index],
                            );
                          },
                          btnCancelOnPress: () {},
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}
