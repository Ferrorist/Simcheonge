class Bookmark {
  final int bookmarkId;
  final String bookmarkType;
  final int userId;
  final int? referencedId;
  final String? policyName;
  final String? postName;

  Bookmark({
    required this.bookmarkId,
    required this.bookmarkType,
    required this.userId,
    this.referencedId,
    this.policyName,
    this.postName,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      bookmarkId: json['bookmarkId'],
      bookmarkType: json['bookmarkType'],
      userId: json['userId'],
      referencedId: json['referencedId'],
      policyName: json['policyName'],
      postName: json['postName'],
    );
  }
}
