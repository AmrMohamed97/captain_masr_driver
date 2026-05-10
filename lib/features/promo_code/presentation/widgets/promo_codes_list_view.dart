import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import 'promo_code_card.dart';
import 'promo_code_loading_card.dart';

class PromoCodesListView extends StatelessWidget {
  const PromoCodesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromoCodeCubit, PromoCodeState>(
      builder: (context, state) {
        final cubit = context.read<PromoCodeCubit>();
        return Expanded(
          child: CustomRefreshIndicator(
            onRefresh: () => cubit.getPromoCodes(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
              itemCount:
                  state is PromoCodesLoadingState ? 7 : cubit.promoCodes.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 18.rH(context));
              },
              itemBuilder: (context, index) {
                return state is PromoCodesLoadingState
                    ? const PromoCodeLoadingCard()
                    : PromoCodeCard(model: cubit.promoCodes[index]);
              },
            ),
          ),
        );
      },
    );
  }
}
