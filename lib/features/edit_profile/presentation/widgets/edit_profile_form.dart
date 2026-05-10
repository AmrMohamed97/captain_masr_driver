import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/imports/imports.dart';
import '../../../change_password/presentation/views/change_password_view.dart';
import '../../../profile/presentation/widgets/delete_account_alert_deialog.dart';
import 'change_email_alert_dialog.dart';
import 'change_phone_alert_dialog.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        return Expanded(
          child: Form(
            key: cubit.formKey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! Image
                Center(
                  child: SizedBox(
                    width: 105.rH(context),
                    height: 105.rH(context),
                    child: Stack(
                      children: [
                        //* Image
                        Container(
                          width: 105.rH(context),
                          height: 105.rH(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4.rH(context)),
                                color: AppColors.black.withOpacity(.19),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: cubit.image != null
                                ? Image.file(
                                    File(cubit.image!.path),
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: context
                                            .read<GlobalCubit>()
                                            .userModel
                                            ?.profilePicture ??
                                        "",
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        color: AppColors.grey,
                                        height: 105.rH(context),
                                        width: 105.rH(context),
                                        child: Icon(
                                          Icons.person,
                                          size: 75.rH(context),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        //* Edit Button
                        GestureDetector(
                          onTap: () async {
                            await pickImageBottomSheet(context).then((value) {
                              cubit.pickImage(value);
                            });
                          },
                          child: Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Container(
                              width: 26.rH(context),
                              height: 26.rH(context),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: .5,
                                  )),
                              child: Center(
                                child: CustomSvgPicture(
                                  svg: Assets.imagesEdit,
                                  color: AppColors.primary,
                                  height: 18.rH(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.rH(context)),

                //! Username
                AuthTextField(
                  controller: cubit.nameController,
                  title: AppStrings.username.tr(context),
                  hintText: AppStrings.enterUsername.tr(context),
                  svgIcon: Assets.imagesPerson,
                  onChanged: (value) => cubit.formOnChange(),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvgPicture(
                        svg: Assets.imagesEdit,
                        color: AppColors.grey,
                        height: 16.rH(context),
                      ),
                      SizedBox(width: 16.rW(context)),
                    ],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterUsername.tr(context);
                    }
                    return null;
                  },
                ),

                //! Email
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChangeEmailAlertDialog(),
                    );
                  },
                  child: AuthTextField(
                    enabled: false,
                    controller: cubit.emailController,
                    title: AppStrings.email.tr(context),
                    hintText: AppStrings.enterYourEmail.tr(context),
                    svgIcon: Assets.imagesEmail,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesEdit,
                          color: AppColors.grey,
                          height: 16.rH(context),
                        ),
                        SizedBox(width: 16.rW(context)),
                      ],
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppStrings.enterYourEmail.tr(context);
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return AppStrings.invalidEmail.tr(context);
                      }
                      return null;
                    },
                  ),
                ),
                if (context.read<GlobalCubit>().userModel?.emailVerified ==
                    false)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => cubit.verifyEmail(
                        isRider: context.read<GlobalCubit>().isRider,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.rW(context),
                          vertical: 8.rH(context),
                        ),
                        margin: EdgeInsets.only(bottom: 16.rH(context)),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.verifyYourEmail.tr(context),
                              style: Styles.regular14(context).copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                //! Password
                GestureDetector(
                  onTap: () {
                    navigate(context, const ChangePasswordView());
                  },
                  child: AuthTextField(
                    controller: TextEditingController(),
                    title: AppStrings.password.tr(context),
                    hintText: "***********",
                    svgIcon: Assets.imagesLock,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    enabled: false,
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesEdit,
                          color: AppColors.grey,
                          height: 16.rH(context),
                        ),
                        SizedBox(width: 16.rW(context)),
                      ],
                    ),
                  ),
                ),

                //! Gender
                // if (context.read<GlobalCubit>().isDriver)
                //   CustomDropDownButton(
                //     value: cubit.genderValue?.tr(context),
                //     items: [
                //       AppStrings.male.tr(context),
                //       AppStrings.female.tr(context),
                //     ],
                //     onChanged: (value) {
                //       cubit.gender = value;
                //       cubit.genderValue = value == AppStrings.male.tr(context)
                //           ? "male"
                //           : "female";
                //       cubit.formOnChange();
                //     },
                //     title: AppStrings.gender.tr(context),
                //     hintText: AppStrings.selectYourGender.tr(context),
                //     icon: CustomSvgPicture(
                //       svg: Assets.imagesEdit,
                //       color: AppColors.grey,
                //       height: 16.rH(context),
                //     ),
                //     prefixIcon: CustomSvgPicture(
                //       svg: Assets.imagesGender,
                //       height: 18.rH(context),
                //     ),
                //     validator: (value) {
                //       if (value == null) {
                //         return AppStrings.selectYourGender.tr(context);
                //       }
                //       return null;
                //     },
                //   ),

                // if (context.read<GlobalCubit>().isDriver)
                //   SizedBox(height: 16.rH(context)),

                //! Id Number
                // if (context.read<GlobalCubit>().isDriver)
                //   AuthTextField(
                //     controller: cubit.idNumberController,
                //     title: AppStrings.idNumber.tr(context),
                //     hintText: AppStrings.enterYourIdNumber.tr(context),
                //     svgIcon: Assets.imagesNationalId,
                //     keyboardType: TextInputType.number,
                //     suffixIcon: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         CustomSvgPicture(
                //           svg: Assets.imagesEdit,
                //           color: AppColors.grey,
                //           height: 16.rH(context),
                //         ),
                //         SizedBox(width: 16.rW(context)),
                //       ],
                //     ),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return AppStrings.enterYourIdNumber.tr(context);
                //       }
                //       return null;
                //     },
                //   ),

                //! Phone Number
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChangePhoneAlertDialog(),
                    );
                  },
                  child: CustomIntlPhoneField(
                    enabled: false,
                    controller: cubit.mobileController,
                    initialCountryCode:
                        context.read<GlobalCubit>().userModel?.country ?? "EG",
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesEdit,
                          color: AppColors.grey,
                          height: 16.rH(context),
                        ),
                        SizedBox(width: 16.rW(context)),
                      ],
                    ),
                  ),
                ),

                //! Delete Account
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const DeleteAccountAlertDeialog(),
                    ).then((value) {
                      if (value == true) {
                        cubit.deleteAccount();
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 20.rH(context),
                        top: 16.rH(
                          context,
                        )),
                    color: AppColors.transparent,
                    child: Row(
                      children: [
                        //! Icon
                        Transform.flip(
                          flipX: context.read<GlobalCubit>().language == "en"
                              ? true
                              : false,
                          child: CustomSvgPicture(
                            svg: Assets.imagesDelete,
                            height: 22.rH(context),
                            width: 22.rW(context),
                          ),
                        ),
                        SizedBox(width: 16.rW(context)),
                        //! Title
                        Expanded(
                          child: Text(
                            AppStrings.deleteAccount.tr(context),
                            style: Styles.medium16Primary(context).copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
