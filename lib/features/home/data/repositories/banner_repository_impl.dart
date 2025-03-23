import '../../domain/models/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import 'package:pampa_app/core/constants/image_paths.dart';

class BannerRepositoryImpl implements BannerRepository {
  // Mock data for main banners
  final List<BannerModel> _mockMainBanners = [
    BannerModel(
      id: '1',
      imageUrl: ImagePaths.bolleriaPath,
      title: 'Bollería Artesanal',
      description: 'Elaborada cada día con ingredientes de primera calidad',
      isActive: true,
    ),
    BannerModel(
      id: '2',
      imageUrl: ImagePaths.tartasPath,
      title: 'Tartas Caseras',
      description:
          'Descubre nuestra selección de tartas para cualquier ocasión',
      isActive: true,
    ),
    BannerModel(
      id: '3',
      imageUrl: ImagePaths.postresPath,
      title: 'Postres Individuales',
      description: 'Dulces elaborados con recetas tradicionales argentinas',
      isActive: true,
    ),
  ];

  // Mock data for promotional banners
  final List<BannerModel> _mockPromotionalBanners = [
    BannerModel(
      id: '4',
      imageUrl: ImagePaths.alfajoresPath,
      title: 'Alfajores Especiales',
      description: 'Nuevos sabores disponibles, ¡pruébalos todos!',
      isActive: true,
    ),
    BannerModel(
      id: '5',
      imageUrl: ImagePaths.galletasPath,
      title: 'Galletas Artesanales',
      description: '10% de descuento en pack familiar',
      isActive: true,
    ),
  ];

  @override
  Future<List<BannerModel>> getMainBanners() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMainBanners.where((banner) => banner.isActive).toList();
  }

  @override
  Future<List<BannerModel>> getPromotionalBanners() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockPromotionalBanners.where((banner) => banner.isActive).toList();
  }
}
