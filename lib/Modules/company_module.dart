import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModule {
  static List<String> companylist = [];
  final String name;

  const CompanyModule({required this.name});

  factory CompanyModule.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return CompanyModule(name: data["name"]);
  }
}
