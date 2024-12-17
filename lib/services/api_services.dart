import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class APIServices extends GetxService {
  var logger = Logger();
  final dio.Dio _dio = dio.Dio();

  static const String baseUrl = 'https://amanuelglass.com/';

  APIServices() {
    _basicDioConfiguraion();
  }

  void _basicDioConfiguraion() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add proper headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Configure validateStatus to handle all status codes
    _dio.options.validateStatus = (status) {
      return status! < 500; // Accept all status codes less than 500
    };
  }

  Future<dio.Response> getRequest(String url, {var payload}) async {
    try {
      logger.i("GET Request to: ${_dio.options.baseUrl}$url");
      logger.d("Headers: ${_dio.options.headers}");

      final response = await _dio.get(
        url,
        queryParameters: payload, // Use queryParameters instead of data for GET
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
          responseType: dio.ResponseType.json,
        ),
      );

      logger.i("Response Status: ${response.statusCode}");
      logger.d("Response Data: ${response.data}");

      return response;
    } on dio.DioException catch (e) {
      logger.e("DioException: ${e.message}", error: e);
      if (e.response?.statusCode == 500) {
        logger.e("Server Error: ${e.response?.data}");
      }
      rethrow;
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }

  Future<dio.Response> postRequest(String url, {var payload}) async {
    try {
      logger.i("POST Request to: ${_dio.options.baseUrl}$url");
      logger.d("Headers: ${_dio.options.headers}");
      logger.d("Payload: $payload");

      final response = await _dio.post(
        url,
        data: payload, // Payload remains key-value pairs
        options: dio.Options(
          contentType:
              dio.Headers.formUrlEncodedContentType, // Set to form-url-encoded
          responseType: dio.ResponseType.json,
        ),
      );

      logger.i("Response Status: ${response.statusCode}");
      logger.d("Response Data: ${response.data}");

      return response;
    } on dio.DioException catch (e) {
      logger.e("DioException: ${e.message}", error: e);
      if (e.response?.statusCode == 500) {
        logger.e("Server Error: ${e.response?.data}");
      }
      rethrow;
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }

  Future<dio.Response> postJsonRequest(String url, {var payload}) async {
    try {
      final endpoint = url.startsWith('/') ? url.substring(1) : url;
      
      logger.i("POST Request to: ${_dio.options.baseUrl}$endpoint");
      logger.d("Headers: ${_dio.options.headers}");
      logger.d("Original Payload: $payload");

      // Convert the payload to form data format
      final formData = dio.FormData.fromMap(Map<String, dynamic>.from(payload));
      
      logger.d("Form Data: $formData");

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: dio.Options(
          contentType: dio.Headers.formUrlEncodedContentType,  // Changed to form-urlencoded
          responseType: dio.ResponseType.json,
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );

      logger.i("Response Status: ${response.statusCode}");
      logger.d("Response Data: ${response.data}");

      return response;
    } on dio.DioException catch (e) {
      logger.e("DioException: ${e.message}", error: e);
      logger.e("Response: ${e.response?.data}");
      rethrow;
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }
}
