// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/presentation/models/image_list_tile_item.dart';

class Outbounds extends ImageListTileItem {
  final String name;
  final String from;
  final String fromFlag;
  final String to;
  final String? toFlag;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final String? snapchatUrl;
  final String bio;
  final String imageUrl;
  final String? email;
  final String? phoneNumber;
  Outbounds(
      {required this.name,
      required this.from,
      required this.fromFlag,
      required this.to,
      required this.toFlag,
      this.facebookUrl,
      this.instagramUrl,
      this.websiteUrl,
      this.linkedinUrl,
      this.snapchatUrl,
      required this.bio,
      required this.imageUrl,
      this.email,
      this.phoneNumber});
}
