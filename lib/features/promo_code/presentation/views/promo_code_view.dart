import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/promo_code_body.dart';

class PromoCodeView extends StatelessWidget {
  const PromoCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoCodeCubit()..getPromoCodes(),
      child: BlocListener<PromoCodeCubit, PromoCodeState>(
        listener: (context, state) {
          if (state is PromoCodesErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        child: const Scaffold(
          body: PromoCodeBody(),
        ),
      ),
    );
  }
}
