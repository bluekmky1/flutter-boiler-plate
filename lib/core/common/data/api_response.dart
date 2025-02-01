import 'package:json_annotation/json_annotation.dart';

part 'generated/api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    required this.transactionTime,
    required this.status,
    required this.description,
    required this.statusCode,
  });

  final T data;

  @JsonKey(name: 'transaction_time')
  final String transactionTime;

  final String status;
  final String? description;
  final int statusCode;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
