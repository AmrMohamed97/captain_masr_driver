import '../../../../core/imports/imports.dart';
import 'promo_codes_list_view.dart';

class PromoCodeBody extends StatelessWidget {
  const PromoCodeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.promoCode.tr(context),
          ),

          SizedBox(height: 16.rH(context)),

          //! Promo Codes
          const PromoCodesListView(),
        ],
      ),
    );
  }
}
