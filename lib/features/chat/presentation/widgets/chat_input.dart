import '../../../../core/imports/imports.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        return Container(
          width: double.infinity,
          height: 70.rH(context),
          padding: EdgeInsets.only(
            left: 16.rW(context),
            right: 16.rW(context),
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: .5,
                color: AppColors.greyText.withOpacity(.5),
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: cubit.messageController,
                    hintText: AppStrings.typeMessage.tr(context),
                    fillColor: AppColors.transparent,
                    borderColor: AppColors.transparent,
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8.rW(context)),
                //! Send Button
                GestureDetector(
                  onTap: () {
                    if (cubit.messageController.text.isNotEmpty) {
                      cubit.sendMessage();
                      cubit.messageController.clear();
                    }
                  },
                  child: BlocBuilder<GlobalCubit, GlobalState>(
                    builder: (context, state) {
                      return Transform.flip(
                        flipX: context.read<GlobalCubit>().language == "ar",
                        child: CustomSvgPicture(
                          svg: Assets.imagesMessageSend,
                          height: 24.rH(context),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
