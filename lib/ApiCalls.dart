import 'package:http/http.dart' as http;

class ApiCalls {
  // static const _tokenInvertexto = '2010%7C9W0IulbT7YS6MwacbdF7MA7UxbxSCCQJ';
  static const _tokenInvertexto = '2207|eigpnwDwBkFOCtqTHqtFXIr6f573y3mV';
  static const _baseInvertexto = 'api.invertexto.com';

  static Future fetchCep ({required int cep}) {
    var url = Uri.https(_baseInvertexto, 'v1/cep/$cep', {'token': _tokenInvertexto});
    return http.get(url);
  }

  // static const Map<String, String> cepErrors {
  //   '422': 'f';
  // }
}