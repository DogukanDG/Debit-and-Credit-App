import 'dart:convert';
import 'dart:ffi';

import 'package:firebaselogin/coinler/coinler_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Coins_Contoller extends GetxController {
  List datas = <CoinModel?>[].obs;

  Future<List> fetchCoin() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            datas.add(CoinModel.fromJson(map));
          }
        }
        print(datas.first.name);
        print(datas.last.name);
        this.datas = datas;
      }
      return datas;
    } else {
      throw Exception('Failed to load coins');
    }
  }
}
