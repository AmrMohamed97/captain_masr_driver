import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/imports/imports.dart';

class ProfileUserDetails extends StatelessWidget {
  const ProfileUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        return Column(
          children: [
            //* Image
            Container(
              height: 105.rH(context),
              width: 105.rH(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4.rH(context)),
                    color: AppColors.black.withOpacity(.25),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl:
                      context.read<GlobalCubit>().userModel?.profilePicture ??
                          "",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Container(
                      color: AppColors.grey,
                      height: 105.rH(context),
                      width: 105.rH(context),
                      child: Icon(
                        Icons.person,
                        size: 75.rH(context),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12.rH(context)),
            //* Name
            if (cubit.userModel?.username != null)
              Text(
                cubit.userModel!.username!,
                style: Styles.bold16(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            SizedBox(height: 4.rH(context)),
            //* Email
            if (cubit.userModel?.email != null)
              Text(
                cubit.userModel!.email!,
                style: Styles.medium12(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
            SizedBox(height: 12.rH(context)),
          ],
        );
      },
    );
  }
}
