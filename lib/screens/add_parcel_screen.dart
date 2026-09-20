import 'package:flutter/material.dart';

import '../models/add_parcel_callback.dart';
import '../navigation/app_navigator.dart';
import '../widgets/add_parcel_form.dart';

class AddParcelScreen extends StatelessWidget {
  const AddParcelScreen({super.key, required this.onSubmit});

  final AddParcelOnSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => AppNavigator.pop(context),
        ),
        title: const Text('Add Parcel'),
        centerTitle: true,
      ),
      body: AddParcelForm(
        onSubmit: onSubmit,
        showHeader: false,
        onSaved: () => AppNavigator.pop(context),
      ),
    );
  }
}
