import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/imports/imports.dart';
import '../../../home/presentation/views/home_view.dart';
import '../widgets/driver_verify_account_body.dart';

class DriverVerifyAccountView extends StatefulWidget {
  const DriverVerifyAccountView({super.key});

  @override
  State<DriverVerifyAccountView> createState() =>
      _DriverVerifyAccountViewState();
}

class _DriverVerifyAccountViewState extends State<DriverVerifyAccountView> {
  StreamSubscription<DatabaseEvent>? _subscription;
  String? token;
  @override
  void initState() {
    token=sl<Cache>().getStringData(AppConstants.token);
    // sl<Cache>().getStringData(AppConstants.token);
    sl<Cache>().removeKey(AppConstants.token);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupListener();
    });
  }

  void _setupListener() {
    final int driverId = context.read<GlobalCubit>().userModel?.id ?? 0;
    final DatabaseReference ref = FirebaseDatabase.instance.ref(
      "drivers/data/$driverId/is_active",
    );

    _subscription = ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        final dynamic isActive = event.snapshot.value;
        if (isActive == true) {
          _subscription?.cancel();
          _subscription = null;
          if (mounted) {
            sl<Cache>().setData(AppConstants.token, token??"");
            navigateAndRemoveUntil(context, const HomeView());
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: DriverVerifyAccountBody());
  }
}
