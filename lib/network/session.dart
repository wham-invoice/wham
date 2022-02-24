import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);

    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response =
        await http.post(Uri.parse(url), body: data, headers: headers);
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
