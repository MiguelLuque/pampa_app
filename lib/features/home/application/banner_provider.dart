import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/banner_repository_impl.dart';
import '../domain/models/banner.dart';
import '../domain/repositories/banner_repository.dart';

part 'banner_provider.g.dart';

@riverpod
BannerRepository bannerRepository(ref) {
  return BannerRepositoryImpl();
}

@riverpod
Future<List<BannerModel>> mainBanners(ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getMainBanners();
}

@riverpod
Future<List<BannerModel>> promotionalBanners(ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getPromotionalBanners();
}
