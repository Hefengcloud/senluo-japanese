part of 'preview_bloc.dart';

sealed class PreviewEvent extends Equatable {
  const PreviewEvent();

  @override
  List<Object> get props => [];
}

class PreviewStarted extends PreviewEvent {
  final List<Word> words;

  const PreviewStarted({required this.words});
}

class PreviewGroupChanged extends PreviewEvent {
  final String groupKey;

  const PreviewGroupChanged({required this.groupKey});
}

class PreviewPageChanged extends PreviewEvent {
  final int page;

  const PreviewPageChanged({required this.page});
}
