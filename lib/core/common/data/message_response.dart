import 'package:json_annotation/json_annotation.dart';

part 'generated/message_response.g.dart';

@JsonSerializable()
class MessageResponse {
  const MessageResponse({
    required this.message,
  });

  final String message;

  factory MessageResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MessageResponseFromJson(json);
}
