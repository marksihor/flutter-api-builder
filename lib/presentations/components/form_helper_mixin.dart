import 'package:api_builder/bloc/form_bloc.dart';

import 'package:api_builder/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loading_overlay.dart';

mixin FormHelperMixin {
  void loadingOverlayHandler(FormState_ state, BuildContext context) {
    final loadingOverlay = FormInjector.serviceLocator<LoadingOverlay>();
    if (state is FormSubmittingState) {
      loadingOverlay.show(context);
    } else {
      loadingOverlay.hide();
    }
  }

  void submit(BuildContext context, FormState_ state) {
    context.read<FormBloc>().add(FormSubmitEvent(form: state.form));
  }
}
