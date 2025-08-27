import 'package:flutter/material.dart';

class ModuleProvider extends ChangeNotifier {
  String? _selectedModuleId;

  String? get selectedModuleId => _selectedModuleId;

  void selectModule(String moduleId) {
    _selectedModuleId = moduleId;
    notifyListeners();
  }

  void clearModule() {
    _selectedModuleId = null;
    notifyListeners();
  }
}
