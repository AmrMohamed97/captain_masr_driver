import '../../../../core/imports/imports.dart';
import '../../data/models/selected_location_model.dart';

class ChooseLocationSavedLocations extends StatelessWidget {
  const ChooseLocationSavedLocations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
      builder: (context, state) {
        final cubit = context.read<ChooseLocationCubit>();
        return AnimatedCrossFade(
          firstChild: Container(
            margin: EdgeInsets.only(top: 16.rH(context)),
            height: 32.rH(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: cubit.savedLocations.length,
              separatorBuilder: (context, index) {
                return SizedBox(width: 12.rW(context));
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (cubit.savedLocations[index].lat != null &&
                        cubit.savedLocations[index].long != null) {
                      cubit.selectLocation(
                        model: SelectedLocationModel(
                          address: cubit.savedLocations[index].address,
                          lat: double.parse(cubit.savedLocations[index].lat!),
                          lon: double.parse(cubit.savedLocations[index].long!),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 32.rH(context),
                    padding: EdgeInsets.symmetric(horizontal: 12.rW(context)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.15),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Row(
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesHomeActive,
                          height: 16.rH(context),
                        ),
                        SizedBox(width: 8.rW(context)),
                        Text(
                          cubit.savedLocations[index].type ?? "??",
                          style: Styles.bold12primary(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          secondChild: Container(),
          crossFadeState: cubit.savedLocations.isNotEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
