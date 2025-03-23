import '../models/banner.dart';

abstract class BannerRepository {
  Future<List<BannerModel>> getMainBanners();
  Future<List<BannerModel>> getPromotionalBanners();
}
