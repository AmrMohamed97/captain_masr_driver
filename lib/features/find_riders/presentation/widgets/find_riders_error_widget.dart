import '../../../../core/imports/imports.dart';

class FindRidersErrorWidget extends StatelessWidget {
  const FindRidersErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FindRidersCubit>();
    final driverId = context.read<GlobalCubit>().userModel?.id ?? 0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.rW(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvgPicture(
              svg: Assets.imagesError,
              height: 140.rH(context),
            ),
            SizedBox(height: 24.rH(context)),
            Text(
              AppStrings.anErrorOccured(),
              style: Styles.bold24primary(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.rH(context)),
            Text(
              sl<Cache>().getLanguage() == 'en'
                  ? 'Something went wrong while connecting.\nPlease try again.'
                  : 'حدث خطأ أثناء الاتصال.\nيرجى المحاولة مرة أخرى.',
              style: Styles.regular14(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.rH(context)),
            CustomButton(
              title: sl<Cache>().getLanguage() == 'en'
                  ? 'Try Again'
                  : 'إعادة المحاولة',
              onPressed: () => cubit.retryRealTime(context, driverId: driverId),
            ),
          ],
        ),
      ),
    );
  }
}
