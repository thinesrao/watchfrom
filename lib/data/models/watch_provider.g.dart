// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchProvider _$WatchProviderFromJson(Map<String, dynamic> json) =>
    _WatchProvider(
      providerId: (json['providerId'] as num).toInt(),
      providerName: json['providerName'] as String,
      logoPath: json['logoPath'] as String,
      providerType: $enumDecode(_$ProviderTypeEnumMap, json['providerType']),
    );

Map<String, dynamic> _$WatchProviderToJson(_WatchProvider instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'logoPath': instance.logoPath,
      'providerType': _$ProviderTypeEnumMap[instance.providerType]!,
    };

const _$ProviderTypeEnumMap = {
  ProviderType.flatrate: 'flatrate',
  ProviderType.rent: 'rent',
  ProviderType.buy: 'buy',
};
