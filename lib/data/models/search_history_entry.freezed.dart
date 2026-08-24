// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchHistoryEntry {

 String get query; DateTime get searchedAt;
/// Create a copy of SearchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchHistoryEntryCopyWith<SearchHistoryEntry> get copyWith => _$SearchHistoryEntryCopyWithImpl<SearchHistoryEntry>(this as SearchHistoryEntry, _$identity);

  /// Serializes this SearchHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchHistoryEntry&&(identical(other.query, query) || other.query == query)&&(identical(other.searchedAt, searchedAt) || other.searchedAt == searchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,searchedAt);

@override
String toString() {
  return 'SearchHistoryEntry(query: $query, searchedAt: $searchedAt)';
}


}

/// @nodoc
abstract mixin class $SearchHistoryEntryCopyWith<$Res>  {
  factory $SearchHistoryEntryCopyWith(SearchHistoryEntry value, $Res Function(SearchHistoryEntry) _then) = _$SearchHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String query, DateTime searchedAt
});




}
/// @nodoc
class _$SearchHistoryEntryCopyWithImpl<$Res>
    implements $SearchHistoryEntryCopyWith<$Res> {
  _$SearchHistoryEntryCopyWithImpl(this._self, this._then);

  final SearchHistoryEntry _self;
  final $Res Function(SearchHistoryEntry) _then;

/// Create a copy of SearchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? searchedAt = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,searchedAt: null == searchedAt ? _self.searchedAt : searchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchHistoryEntry].
extension SearchHistoryEntryPatterns on SearchHistoryEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchHistoryEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _SearchHistoryEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SearchHistoryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  DateTime searchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchHistoryEntry() when $default != null:
return $default(_that.query,_that.searchedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  DateTime searchedAt)  $default,) {final _that = this;
switch (_that) {
case _SearchHistoryEntry():
return $default(_that.query,_that.searchedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  DateTime searchedAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchHistoryEntry() when $default != null:
return $default(_that.query,_that.searchedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchHistoryEntry implements SearchHistoryEntry {
  const _SearchHistoryEntry({required this.query, required this.searchedAt});
  factory _SearchHistoryEntry.fromJson(Map<String, dynamic> json) => _$SearchHistoryEntryFromJson(json);

@override final  String query;
@override final  DateTime searchedAt;

/// Create a copy of SearchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchHistoryEntryCopyWith<_SearchHistoryEntry> get copyWith => __$SearchHistoryEntryCopyWithImpl<_SearchHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchHistoryEntry&&(identical(other.query, query) || other.query == query)&&(identical(other.searchedAt, searchedAt) || other.searchedAt == searchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,searchedAt);

@override
String toString() {
  return 'SearchHistoryEntry(query: $query, searchedAt: $searchedAt)';
}


}

/// @nodoc
abstract mixin class _$SearchHistoryEntryCopyWith<$Res> implements $SearchHistoryEntryCopyWith<$Res> {
  factory _$SearchHistoryEntryCopyWith(_SearchHistoryEntry value, $Res Function(_SearchHistoryEntry) _then) = __$SearchHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String query, DateTime searchedAt
});




}
/// @nodoc
class __$SearchHistoryEntryCopyWithImpl<$Res>
    implements _$SearchHistoryEntryCopyWith<$Res> {
  __$SearchHistoryEntryCopyWithImpl(this._self, this._then);

  final _SearchHistoryEntry _self;
  final $Res Function(_SearchHistoryEntry) _then;

/// Create a copy of SearchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? searchedAt = null,}) {
  return _then(_SearchHistoryEntry(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,searchedAt: null == searchedAt ? _self.searchedAt : searchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
