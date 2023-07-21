import 'dart:convert';
import 'package:http/http.dart' as network;

class NetworkHandler {
  NetworkHandler();

  Future getData(Uri url) async {
    network.Response response = await network.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      throw ('What went wrong: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
