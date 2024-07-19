import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/components/form_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElementBuilder extends StatelessWidget with FormHelperMixin {
  @override
  final Form_ form;
  final Widget Function(Map data, Function submit) builder;
  final Widget Function(Map data, Function submit)? errorBuilder;

  const ElementBuilder({
    super.key,
    required this.form,
    required this.builder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          loadingOverlayHandler(state, context);
        },
        builder: (BuildContext context, FormState_ state) {
          if (state is FormInitial) {
            submit(context, state);
          }
          if (state is FormSubmittedState) {
            return RefreshIndicator(
              onRefresh: () async {
                submit(context, state);
              },
              child: builder(
                state.form.responseData,
                () => submit(context, state),
              ),
            );
          } else if (state is FormSubmittingErrorState &&
              errorBuilder != null) {
            return errorBuilder!(
              state.form.responseData,
              () => submit(context, state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
