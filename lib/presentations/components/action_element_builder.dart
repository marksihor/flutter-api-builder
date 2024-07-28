import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/components/form_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionElementBuilder extends StatelessWidget with FormHelperMixin {
  @override
  final Form_ form;
  final Widget Function(
      Function({Map<String, dynamic>? extraSubmitData}) submit) builder;
  final Function successCallback;

  const ActionElementBuilder({
    super.key,
    required this.form,
    required this.builder,
    required this.successCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          loadingOverlayHandler(state, context);
          if (state is FormSubmittedState) successCallback(state.form);
        },
        builder: (BuildContext context, FormState_ state) {
          return builder(({Map? extraSubmitData}) {
            if (extraSubmitData != null) {
              state.form.extraSubmitData.addAll(extraSubmitData);
            }
            submit(context, state);
          });
        },
      ),
    );
  }
}
