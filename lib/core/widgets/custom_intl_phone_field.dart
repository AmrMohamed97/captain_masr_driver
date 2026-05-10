import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../imports/imports.dart';

class CustomIntlPhoneField extends StatelessWidget {
  const CustomIntlPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.onCountryChanged,
    this.isRequired = false,
    this.borderRadius,
    this.suffixIcon,
    this.enabled = true,
    this.initialCountryCode,
  });

  final TextEditingController controller;
  final bool isRequired, enabled;
  final String? Function(PhoneNumber?)? validator;
  final Function(Country)? onCountryChanged;
  final double? borderRadius;
  final Widget? suffixIcon;
  final String? initialCountryCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Title
        Padding(
          padding: EdgeInsets.only(bottom: 8.rH(context)),
          child: Text(
            AppStrings.mobileNumber.tr(context),
            style: Styles.regular14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),

        //! Phone Field with Validator
        FormField<PhoneNumber>(
          validator: validator,
          builder: (field) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                enabled: enabled,
                controller: controller,
                pickerDialogStyle: PickerDialogStyle(
                  padding: EdgeInsets.only(
                    top: 24.rH(context),
                    left: 20.rW(context),
                    right: 20.rW(context),
                  ),
                  searchFieldInputDecoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    hintText: AppStrings.search.tr(context),
                    hintStyle: Styles.medium14(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    border: border(),
                    enabledBorder: border(),
                    focusedBorder: border(color: AppColors.primary),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  countryNameStyle: Styles.medium14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  countryCodeStyle: Styles.medium14(context).copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                flagsButtonPadding:
                    EdgeInsets.symmetric(horizontal: 14.rW(context)),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                showCountryFlag: true,
                showDropdownIcon: false,
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                showCursor: true,
                cursorColor: AppColors.primary,
                disableLengthCheck: true,
                dropdownTextStyle: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.enteryYouMobileNumber.tr(context),
                  hintStyle: Styles.regular14(context).copyWith(
                    color: AppColors.greyText,
                  ),
                  suffixIcon: suffixIcon,
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  alignLabelWithHint: false,
                  errorText: field.errorText,
                  border: border(),
                  enabledBorder: border(),
                  focusedBorder: border(color: AppColors.primary),
                ),
                initialCountryCode: initialCountryCode ?? 'EG',
                languageCode: context.read<GlobalCubit>().language,
                onCountryChanged: onCountryChanged,
                onChanged: (phone) {
                  field.didChange(phone);
                },
              ),
            );
          },
        ),

        SizedBox(height: 16.rH(context)),
      ],
    );
  }

  OutlineInputBorder border({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      borderSide: BorderSide(color: color ?? AppColors.transparent),
    );
  }
}
