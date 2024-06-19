import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/injection.dart';
import 'package:api_builder/models/form.dart';
import 'package:api_builder/presentations/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndlessScrollBuilder extends StatefulWidget {
  final Form_ form;

  final int Function(Form_ form) getCurrentPage;
  final int? Function(Form_ form) getNextPage;
  final String queryKey;
  final String itemsKey;

  const EndlessScrollBuilder({
    super.key,
    required this.form,
    required this.getCurrentPage,
    required this.getNextPage,
    this.queryKey = 'page',
    this.itemsKey = 'data',
  });

  @override
  State<EndlessScrollBuilder> createState() => _EndlessScrollBuilderState();
}

class _EndlessScrollBuilderState extends State<EndlessScrollBuilder> {
  final ScrollController _scrollController = ScrollController();
  List elements = [];

  @override
  void initState() {
    widget.form.extraSubmitData[widget.queryKey] = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: widget.form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          if (state is FormFieldValueChangedEvent) {
            state.form.extraSubmitData[widget.queryKey] = 1;
          }
          _handleLoadingOverlay(state, context);
        },
        builder: (BuildContext context, FormState_ state) {
          if (state is FormInitial) {
            _scrollController.addListener(() {
              final maxScroll = _scrollController.position.maxScrollExtent;
              final currentScroll = _scrollController.position.pixels;

              if (currentScroll == maxScroll) {
                int currentPage = widget.getCurrentPage(state.form);
                int? nextPage = widget.getNextPage(state.form);
                if (nextPage != null && nextPage > currentPage) {
                  state.form.extraSubmitData[widget.queryKey] = nextPage;
                  _submit(context, state);
                }
              }
            });

            _submit(context, state);
          }
          if (state is FormSubmittedState) {
            if (state.form.extraSubmitData[widget.queryKey] == 1) {
              elements = state.form.responseData[widget.itemsKey];
            } else {
              elements.addAll(state.form.responseData[widget.itemsKey]);
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              state.form.extraSubmitData[widget.queryKey] = 1;
              _submit(context, state);
            },
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: elements.map((e) => Text(e.toString())).toList(),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context, FormState_ state) {
    context.read<FormBloc>().add(FormSubmitEvent(form: state.form));
  }

  void _handleLoadingOverlay(FormState_ state, BuildContext context) {
    final loadingOverlay = FormInjector().serviceLocator<LoadingOverlay>();
    if (state is FormSubmittingState) {
      loadingOverlay.show(context);
    } else {
      loadingOverlay.hide();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
