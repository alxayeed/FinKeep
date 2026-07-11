import 'dart:developer' as developer;
import 'package:finkeep/core/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'exceptions.dart';
import 'failure.dart';

class ExceptionHandler {
  /// Handles, logs, and maps any exception to a [Failure] object.
  /// 
  /// [exception] is the caught error (dynamic).
  /// [stackTrace] is the optional StackTrace.
  /// [context] is a description of where the error occurred (e.g., 'AuthController.login').
  static Failure handle(dynamic exception, [StackTrace? stackTrace, String? context]) {
    final logMessage = 'Exception caught${context != null ? ' in $context' : ''}';
    
    // Log the error and stack trace to the console
    developer.log(
      logMessage,
      name: 'ExceptionHandler',
      error: exception,
      stackTrace: stackTrace,
    );

    // Map to Failure if it is an Exception we recognize
    if (exception is Failure) {
      return exception;
    }

    final exceptionStr = exception.toString();
    if (exception is FirebaseAuthException || 
        exception is PlatformException || 
        exceptionStr.contains('firebase_auth') || 
        exceptionStr.contains('auth/')) {
      
      String code = '';
      String message = exceptionStr;
      
      if (exception is FirebaseAuthException) {
        code = exception.code;
        message = exception.message ?? exceptionStr;
      } else if (exception is PlatformException) {
        code = exception.code;
        message = exception.message ?? exceptionStr;
      }
      
      // If code is empty but exceptionStr has [category/code] pattern (e.g. from PlatformException/Pigeon)
      if (code.isEmpty || code.contains('/') || code.contains('firebase_auth')) {
        final regex = RegExp(r'\[([^\]]+)\]');
        final match = regex.firstMatch(exceptionStr);
        if (match != null) {
          code = match.group(1) ?? code;
        }
      }
      
      // Clean up firebase prefix if code looks like 'firebase_auth/invalid-credential'
      if (code.contains('/')) {
        code = code.split('/').last;
      }
      
      String userMessage = 'Incorrect email or password.';
      switch (code) {
        case 'invalid-credential':
        case 'wrong-password':
          userMessage = 'Incorrect email or password.';
          break;
        case 'user-not-found':
          userMessage = 'No user account found with this email.';
          break;
        case 'user-disabled':
          userMessage = 'This account has been disabled.';
          break;
        case 'invalid-email':
          userMessage = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          userMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          final cleanedMessage = message.replaceAll(RegExp(r'\[[^\]]+\]'), '').trim();
          if (cleanedMessage.isNotEmpty) {
            userMessage = cleanedMessage;
          }
      }
      return AuthenticationFailure(message: userMessage);
    }

    if (exception is FirebaseException) {
      if (exception.code == 'permission-denied') {
        return ServerFailure(message: 'Permission denied. Please check your account.');
      }
      return ServerFailure(message: exception.message ?? 'Firebase service error.');
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is ParsingException) {
      return ParsingFailure(message: exception.message);
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(message: exception.message);
    } else if (exception is UnknownException) {
      return UnknownFailure(message: exception.message);
    } else if (exception is Exception) {
      // General exception
      return UnknownFailure(message: exception.toString().replaceAll('Exception: ', ''));
    }

    // Dynamic error fallback
    final message = exception?.toString() ?? AppStrings.unknownError;
    return UnknownFailure(message: message);
  }
}
