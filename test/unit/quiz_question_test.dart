import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';

void main() {
  test('QuizQuestion.fromApi decodes entities and shuffles answers', () {
    const payload = {
      'category': 'General Knowledge',
      'type': 'multiple',
      'difficulty': 'easy',
      'question': '2 &lt; 4?',
      'correct_answer': 'True',
      'incorrect_answers': ['False', 'Maybe', 'Unknown'],
    };

    final question = QuizQuestion.fromApi(json: payload, categoryId: '9');

    expect(question.question, '2 < 4?');
    expect(question.correctAnswer, 'True');
    expect(question.choices.length, 4);
    expect(question.choices, contains('True'));
  });
}

