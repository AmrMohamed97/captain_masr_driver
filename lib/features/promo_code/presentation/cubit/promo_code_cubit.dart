import '../../../../core/imports/imports.dart';
import '../../data/models/promo_code_model.dart';
import '../../data/repo/promo_codes_repo.dart';

part 'promo_code_state.dart';

class PromoCodeCubit extends Cubit<PromoCodeState> {
  PromoCodeCubit() : super(PromoCodeInitial());

  //! Promo Codes
  List<PromoCodeModel> promoCodes = [];

  Future<void> getPromoCodes({int? tripTypeId}) async {
    emit(PromoCodesLoadingState());
    final result = await sl<PromoCodesRepo>().getPromoCodes(
      tripTypeId: tripTypeId,
    );
    result.fold(
      (error) => emit(PromoCodesErrorState(error: error)),
      (list) {
        promoCodes = list;
        emit(PromoCodesSuccessState());
      },
    );
  }
}
