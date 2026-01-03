
import 'package:get/get.dart';
import '../../data/model/quiz_model.dart';

class QuestionBankViewController extends GetxController {
  // Map to store selected option for each question index: {index: selectedOptionKey}
  final RxMap<int, String> selectedOptions = <int, String>{}.obs;
  // Map to store if a question has been answered/revealed: {index: true}
  final RxMap<int, bool> isRevealed = <int, bool>{}.obs;

  void selectOption(int questionIndex, String optionKey, String correctAnswer) {
    if (isRevealed[questionIndex] == true) return; // Prevent changing after answer

    selectedOptions[questionIndex] = optionKey;
    isRevealed[questionIndex] = true;
  }

  bool isAnswered(int index) => isRevealed[index] == true;
  
  String? getSelectedOption(int index) => selectedOptions[index];
}
