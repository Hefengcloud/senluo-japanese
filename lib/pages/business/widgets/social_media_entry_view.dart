import 'package:senluo_japanese_cms/pages/business/constants/marketing_constants.dart';
import 'package:senluo_japanese_cms/widgets/entry_view.dart';

class SocialMediaEntryView extends EntryView {
  final SocialMedia socialMedia;

  SocialMediaEntryView({
    super.key,
    required this.socialMedia,
    super.onTap,
  }) : super(title: socialMedia.name);
}
