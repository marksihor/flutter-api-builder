import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/components/form_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormBuilder extends StatelessWidget with FormHelperMixin {
  @override
  final Form_ form;

  const FormBuilder({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          loadingOverlayHandler(state, context);
        },
        builder: (BuildContext context, FormState_ state) {
          return SingleChildScrollView(child: buildForm(context, state));
        },
      ),
    );
  }
}
