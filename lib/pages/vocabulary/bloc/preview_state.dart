part of 'preview_bloc.dart';

sealed class PreviewState extends Equatable {
  const PreviewState();

  @override
  List<Object> get props => [];
}

final class PreviewLoading extends PreviewState {}

final class PreviewLoaded extends PreviewState {
  final Map<String, List<Word>> group2words;
  final String currentGroupKey;

  final int pageCount;
  final int currentPage;

  const PreviewLoaded({
    required this.group2words,
    this.currentGroupKey = '',
    this.pageCount = 0,
    this.currentPage = 0,
  });

  List<Word> get words =>
      currentGroupKey.isNotEmpty ? group2words[currentGroupKey] ?? [] : [];

  List<Word> get displayedWords => words
      .whereIndexed((index, _) =>
          index < (currentPage + 1) * kWordCountPerPage &&
          index >= currentPage * kWordCountPerPage)
      .toList();

  @override
  List<Object> get props =>
      [group2words, currentGroupKey, pageCount, currentPage];

  PreviewLoaded copyWith({
    String? currentGroupKey,
    int? pageCount,
    int? currentPage,
  }) {
    return PreviewLoaded(
      group2words: group2words,
      currentGroupKey: currentGroupKey ?? this.currentGroupKey,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
