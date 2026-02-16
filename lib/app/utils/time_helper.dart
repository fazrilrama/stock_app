String timeAgo(String dateString) {
  if (dateString.isEmpty) return 'Just now';

  DateTime date = DateTime.tryParse(dateString) ?? DateTime.now();
  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) {
    return 'Just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} menit lalu';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} jam lalu';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} hari lalu';
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}
