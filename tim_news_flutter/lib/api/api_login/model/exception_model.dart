class ExceptionModel {
  final String message;
  final String? errorCode;
  final String? errorType;

  ExceptionModel({
    required this.message,
    this.errorCode,
    this.errorType,
  });

  factory ExceptionModel.fromJson(Map<String, dynamic> json) {
    return ExceptionModel(
      message: json['message'] ?? '알 수 없는 오류가 발생했습니다.',
      errorCode: json['code'],
      errorType: json['errorType'],
    );
  }

  // 기본 에러 생성
  factory ExceptionModel.defaultError() {
    return ExceptionModel(
      message: '서버와의 연결에 문제가 발생했습니다.',
      errorCode: '0007',
    );
  }
}