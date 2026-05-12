import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 163.rH(context),
      padding: EdgeInsets.symmetric(
        horizontal: 16.rW(context),
      ),
      decoration:   BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          //! App Bar
          CustomAppBar(
            title: AppStrings.message.tr(context),
            isLigth: true,
          ),

          SizedBox(height: 19.rH(context)),

          //! User Details
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final cubit = context.read<ChatCubit>();
              return Row(
                children: [
                  SizedBox(
                    height: 37.rH(context),
                    width: 37.rH(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: cubit.receiverImage != null &&
                              cubit.receiverImage!.isNotEmpty
                          ? Image.network(
                              cubit.receiverImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  SvgPicture.asset(
                                Assets.imagesPersonSvg,
                                color: AppColors.grey,
                              ),
                            )
                          : SvgPicture.asset(
                              Assets.imagesPersonSvg,
                              color: AppColors.grey,
                            ),
                    ),
                  ),
                  SizedBox(width: 17.rW(context)),
                  //! Name
                  Text(
                    cubit.receiverName,
                    style: Styles.semibold16Primary(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
