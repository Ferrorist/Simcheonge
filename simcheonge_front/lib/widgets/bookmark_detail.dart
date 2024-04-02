class Bookmark {
  final int bookmarkId;
  final String bookmarkType;
  final int userId;
  final int? policyId;
  final String? policyName;
  final int? postId;
  final String? postName;

  Bookmark({
    required this.bookmarkId,
    required this.bookmarkType,
    required this.userId,
    this.policyId,
    this.policyName,
    this.postId,
    this.postName,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      bookmarkId: json['bookmarkId'],
      bookmarkType: json['bookmarkType'],
      userId: json['userId'],
      policyId: json['policyId'],
      policyName: json['policyName'],
      postId: json['postId'],
      postName: json['postName'],
    );
  }
}
