import '../../../../core/imports/imports.dart';
import '../../data/models/services_model.dart';

class HomeDriverPreferencesCard extends StatelessWidget {
  const HomeDriverPreferencesCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.active,
    required this.index,
  });

  final ServicesModel model;
  final Function() onTap;
  final bool active;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 165.rW(context),
        height: 143.rH(context),
        child: Stack(
          children: [
            //! Background
            Transform.flip(
              flipX:
                  context.read<GlobalCubit>().language == "ar" ? true : false,
              child: AnimatedCrossFade(
                firstChild: CustomSvgPicture(
                  svg: Assets.imagesHomePreferencesCardBackground,
                  width: 153.33.rW(context),
                  height: 143.rH(context),
                  fit: BoxFit.fill,
                  color: AppColors.primary,
                ),
                secondChild: CustomSvgPicture(
                  svg: Assets.imagesHomePreferencesCardBackground,
                  width: 153.33.rW(context),
                  height: 143.rH(context),
                  fit: BoxFit.fill,
                  color: Theme.of(context).cardColor,
                ),
                crossFadeState: active
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),
            ),
            //! Switch
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: SizedBox(
                height: 30.rH(context),
                width: 70.rW(context),
                child: FittedBox(
                  child: CustomSwitch(
                    value: active,
                    onChanged: (value) {
                      onTap();
                    },
                  ),
                ),
              ),
            ),
            //! Content
            PositionedDirectional(
              top: 14.rH(context),
              start: 12.5.rW(context),
              end: index == 3 ? -10.rW(context) : -5.rW(context),
              bottom: 11.rH(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //! Type
                  Text(
                    model.type.tr(context),
                    style: Styles.semibold14Primary(context).copyWith(
                      color: active
                          ? AppColors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  //! Image
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Image.asset(
                        model.image,
                        height: 80.rH(context),
                        width: 120.rW(context),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  //! Title
                  Text(
                    model.title.tr(context),
                    style: Styles.regular11(context).copyWith(
                      color: active
                          ? AppColors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
