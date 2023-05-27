import 'package:firebaselogin/coinler/coinler_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Coins extends StatelessWidget {
  Coins({Key? key}) : super(key: key);

  Coins_Contoller coins_contoller = Get.put(Coins_Contoller());
  TextEditingController hrschange = TextEditingController();

  @override
  Widget build(BuildContext context) {
    coins_contoller.fetchCoin();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Kripto Borsa")),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          top: 16,
        ),
        child: Obx(() => ListView.builder(
            itemCount: coins_contoller.datas.length,
            itemBuilder: (BuildContext context, index) {
              double d = coins_contoller.datas[index].change;
              hrschange.text = d.toStringAsFixed(2);
              print(hrschange.text);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: Get.height / 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            child: Image.network(
                                coins_contoller.datas[index].imageUrl),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  coins_contoller.datas[index].name,
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                coins_contoller.datas[index].symbol,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Price: ${coins_contoller.datas[index].price.toString()}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w200),
                            ),
                            Row(
                              children: [
                                Text(
                                  "24Hrs Change: ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${hrschange.text}",
                                      style: TextStyle(
                                          color: coins_contoller
                                                      .datas[index].change <
                                                  0
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 13),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Percentage ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "${coins_contoller.datas[index].changePercentage.toString()}%",
                                  style: TextStyle(
                                      color: coins_contoller.datas[index]
                                                  .changePercentage <
                                              0
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 13),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }
}
