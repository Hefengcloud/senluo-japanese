part of 'preview_bloc.dart';

sealed class PreviewState extends Equatable {
  const PreviewState();

  @override
  List<Object> get props => [];
}

final class PreviewLoading extends PreviewState {}

final class PreviewLoaded extends PreviewState {
  final List<VocabularyWord> words;

  final int pageCount;
  final int currentPage;

  const PreviewLoaded({
    this.words = const [],
    this.pageCount = 0,
    this.currentPage = 0,
  });

  List<VocabularyWord> get displayedWords => words
      .whereIndexed((index, _) =>
          index < (currentPage + 1) * kWordCountPerPage &&
          index >= currentPage * kWordCountPerPage)
      .toList();

  @override
  List<Object> get props => [words, pageCount, currentPage];

  PreviewLoaded copyWith({
    String? currentGroupKey,
    int? pageCount,
    int? currentPage,
  }) {
    return PreviewLoaded(
      words: words,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
