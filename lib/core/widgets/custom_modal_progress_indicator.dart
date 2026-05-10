import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../imports/imports.dart';

class CustomModalProgressIndicator extends StatelessWidget {
  const CustomModalProgressIndicator(
      {super.key, required this.inAsyncCall, required this.child});

  final bool inAsyncCall;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      progressIndicator: const CustomLoadingIndicator(),
      blur: 5,
      color: AppColors.black,
      child: child,
    );
  }
}
