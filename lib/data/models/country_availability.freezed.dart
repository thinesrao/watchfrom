// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountryAvailability {

 String get countryCode; String get countryName; String get flagEmoji; List<WatchProvider> get providers;
/// Create a copy of CountryAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryAvailabilityCopyWith<CountryAvailability> get copyWith => _$CountryAvailabilityCopyWithImpl<CountryAvailability>(this as CountryAvailability, _$identity);

  /// Serializes this CountryAvailability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryAvailability&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.flagEmoji, flagEmoji) || other.flagEmoji == flagEmoji)&&const DeepCollectionEquality().equals(other.providers, providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,flagEmoji,const DeepCollectionEquality().hash(providers));

@override
String toString() {
  return 'CountryAvailability(countryCode: $countryCode, countryName: $countryName, flagEmoji: $flagEmoji, providers: $providers)';
}


}

/// @nodoc
abstract mixin class $CountryAvailabilityCopyWith<$Res>  {
  factory $CountryAvailabilityCopyWith(CountryAvailability value, $Res Function(CountryAvailability) _then) = _$CountryAvailabilityCopyWithImpl;
@useResult
$Res call({
 String countryCode, String countryName, String flagEmoji, List<WatchProvider> providers
});




}
/// @nodoc
class _$CountryAvailabilityCopyWithImpl<$Res>
    implements $CountryAvailabilityCopyWith<$Res> {
  _$CountryAvailabilityCopyWithImpl(this._self, this._then);

  final CountryAvailability _self;
  final $Res Function(CountryAvailability) _then;

/// Create a copy of CountryAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? countryName = null,Object? flagEmoji = null,Object? providers = null,}) {
  return _then(_self.copyWith(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,flagEmoji: null == flagEmoji ? _self.flagEmoji : flagEmoji // ignore: cast_nullable_to_non_nullable
as String,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryAvailability].
extension CountryAvailabilityPatterns on CountryAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryAvailability value)  $default,){
final _that = this;
switch (_that) {
case _CountryAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _CountryAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  String countryName,  String flagEmoji,  List<WatchProvider> providers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryAvailability() when $default != null:
return $default(_that.countryCode,_that.countryName,_that.flagEmoji,_that.providers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  String countryName,  String flagEmoji,  List<WatchProvider> providers)  $default,) {final _that = this;
switch (_that) {
case _CountryAvailability():
return $default(_that.countryCode,_that.countryName,_that.flagEmoji,_that.providers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  String countryName,  String flagEmoji,  List<WatchProvider> providers)?  $default,) {final _that = this;
switch (_that) {
case _CountryAvailability() when $default != null:
return $default(_that.countryCode,_that.countryName,_that.flagEmoji,_that.providers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountryAvailability implements CountryAvailability {
  const _CountryAvailability({required this.countryCode, required this.countryName, required this.flagEmoji, required final  List<WatchProvider> providers}): _providers = providers;
  factory _CountryAvailability.fromJson(Map<String, dynamic> json) => _$CountryAvailabilityFromJson(json);

@override final  String countryCode;
@override final  String countryName;
@override final  String flagEmoji;
 final  List<WatchProvider> _providers;
@override List<WatchProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}


/// Create a copy of CountryAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryAvailabilityCopyWith<_CountryAvailability> get copyWith => __$CountryAvailabilityCopyWithImpl<_CountryAvailability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountryAvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryAvailability&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.flagEmoji, flagEmoji) || other.flagEmoji == flagEmoji)&&const DeepCollectionEquality().equals(other._providers, _providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,flagEmoji,const DeepCollectionEquality().hash(_providers));

@override
String toString() {
  return 'CountryAvailability(countryCode: $countryCode, countryName: $countryName, flagEmoji: $flagEmoji, providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$CountryAvailabilityCopyWith<$Res> implements $CountryAvailabilityCopyWith<$Res> {
  factory _$CountryAvailabilityCopyWith(_CountryAvailability value, $Res Function(_CountryAvailability) _then) = __$CountryAvailabilityCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, String countryName, String flagEmoji, List<WatchProvider> providers
});




}
/// @nodoc
class __$CountryAvailabilityCopyWithImpl<$Res>
    implements _$CountryAvailabilityCopyWith<$Res> {
  __$CountryAvailabilityCopyWithImpl(this._self, this._then);

  final _CountryAvailability _self;
  final $Res Function(_CountryAvailability) _then;

/// Create a copy of CountryAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? countryName = null,Object? flagEmoji = null,Object? providers = null,}) {
  return _then(_CountryAvailability(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,flagEmoji: null == flagEmoji ? _self.flagEmoji : flagEmoji // ignore: cast_nullable_to_non_nullable
as String,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>,
  ));
}


}

// dart format on
