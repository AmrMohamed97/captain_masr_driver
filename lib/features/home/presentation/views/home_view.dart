import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../cubit/home_cubit.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/home_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    BlocProvider.of<GlobalCubit>(context).getDriverTodaySummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('token=>${sl<Cache>().getStringData(AppConstants.token)}');
    print(sl<Cache>().getStringData(AppConstants.token));
    return BlocProvider(
      create: (context) => HomeCubit(
        isDriver: true,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeErrorState) {
              state.error != null
                  ? showToast(
                      context,
                      message: state.error!,
                      state: ToastStates.error,
                    )
                  : null;
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is HomeLoadingState,
              child: const HomeBody(),
            );
          },
        ),
      ),
    );
  }
}
