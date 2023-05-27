class CoinModel {
  CoinModel(
      {required this.name,
      required this.symbol,
      required this.price,
      required this.imageUrl,
      required this.change,
      required this.changePercentage});

  String name;
  String symbol;
  String imageUrl;
  num price;
  num change;
  num changePercentage;

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
        name: json["name"],
        symbol: json["symbol"],
        price: json["current_price"],
        imageUrl: json["image"],
        change: json["price_change_24h"],
        changePercentage: json["price_change_percentage_24h"]);
  }
}
