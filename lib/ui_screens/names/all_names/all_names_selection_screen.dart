// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:names_app/ui_screens/names/gender_picker_screen.dart';
import 'package:names_app/ui_screens/names/name_navigation.dart';

class AllNamesSelectionScreen extends StatelessWidget {
  const AllNamesSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const GenderPickerScreen(category: NameCategory.all);
}
