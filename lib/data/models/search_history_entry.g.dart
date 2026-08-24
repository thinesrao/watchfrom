// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchHistoryEntry _$SearchHistoryEntryFromJson(Map<String, dynamic> json) =>
    _SearchHistoryEntry(
      query: json['query'] as String,
      searchedAt: DateTime.parse(json['searchedAt'] as String),
    );

Map<String, dynamic> _$SearchHistoryEntryToJson(_SearchHistoryEntry instance) =>
    <String, dynamic>{
      'query': instance.query,
      'searchedAt': instance.searchedAt.toIso8601String(),
    };
