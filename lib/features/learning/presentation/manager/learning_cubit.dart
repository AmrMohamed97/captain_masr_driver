import '../../../../core/imports/imports.dart';
import '../../data/repo/learning_repo.dart';
import 'learning_state.dart';

class LearningCubit extends Cubit<LearningState> {
  final LearningRepo repo;

  LearningCubit(this.repo) : super(LearningInitialState());

  Future<void> getLearningUrl() async {
    emit(LearningLoadingState());
    try {
      final url = await repo.getLearningUrl();
      emit(LearningSuccessState(url));
    } catch (e) {
      emit(LearningErrorState(e.toString()));
    }
  }

  Future<void> sendMessageToAdmin({
    required String contactType,
    required String contactValue,
    required String message,
  }) async {
    emit(LearningSendMessageLoadingState());
    try {
      final successMessage = await repo.sendMessageToAdmin(
        contactType: contactType,
        contactValue: contactValue,
        message: message,
      );
      emit(LearningSendMessageSuccessState(successMessage));
    } catch (e) {
      emit(LearningSendMessageErrorState(e.toString()));
    }
  }
}