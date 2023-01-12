import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/ClientData.dart';
import 'dart:io';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage2.dart';

enum tipoEstrutura { metalico, fibrocimento, solo, ceramico, laje, carport }

class Inverter {
  late String modelo, fabricante;
  late double potencia;
  late int fases, tensao;

  Inverter(
      {required this.modelo,
      required this.fabricante,
      required this.potencia,
      required this.fases,
      required this.tensao});

  @override
  String toString() {
    return modelo;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Inverter &&
        other.modelo == modelo &&
        other.potencia == potencia;
  }

  @override
  int get hashCode => Object.hash(modelo, potencia);
}

class Module {
  late String modelo, fabricante;
  late int potencia;

  Module(
      {required this.modelo, required this.potencia, required this.fabricante});

  @override
  String toString() {
    return modelo;
  }
}

class Conta extends Object {
  String? contaContrato, titular, cpf, cnpj;
  double? porcentagem;
}

class ProjectData extends Object {
  late ClientData client;
  String? codProjeto,
      nome,
      razaoSocial,
      cpf,
      cnpj,
      logradouro,
      cidade,
      uf,
      bairro,
      numero,
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
      nfCep,
      nfObs;
  late DateTime dataFechamento;
  late double lat, long, preco;
  bool? contaContratoExistente, enviaCreditos, trocaTitularidade;
  File? cnh, fotoFachada, procuracao;

  ProjectData();

  List<String> invertersListAsString = [];
  List<Inverter> invertersList = [];

  Future getInvertersAsString() async {
    CollectionReference inverters = firestore.collection('inverters');
    QuerySnapshot snapshot = await inverters.get();
    Map<String, dynamic> data;

    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      if (data['modelo'] != null) invertersListAsString.add(data['modelo']!);
    });
    return invertersListAsString;
  }

  Future getInverters() async {
    CollectionReference inverters = firestore.collection('inverters');
    QuerySnapshot snapshot = await inverters.get();
    Map<String, dynamic> data;

    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      Inverter inv = Inverter(
          fabricante: data['fabricante'] ??= '',
          modelo: data['modelo'] ??= '',
          fases: data['fases'] ??= 0,
          potencia: data['potencia'] ??= 0.0,
          tensao: data['tensao'] ??= 0);
      invertersList.add(inv);
    });
    return invertersList;
  }

  Future getModules() async {
    CollectionReference modules = firestore.collection('modules');
    QuerySnapshot snapshot = await modules.get();
    Map<String, dynamic> data;

    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      Module mod = Module(
          modelo: data['modelo'],
          potencia: data['potencia'],
          fabricante: data['fabricante']);
      moduleList.add(mod);
    });
    return moduleList;
  }

  Future getData() async {
    // CollectionReference projects = firestore.collection('inverters');
  }
}
