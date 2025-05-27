
import '../../../widgets/entry_view.dart';
import '../constants/marketing_constants.dart';

class SocialMediaEntryView extends EntryView {
  final SocialMedia socialMedia;

  SocialMediaEntryView({
    super.key,
    required this.socialMedia,
    super.onTap,
  }) : super(title: socialMedia.name);
}
