import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_loop/core/components/custom_elevated_button.dart';
import 'package:green_loop/core/helper/show_custom_dialog.dart';
import 'package:green_loop/core/utilies/colors/app_colors.dart';
import 'package:green_loop/core/utilies/extensions/app_extensions.dart';
import 'package:green_loop/features/auth/sign_in/views/widgets/custom_loading.dart';
import 'package:green_loop/features/customer/categories/views/widgets/triple_bottom_wave_painter.dart';
import 'package:green_loop/features/customer/profile/view_models/cubit/update_profile_cubit.dart';
import 'package:green_loop/features/customer/profile/view_models/cubit/my_qr_codes_cubit.dart';
import 'package:green_loop/features/customer/profile/views/widgets/pick_image.dart';
import 'package:green_loop/features/customer/profile/views/widgets/user_details.dart';
import 'package:green_loop/features/customer/profile/views/widgets/my_qr_codes_list.dart';
import 'package:green_loop/generated/locale_keys.g.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateProfileCubit()),
        BlocProvider(create: (context) => MyQrCodesCubit()),
      ],
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            showCustomDialog(
              title: LocaleKeys.profile_dialog_success.tr(),
              description: LocaleKeys.profile_dialog_successMessage.tr(),
              dialogType: DialogType.success,
            );
          }
          if (state is UpdateProfileFailed) {
            showCustomDialog(
              title: LocaleKeys.profile_dialog_failed.tr(),
              description: state.message,
              dialogType: DialogType.error,
            );
          }
          if (state is NoChanges) {
            showCustomDialog(
              title: LocaleKeys.profile_dialog_hint.tr(),
              description: LocaleKeys.profile_dialog_hintMessage.tr(),
              dialogType: DialogType.success,
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<UpdateProfileCubit>();
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.height * 0.2,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: TripleBottomWavePainter(),
                    ),
                  ),
                  PickImage(
                    image: cubit.user!.image,
                    onPressed: () {
                      cubit.pickImage();
                    },
                  ),
                  UserDetails(
                    addressController: cubit.addressController,
                    nameController: cubit.nameController,
                    emailController: cubit.emailController,
                    phoneController: cubit.phoneController,
                    voucher: "${cubit.user!.voucher}  \$",
                  ),
                  SizedBox(
                    height: context.height * 0.03,
                  ),
                  state is UpdateProfileLoading
                      ? CustomLoading()
                      : CustomElevatedButton(
                          width: context.width * 0.9,
                          height: context.height * 0.07,
                          backgroundColor: AppColors.secondryColor,
                          name: LocaleKeys.profile_dialog_buttonUpdate.tr(),
                          onPressed: () {
                            cubit.updateProfile();
                          },
                        ),
                  const SizedBox(height: 24),
                  const MyQrCodesButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
