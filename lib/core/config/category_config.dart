import 'package:flutter/material.dart';
import 'package:quiz_learning_app/core/models/quiz_category.dart';

class CategoryConfig {
  CategoryConfig._();

  static final List<QuizCategory> categories = [
    QuizCategory(id: '9', name: 'General Knowledge', iconName: 'emoji_objects'),
    QuizCategory(id: '18', name: 'Computers', iconName: 'computer'),
    QuizCategory(id: '23', name: 'History', iconName: 'history_edu'),
    QuizCategory(id: '17', name: 'Science & Nature', iconName: 'science'),
    QuizCategory(id: '21', name: 'Sports', iconName: 'sports_soccer'),
    QuizCategory(id: '22', name: 'Geography', iconName: 'public'),
    QuizCategory(id: '20', name: 'Mythology', iconName: 'auto_awesome'),
    QuizCategory(id: '24', name: 'Politics', iconName: 'gavel'),
    QuizCategory(id: '27', name: 'Animals', iconName: 'pets'),
    QuizCategory(id: '10', name: 'Books', iconName: 'menu_book'),
  ];

  static IconData iconFor(String iconName) {
    switch (iconName) {
      case 'computer':
        return Icons.computer;
      case 'history_edu':
        return Icons.history_edu;
      case 'science':
        return Icons.science;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'public':
        return Icons.public;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'gavel':
        return Icons.gavel;
      case 'pets':
        return Icons.pets;
      case 'menu_book':
        return Icons.menu_book;
      case 'emoji_objects':
      default:
        return Icons.emoji_objects;
    }
  }
}
