import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/ClientData.dart';
import 'dart:io';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoKit.dart';

enum tipoEstrutura { metalico, fibrocimento, solo, ceramico, laje, carport }

class Inverter {
  late String modelo, fabricante;
  late num potencia, fases, tensao;

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

class Estrutura {
  late String tipoEstrutura;

  Estrutura({required this.tipoEstrutura});

  @override
  String toString() {
    return tipoEstrutura;
  }
}

class Conta extends Object {
  String? contaContrato, titular, cpf, cnpj;
  num? porcentagem;
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
      nfRazaoSocial,
      nfCpf,
      nfCnpj,
      nfEndereco,
      nfNumero,
      nfBairro,
      nfCidade,
      nfCep,
      nfUf,
      nfObs;
  late DateTime dataFechamento;
  late double lat, long, preco;
  bool? contaContratoExistente, enviaCreditos;
  File? identidade, fotoFachada, procuracao;
  List<Inverter> selectedInverterList = [];
  List<int> inverterQty = [];
  List<Module> selectedModuleList = [];
  List<int> moduleQty = [];
  late double potenciaAc;
  late double potenciaDc;

  ProjectData();

  List<String> invertersListAsString = [];

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
    List<Inverter> invertersList = [];

    CollectionReference inverters = firestore.collection('inverters');
    QuerySnapshot snapshot = await inverters.get();
    Map<String, dynamic> data;

    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      Inverter inv = Inverter(
          fabricante: data['fabricante'] ??= '',
          modelo: data['modelo'] ??= '',
          fases: data['fases'] ??= 0,
          potencia: data['potencia'] ??= 0,
          tensao: data['tensao'] ??= 0);
      invertersList.add(inv);
    });
    return invertersList;
  }

  Future getModules() async {
    List<Module> moduleList = [];

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

  Future getStructure() async {
    List<Estrutura> estruturaList = [];

    CollectionReference structure = firestore.collection('structure');
    QuerySnapshot snapshot = await structure.get();
    Map<String, dynamic> data;

    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      Estrutura str = Estrutura(tipoEstrutura: data['tipo']);
      estruturaList.add(str);
    });
    return estruturaList;
  }

  Future getData() async {
    // CollectionReference projects = firestore.collection('inverters');
  }
}
