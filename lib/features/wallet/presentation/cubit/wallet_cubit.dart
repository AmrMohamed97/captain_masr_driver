import '../../../../core/imports/imports.dart';
import '../../../base/data/models/pagination_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repo/wallet_repo.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  bool returnPayment = false;
  bool findDriver = false;
  late bool isRider;

  //! Set Default Payment Method
  Future<void> setDefaultPaymentMethod() async {
    emit(SetDefaultPaymentLoadingState());
    final result = await sl<WalletRepo>().setDefaultPaymentMethod(
      paymentMethodId: selectedPaymentId!,
      subPaymentMethodId: selectedSubPaymentId,
    );
    result.fold(
      (error) => emit(WalletErrorState(error: error)),
      (message) => emit(SetDefaultPaymentSuccessState(message: message)),
    );
  }

  //! Payment Methods
  List<PaymentMethodModel> paymentMethods = [];

  Future<void> getPaymentMethods() async {
    emit(WalletLoadingState());
    final result = await sl<WalletRepo>().getPaymentMethods();
    result.fold(
      (error) => emit(WalletErrorState(error: error)),
      (list) {
        paymentMethods = list;
        emit(WalletSuccessState());
      },
    );
  }

  //! Pagination
  ScrollController scrollController = ScrollController();
  PaginationModel? pagination;
  int page = 0;
  void initPagination() {
    const double scrollThreshold = 150.0;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              (scrollController.position.maxScrollExtent - scrollThreshold) &&
          state is! WalletLoadingState) {
        if ((pagination?.lastPage ?? 0) > page) {
          await getTransations();
        }
      }
    });
  }

  //! Get Transactions
  int balance = 0;
  List<TransactionModel> transactions = [];
  Future<void> getTransations() async {
    emit(WalletLoadingState());
    final result = await sl<WalletRepo>().getTransations(
      page: page + 1,
      isRider: isRider,
    );
    result.fold(
      (error) => emit(WalletErrorState(error: error)),
      (model) {
        balance = model.balance ?? 0;
        transactions += model.transactions;
        pagination = model.pagination;
        page += 1;
        emit(WalletSuccessState());
      },
    );
  }

  //! Selected Payment
  int? selectedPaymentId;
  int? selectedSubPaymentId;

  selectPayment(PaymentMethodModel model) {
    selectedPaymentId = model.id;
    if (model.subPayments.isNotEmpty) {
      selectedSubPaymentId = model.subPayments.first.id;
    } else {
      selectedSubPaymentId = null;
    }
    emit(SelectPaymentMethodState());
  }

  selectSubPayment(int? id) {
    selectedSubPaymentId = id;
    emit(SelectPaymentMethodState());
  }
}
