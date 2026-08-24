// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CountryAvailability _$CountryAvailabilityFromJson(Map<String, dynamic> json) =>
    _CountryAvailability(
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
      flagEmoji: json['flagEmoji'] as String,
      providers: (json['providers'] as List<dynamic>)
          .map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryAvailabilityToJson(
  _CountryAvailability instance,
) => <String, dynamic>{
  'countryCode': instance.countryCode,
  'countryName': instance.countryName,
  'flagEmoji': instance.flagEmoji,
  'providers': instance.providers.map((e) => e.toJson()).toList(),
};
