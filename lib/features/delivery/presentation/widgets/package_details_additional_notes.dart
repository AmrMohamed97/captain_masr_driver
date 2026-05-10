import '../../../../core/imports/imports.dart';

class PackageDetailsAdditionalNotes extends StatelessWidget {
  const PackageDetailsAdditionalNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            AppStrings.anyAdditionalNotes.tr(context),
            style: Styles.medium14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(height: 10.rH(context)),
        //! Text Field
        BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            final cubit = context.read<DeliveryCubit>();
            return CustomTextField(
              controller: cubit.noteController,
              hintText: AppStrings.additionNotes.tr(context),
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              maxLines: 3,
            );
          },
        ),

        SizedBox(height: 26.rH(context)),
      ],
    );
  }
}
