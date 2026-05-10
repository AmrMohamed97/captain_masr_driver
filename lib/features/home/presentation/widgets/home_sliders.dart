import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_cached_network_image.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../cubit/home_cubit.dart';

class HomeSliders extends StatelessWidget {
  const HomeSliders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return AnimatedCrossFade(
          firstChild: SizedBox(
            width: double.infinity,
            height: 153.rH(context),
            child: Stack(
              children: [
                //! Images
                CarouselSlider(
                  items: state is SlidersLoadingState
                      ? [
                          CustomShimmer(
                            h: 153.rH(context),
                            w: double.infinity,
                            borderRadius: 20,
                          )
                        ]
                      : cubit.sliders
                              ?.map(
                                (e) => CustomCachedNetworkImage(
                                  key: ValueKey(e),
                                  imageUrl: e,
                                  fit: BoxFit.cover,
                                  h: 153.rH(context),
                                  w: double.infinity,
                                  borderRadius: 20,
                                  errorWidget: (context, error, stackTrace) =>
                                      Container(
                                    width: double.infinity,
                                    height: 153.rH(context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.grey.withOpacity(.3),
                                    ),
                                    child: const Icon(
                                      Icons.error,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      cubit.splashOnChange(index);
                    },
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    enlargeFactor: 1,
                    height: 153.rH(context),
                    scrollDirection: Axis.horizontal,
                  ),
                ),

                //! Dots
                Positioned(
                  bottom: 10.rH(context),
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      cubit.sliders?.length ?? 0,
                      (index) {
                        final bool selected = cubit.splashIndex == index;
                        return Container(
                          width: selected ? 22.rW(context) : 8.rW(context),
                          height: 5.rH(context),
                          margin: EdgeInsets.symmetric(
                            horizontal: 1.rW(context),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                selected ? AppColors.white : AppColors.greyText,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          secondChild: Container(),
          crossFadeState:
              cubit.sliders?.isNotEmpty ?? false || state is SlidersLoadingState
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
