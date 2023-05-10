import 'dart:isolate';

enum ErrorCode { unAuthenticate, badRequest, internal }

ErrorCode errorCode(String from) {
  switch (from) {
    case "BAD_REQUEST":
      return ErrorCode.badRequest;
    case "UNAUTHORIZED":
      return ErrorCode.unAuthenticate;
    default:
      return ErrorCode.internal;
  }
}

class AppError extends RemoteError {
  ErrorCode code;
  String message;

  AppError({this.message = "", this.code = ErrorCode.internal})
      : super(message, "");

  static AppError defaultError() {
    return AppError(message: "エラーが発生しました");
  }

  String displayMessage() {
    switch (code) {
      case ErrorCode.badRequest:
        return message;
      case ErrorCode.unAuthenticate:
        return "";
      case ErrorCode.internal:
        return "エラーが発生しました";
    }
  }
}
