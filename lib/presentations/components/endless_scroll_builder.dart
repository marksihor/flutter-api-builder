import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/core/handlers/api_pagination_handler.dart';
import 'package:api_builder/core/injection.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/components/form_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helpers.dart';
import 'animated_visibility_widget.dart';

class EndlessScrollBuilder extends StatefulWidget with FormHelperMixin {
  @override
  final Form_ form;
  final String pageKey;
  final String itemsKey;
  final Widget Function(Map data) elementBuilder;
  final Widget? openFilterButton;

  const EndlessScrollBuilder({
    super.key,
    required this.form,
    required this.elementBuilder,
    this.pageKey = 'page',
    this.itemsKey = 'data',
    this.openFilterButton,
  });

  @override
  State<EndlessScrollBuilder> createState() => _EndlessScrollBuilderState();
}

class _EndlessScrollBuilderState extends State<EndlessScrollBuilder> {
  final ScrollController _scrollController = ScrollController();
  List _elements = [];
  bool _bottomSheetVisible = false;

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
          } else if (state is FormSubmittingState) {
            _bottomSheetVisible = false;
          }
          widget.loadingOverlayHandler(state, context);
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
                  widget.submit(context, state);
                }
              }
            });

            widget.submit(context, state);
          }
          if (state is FormSubmittedState) {
            if (state.form.extraSubmitData[widget.pageKey] == 1) {
              _elements = state.form.responseData[widget.itemsKey];
            } else {
              _elements.addAll(state.form.responseData[widget.itemsKey]);
            }
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {
                    state.form.extraSubmitData[widget.pageKey] = 1;
                    widget.submit(context, state);
                  },
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        _elements.map((e) => widget.elementBuilder(e)).toList(),
                  ),
                ),
                floatingActionButton: widget.openFilterButton == null
                    ? null
                    : overrideOnTap(
                        onTap: () {
                          setState(() {
                            _bottomSheetVisible = !_bottomSheetVisible;
                          });
                        },
                        child: widget.openFilterButton!,
                      ),
              ),
              AnimatedVisibilityWidget(
                isVisible: _bottomSheetVisible,
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: widget.buildForm(context, state,
                          labelTrailing: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.clear(context, state);
                                  widget.submit(context, state);
                                  setState(() {
                                    _bottomSheetVisible = false;
                                  });
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _bottomSheetVisible = false;
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
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
