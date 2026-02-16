import 'package:url_launcher/url_launcher.dart';

Future<void> openWeb(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Tidak bisa membuka $url';
  }
}
