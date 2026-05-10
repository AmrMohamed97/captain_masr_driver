abstract class LearningState {}

class LearningInitialState extends LearningState {}

class LearningLoadingState extends LearningState {}

class LearningSuccessState extends LearningState {
  final String url;
  LearningSuccessState(this.url);
}

class LearningErrorState extends LearningState {
  final String message;
  LearningErrorState(this.message);
}

class LearningSendMessageLoadingState extends LearningState {}

class LearningSendMessageSuccessState extends LearningState {
  final String message;
  LearningSendMessageSuccessState(this.message);
}

class LearningSendMessageErrorState extends LearningState {
  final String message;
  LearningSendMessageErrorState(this.message);
}