import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/core/handlers/api_pagination_handler.dart';
import 'package:api_builder/core/injection.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/components/form_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndlessScrollBuilder extends StatefulWidget {
  final Form_ form;
  final String pageKey;
  final String itemsKey;
  final Widget Function(Map data) elementBuilder;

  const EndlessScrollBuilder({
    super.key,
    required this.form,
    required this.elementBuilder,
    this.pageKey = 'page',
    this.itemsKey = 'data',
  });

  @override
  State<EndlessScrollBuilder> createState() => _EndlessScrollBuilderState();
}

class _EndlessScrollBuilderState extends State<EndlessScrollBuilder>
    with FormHelperMixin {
  final ScrollController _scrollController = ScrollController();
  List elements = [];

  @override
  void initState() {
    widget.form.extraSubmitData[widget.pageKey] = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: widget.form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          if (state is FormFieldValueChangedEvent) {
            state.form.extraSubmitData[widget.pageKey] = 1;
          }
          loadingOverlayHandler(state, context);
        },
        builder: (BuildContext context, FormState_ state) {
          if (state is FormInitial) {
            _scrollController.addListener(() {
              final maxScroll = _scrollController.position.maxScrollExtent;
              final currentScroll = _scrollController.position.pixels;

              if (currentScroll == maxScroll) {
                var handler =
                    FormInjector.serviceLocator<ApiPaginationHandler>();
                int currentPage = handler.getCurrentPage(state.form);
                int? nextPage = handler.getNextPage(state.form);
                if (nextPage != null && nextPage > currentPage) {
                  state.form.extraSubmitData[widget.pageKey] = nextPage;
                  submit(context, state);
                }
              }
            });

            submit(context, state);
          }
          if (state is FormSubmittedState) {
            if (state.form.extraSubmitData[widget.pageKey] == 1) {
              elements = state.form.responseData[widget.itemsKey];
            } else {
              elements.addAll(state.form.responseData[widget.itemsKey]);
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              state.form.extraSubmitData[widget.pageKey] = 1;
              submit(context, state);
            },
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: elements.map((e) => widget.elementBuilder(e)).toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
