import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';

class ClientData extends Object {
  late String? codProjeto,
      cnpj,
      razaoSocial,
      nome,
      cpf,
      dob,
      email,
      phone,
      cep,
      logradouro,
      numero,
      bairro,
      cidade,
      uf;
      late bool isPf; // Implement this flag everywhere

  // ClientData(
  //     {required this.codProjeto,
  //     required this.cep,
  //     required this.numero,
  //     required this.cidade,
  //     required this.bairro,
  //     required this.logradouro,
  //     required this.uf,
  //     this.cnpj,
  //     this.razaoSocial,
  //     required this.nome,
  //     required this.cpf,
  //     required this.dob,
  //     required this.email,
  //     required this.phone});
  ClientData();

  List<String> clientNames = [];

  Future sendData() async {
    CollectionReference clients = firestore.collection('clients');
    return clients.add({
      'codProjeto': codProjeto,
      // 'cnpj': cnpj ??= '',
      // 'razaoSocial': razaoSocial ??= '',
      'nome': nome,
      'cpf': cpf,
      'dob': dob,
      'email': email,
      'phone': phone,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf
    });
    
  }
  Future getData() async {
    CollectionReference clients = firestore.collection('oldClients');
    
    QuerySnapshot snapshot = await clients.get();
    Map<String, dynamic> data;
    
    snapshot.docs.forEach((element) {
      data = element.data() as Map<String, dynamic>;
      // print(data);
      if (data['nome'] != null)  clientNames.add(data['nome']) ;
    },);
    // print(clientNames);
    return clientNames;
  }

  // List<String> getNames() {
  //   getData()
  // }
}
