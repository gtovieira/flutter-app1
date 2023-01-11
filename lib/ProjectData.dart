import 'package:flutter_application_1/ClientData.dart';
import 'dart:io';

enum tipoEstrutura { metalico, fibrocimento, solo, ceramico, laje, carport }

class Conta extends Object {
  String? contaContrato, titular, cpf, cnpj;
  double? porcentagem;
}

class ProjectData extends Object {
  late ClientData client;
  String? codProjeto,
      nome, razaoSocial,
      cpf,
      cnpj,
      logradouro,
      cidade,
      uf,
      bairro,
      cep,
      contaContrato,
      mapsLink,
      kit,
      vendedor,
      senhaCoelba,
      observacoes,
      pontoReferencia,
      formaPagamento,
      detalhePagamento,
      nfNome,
      nfCpf,
      nfCnpj,
      nfEndereco,
      nfCep, nfObs;
  late DateTime dataFechamento;
  late double lat, long, preco;
  bool? contaContratoExistente, enviaCreditos, trocaTitularidade;
  File? cnh, fotoFachada, procuracao;

  ProjectData();
}
