class TimeAgo {
  static String format(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Now';
    
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}