import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  final platformAddress = 'http://localhost:8080';

  Future<http.Response> get(String endpoint) async {
    http.Response response =
        await http.get(Uri.parse(platformAddress + endpoint), headers: headers);
    updateCookie(response);

    return response;
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    http.Response response = await http.post(
        Uri.parse(platformAddress + endpoint),
        body: data,
        headers: headers);
    updateCookie(response);

    return response;
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
