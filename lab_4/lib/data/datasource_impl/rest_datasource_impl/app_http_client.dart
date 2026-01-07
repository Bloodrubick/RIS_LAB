import 'dart:convert';

import 'package:http/http.dart' as http;

class AppHttpClient {
  final http.Client _client = http.Client();

  Future<String?> getDecodedResponse(String url) async {
    try {
      final http.Response response = await _client.get(Uri.parse(url));
      return response.statusCode == 200 ? utf8.decode(response.bodyBytes) : null;
    } catch (e) {
      return null;
    }
  }

  void dispose() => _client.close();
}
