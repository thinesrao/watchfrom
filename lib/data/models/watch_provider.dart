import 'package:freezed_annotation/freezed_annotation.dart';

part 'watch_provider.freezed.dart';
part 'watch_provider.g.dart';

enum ProviderType { flatrate, rent, buy }

@freezed
abstract class WatchProvider with _$WatchProvider {
  const factory WatchProvider({
    required int providerId,
    required String providerName,
    required String logoPath,
    required ProviderType providerType,
  }) = _WatchProvider;

  factory WatchProvider.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderFromJson(json);

  factory WatchProvider.fromTmdb(
      Map<String, dynamic> json, ProviderType type) {
    return WatchProvider(
      providerId: json['provider_id'] as int,
      providerName: json['provider_name'] as String,
      logoPath: json['logo_path'] as String,
      providerType: type,
    );
  }
}
