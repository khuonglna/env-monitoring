import 'package:flutter/material.dart';

@immutable
abstract class BaseState {}

class InitialState extends BaseState {}

class LoadedState<TModel> extends BaseState {
  final TModel model;
  final bool isShowLoading;
  final String? errorMessage;

  LoadedState(
    this.model, {
    this.errorMessage,
    this.isShowLoading = false,
  });

  LoadedState copyWith({
    TModel? model,
    bool isShowLoading = false,
    String? errorMessage,
  }) {
    return LoadedState(
      model ?? this.model,
      errorMessage: errorMessage,
      isShowLoading: isShowLoading,
    );
  }
}
