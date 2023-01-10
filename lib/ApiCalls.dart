import 'dart:convert';

import 'package:http/http.dart' as http;

enum base { invertexto, receitaWs, sintegra }

class CepInexistenteException implements Exception {
  @override
  String toString(){
    return 'CEP Inexistente';
  }
}

class ApiCalls {
  late base selectedBase;

  late String cpf,
      cnpj,
      uf,
      cidade,
      logradouro,
      numero,
      razaoSocial,
      nomeFantasia,
      tipoLogradouro,
      bairro,
      cep;

  ApiCalls({required this.selectedBase}) {
    cpf = '';
    cnpj = '';
    uf = '';
    cidade = '';
    logradouro = '';
    numero = '';
    razaoSocial = '';
    nomeFantasia = '';
    tipoLogradouro = '';
    bairro = '';
    cep = '';
  }

  static const _tokenInvertexto = '2207|eigpnwDwBkFOCtqTHqtFXIr6f573y3mV';
  static const _baseInvertexto = 'api.invertexto.com';
  static const _tokenReceitaWs =
      '3c77537ac2aa6b0a79abcb02d29e51f350e7e0584bcfda5e27307794f59845b3';
  static const _tokenSintegra = 'AB2D0F18-C5ED-4C0A-891F-39004564C713';
  static const _baseReceitaWs = 'receitaws.com.br';
  static const _baseSintegra = 'www.sintegraws.com.br';
  static const _cnpjSintegra = '/api/v1/execute-api.php';

  Future fetchCep({required int cepToSearch}) {
    switch (selectedBase) {
      case base.invertexto:
        return _fetchCepInvertexto(cepToSearch: cepToSearch);
      case base.receitaWs:
        return _fetchCepInvertexto(cepToSearch: cepToSearch);
      case base.sintegra:
        return _fetchCepInvertexto(cepToSearch: cepToSearch);
    }
  }

  Future _fetchCepInvertexto({required int cepToSearch}) async {
    final url = Uri.https(
        _baseInvertexto, 'v1/cep/$cepToSearch', {'token': _tokenInvertexto});

    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw Future.error(CepInexistenteException());
    }
    Map body = await jsonDecode(response.body);

    logradouro = body['street'] ??= '';
    bairro = body['neighborhood'] ??= '';
    cidade = body['city'] ??= '';
    uf = body['state'] ??= '';
  }

  Future fetchCnpj({required int cnpjToSearch}) {
    switch (selectedBase) {
      case base.invertexto:
        return _fetchCnpjInvertexto(cnpjToSearch: cnpjToSearch);
      case base.receitaWs:
        return _fetchCnpjInvertexto(cnpjToSearch: cnpjToSearch);
      case base.sintegra:
        return _fetchCnpjInvertexto(cnpjToSearch: cnpjToSearch);
    }
  }

  Future _fetchCnpjInvertexto({required int cnpjToSearch}) async {
    final url = Uri.https(
        _baseInvertexto, 'v1/cnpj/$cnpjToSearch', {'token': _tokenInvertexto});

    http.Response response = await http.get(url);
    Map body = await jsonDecode(response.body);

    cnpj = body['cnpj'] ??= '';
    uf = body['endereco']['uf'] ??= '';
    cidade = body['endereco']['municipio'] ??= '';
    logradouro = body['endereco']['logradouro'] ??= '';
    numero = body['endereco']['numero'] ??= '';
    razaoSocial = body['razao_social'] ??= '';
    nomeFantasia = body['nome_fantasia'] ??= '';
    tipoLogradouro = body['endereco']['tipo_logradouro'] ??= '';
    cep = body['endereco']['cep'] ??= '';
    bairro = body['endereco']['bairro'] ??= '';
    print(numero);

    return body;
  }

  // static Future fetchCpf({required int cpf}) {
  //   var url = Uri.https();
  // }
}
