class Session {
  final String sessionId;
  final String code;

  Session({required this.sessionId, required this.code});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['data']['session_id']?.toString() ?? 'Unknown',
      code: json['data']['code'].toString(),
    );
  }
}
