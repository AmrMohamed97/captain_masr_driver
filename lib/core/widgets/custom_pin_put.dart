import 'package:pinput/pinput.dart';

import '../imports/imports.dart';

class CustomPinPut extends StatelessWidget {
  const CustomPinPut({
    super.key,
    required this.controller,
    required this.onComplete,
    required this.validator,
  });

  final TextEditingController controller;
  final Function(String?) onComplete;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.5.rW(context)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          controller: controller,
          validator: validator,
          length: 4,
          submittedPinTheme: PinTheme(
            width: 49.rW(context),
            height: 48.rH(context),
            textStyle: Styles.bold20(context).copyWith(
              color: context.read<GlobalCubit>().isDarkMode
                  ? AppColors.white
                  : AppColors.textColor,
            ),
            margin: EdgeInsetsDirectional.only(
              start: 8.rW(context),
              end: 8.rW(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              border: Border.all(
                color: AppColors.primary,
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 49.rW(context),
            height: 48.rH(context),
            textStyle: Styles.bold20(context),
            margin: EdgeInsetsDirectional.only(
              start: 8.rW(context),
              end: 8.rW(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              border: Border.all(
                color: AppColors.primary,
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          defaultPinTheme: PinTheme(
            width: 49.rW(context),
            height: 48.rH(context),
            textStyle: Styles.bold20(context),
            margin: EdgeInsetsDirectional.only(
              start: 8.rW(context),
              end: 8.rW(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(.25),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onCompleted: onComplete,
        ),
      ),
    );
  }
}
