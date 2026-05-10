import '../../../../core/imports/imports.dart';
import 'request_for_driver_card.dart';

class RequestsBody extends StatelessWidget {
  const RequestsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: CustomAppBar(
            title: AppStrings.requests.tr(context),
          ),
        ),

        SizedBox(height: 26.rH(context)),

        BlocBuilder<FindRidersCubit, FindRidersState>(
          builder: (context, state) {
            final cubit = context.read<FindRidersCubit>();
            return Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 24.rH(context)),
                itemCount: cubit.rideRequests.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.rH(context));
                },
                itemBuilder: (context, index) {
                  return RequestForDriverCard(
                    key: ValueKey(cubit.rideRequests[index].id),
                    model: cubit.rideRequests[index],
                    acceptOnTap: () async {
                      return await cubit.acceptRide(id: cubit.rideRequests[index].id ?? 0);
                    },
                    declineOnTap: () => cubit.declineRequest(
                        id: cubit.rideRequests[index].id ?? 0),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
