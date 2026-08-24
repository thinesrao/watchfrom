// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchlistItem {

 int get tmdbId; String get title; MediaType get mediaType; String? get posterPath; String? get releaseYear; DateTime get savedAt; Map<String, List<WatchProvider>> get availabilitySnapshot;
/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistItemCopyWith<WatchlistItem> get copyWith => _$WatchlistItemCopyWithImpl<WatchlistItem>(this as WatchlistItem, _$identity);

  /// Serializes this WatchlistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistItem&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&const DeepCollectionEquality().equals(other.availabilitySnapshot, availabilitySnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,mediaType,posterPath,releaseYear,savedAt,const DeepCollectionEquality().hash(availabilitySnapshot));

@override
String toString() {
  return 'WatchlistItem(tmdbId: $tmdbId, title: $title, mediaType: $mediaType, posterPath: $posterPath, releaseYear: $releaseYear, savedAt: $savedAt, availabilitySnapshot: $availabilitySnapshot)';
}


}

/// @nodoc
abstract mixin class $WatchlistItemCopyWith<$Res>  {
  factory $WatchlistItemCopyWith(WatchlistItem value, $Res Function(WatchlistItem) _then) = _$WatchlistItemCopyWithImpl;
@useResult
$Res call({
 int tmdbId, String title, MediaType mediaType, String? posterPath, String? releaseYear, DateTime savedAt, Map<String, List<WatchProvider>> availabilitySnapshot
});




}
/// @nodoc
class _$WatchlistItemCopyWithImpl<$Res>
    implements $WatchlistItemCopyWith<$Res> {
  _$WatchlistItemCopyWithImpl(this._self, this._then);

  final WatchlistItem _self;
  final $Res Function(WatchlistItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tmdbId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,Object? releaseYear = freezed,Object? savedAt = null,Object? availabilitySnapshot = null,}) {
  return _then(_self.copyWith(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as String?,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,availabilitySnapshot: null == availabilitySnapshot ? _self.availabilitySnapshot : availabilitySnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, List<WatchProvider>>,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistItem].
extension WatchlistItemPatterns on WatchlistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistItem value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistItem value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath,  String? releaseYear,  DateTime savedAt,  Map<String, List<WatchProvider>> availabilitySnapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath,_that.releaseYear,_that.savedAt,_that.availabilitySnapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath,  String? releaseYear,  DateTime savedAt,  Map<String, List<WatchProvider>> availabilitySnapshot)  $default,) {final _that = this;
switch (_that) {
case _WatchlistItem():
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath,_that.releaseYear,_that.savedAt,_that.availabilitySnapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath,  String? releaseYear,  DateTime savedAt,  Map<String, List<WatchProvider>> availabilitySnapshot)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistItem() when $default != null:
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath,_that.releaseYear,_that.savedAt,_that.availabilitySnapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchlistItem implements WatchlistItem {
  const _WatchlistItem({required this.tmdbId, required this.title, required this.mediaType, this.posterPath, this.releaseYear, required this.savedAt, required final  Map<String, List<WatchProvider>> availabilitySnapshot}): _availabilitySnapshot = availabilitySnapshot;
  factory _WatchlistItem.fromJson(Map<String, dynamic> json) => _$WatchlistItemFromJson(json);

@override final  int tmdbId;
@override final  String title;
@override final  MediaType mediaType;
@override final  String? posterPath;
@override final  String? releaseYear;
@override final  DateTime savedAt;
 final  Map<String, List<WatchProvider>> _availabilitySnapshot;
@override Map<String, List<WatchProvider>> get availabilitySnapshot {
  if (_availabilitySnapshot is EqualUnmodifiableMapView) return _availabilitySnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_availabilitySnapshot);
}


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistItemCopyWith<_WatchlistItem> get copyWith => __$WatchlistItemCopyWithImpl<_WatchlistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistItem&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&const DeepCollectionEquality().equals(other._availabilitySnapshot, _availabilitySnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,mediaType,posterPath,releaseYear,savedAt,const DeepCollectionEquality().hash(_availabilitySnapshot));

@override
String toString() {
  return 'WatchlistItem(tmdbId: $tmdbId, title: $title, mediaType: $mediaType, posterPath: $posterPath, releaseYear: $releaseYear, savedAt: $savedAt, availabilitySnapshot: $availabilitySnapshot)';
}


}

/// @nodoc
abstract mixin class _$WatchlistItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory _$WatchlistItemCopyWith(_WatchlistItem value, $Res Function(_WatchlistItem) _then) = __$WatchlistItemCopyWithImpl;
@override @useResult
$Res call({
 int tmdbId, String title, MediaType mediaType, String? posterPath, String? releaseYear, DateTime savedAt, Map<String, List<WatchProvider>> availabilitySnapshot
});




}
/// @nodoc
class __$WatchlistItemCopyWithImpl<$Res>
    implements _$WatchlistItemCopyWith<$Res> {
  __$WatchlistItemCopyWithImpl(this._self, this._then);

  final _WatchlistItem _self;
  final $Res Function(_WatchlistItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tmdbId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,Object? releaseYear = freezed,Object? savedAt = null,Object? availabilitySnapshot = null,}) {
  return _then(_WatchlistItem(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as String?,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,availabilitySnapshot: null == availabilitySnapshot ? _self._availabilitySnapshot : availabilitySnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, List<WatchProvider>>,
  ));
}


}

// dart format on
