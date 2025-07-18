class WeatherWarning {
  final String id;
  final String sender;
  final String pubTime;
  final String title;
  final String startTime;
  final String endTime;
  final String status;
  final String level;
  final String severity;
  final String severityColor;
  final String type;
  final String typeName;
  final String text;

  WeatherWarning({
    required this.id,
    required this.sender,
    required this.pubTime,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.level,
    required this.severity,
    required this.severityColor,
    required this.type,
    required this.typeName,
    required this.text,
  });

  factory WeatherWarning.fromJson(Map<String, dynamic> json) {
    return WeatherWarning(
      id: json['id'] ?? '',
      sender: json['sender'] ?? '',
      pubTime: json['pubTime'] ?? '',
      title: json['title'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
      level: json['level'] ?? '',
      severity: json['severity'] ?? '',
      severityColor: json['severityColor'] ?? '',
      type: json['type'] ?? '',
      typeName: json['typeName'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'pubTime': pubTime,
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
        'status': status,
        'level': level,
        'severity': severity,
        'severityColor': severityColor,
        'type': type,
        'typeName': typeName,
        'text': text,
      };
}
