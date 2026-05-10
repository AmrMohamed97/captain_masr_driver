import '../imports/imports.dart';

class CustomTapBar extends StatelessWidget {
  const CustomTapBar({
    super.key,
    required this.taps,
    required this.selectedTap,
    required this.onTap,
    this.tabWidth,
  });

  final List<String> taps;
  final int selectedTap;
  final Function(int) onTap;
  final double? tabWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 8.rH(context),
        horizontal: 8.rW(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 37.rH(context),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          itemCount: taps.length,
          separatorBuilder: (context, index) {
            return SizedBox(width: 6.rW(context));
          },
          itemBuilder: (context, index) {
            final bool selected = selectedTap == index;
            return GestureDetector(
              onTap: () {
                onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 37.rH(context),
                width: tabWidth,
                padding: EdgeInsets.symmetric(horizontal: 20.rW(context)),
                decoration: BoxDecoration(
                  color: selected ? AppColors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    taps[index],
                    style: Styles.semibold16Primary(context).copyWith(
                      color: selected ? AppColors.primary : AppColors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
