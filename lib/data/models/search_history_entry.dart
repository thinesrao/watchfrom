import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history_entry.freezed.dart';
part 'search_history_entry.g.dart';

@freezed
abstract class SearchHistoryEntry with _$SearchHistoryEntry {
  const factory SearchHistoryEntry({
    required String query,
    required DateTime searchedAt,
  }) = _SearchHistoryEntry;

  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryEntryFromJson(json);
}
