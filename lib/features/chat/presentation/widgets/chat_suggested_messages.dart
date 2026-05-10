import '../../../../core/imports/imports.dart';

class ChatSuggestedMessages extends StatelessWidget {
  const ChatSuggestedMessages({super.key});

  static List<String> suggestedMessages = [
    AppStrings.whereAraYou,
    AppStrings.imWatingYou,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) {
              return GestureDetector(
                onTap: () {
                  cubit.messageController.text =
                      suggestedMessages[index].tr(context);
                },
                child: Container(
                  height: 35.rH(context),
                  margin: EdgeInsets.symmetric(horizontal: 6.5.rW(context)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.rW(context),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: .5,
                      color: AppColors.greyText.withOpacity(.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      suggestedMessages[index].tr(context),
                      style: Styles.medium15(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
