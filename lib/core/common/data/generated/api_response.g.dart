// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      data: fromJsonT(json['data']),
      transactionTime: json['transaction_time'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      statusCode: (json['statusCode'] as num).toInt(),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'transaction_time': instance.transactionTime,
      'status': instance.status,
      'description': instance.description,
      'statusCode': instance.statusCode,
    };
