import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modal/model.dart';
import 'api.dart';

class BranchService {
  static Future<List<Branch>> fetchBranches() async {
    final response = await http.get(Uri.parse('$api/branches'));
    final data = json.decode(response.body);
    return (data['response']['result'] as List)
        .map((json) => Branch.fromJson(json))
        .toList();
  }

  static Future<List<Flyer>> fetchFlyers(String branchCode) async {
    final response = await http.get(
      Uri.parse('$api/flyersuser&branchCode=$branchCode'),
    );
    final data = json.decode(response.body);

    return (data['response']['result'] as List)
        .map((json) => Flyer.fromJson(json))
        .toList();
  }
}
