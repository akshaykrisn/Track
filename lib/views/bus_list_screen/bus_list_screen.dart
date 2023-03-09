import 'package:busrm/controllers/bus_list_screen_controller.dart';
import 'package:busrm/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class busList extends StatelessWidget {
  var BusListScreenController = Get.put(busListScreenController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/busrm logo 2.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Select Your Route",
            maxLines: 2,
            style: TextStyle(
              color: bgColorDark,
              fontSize: 24,
              height: -1,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Passenger Type",
                maxLines: 2,
                style: TextStyle(
                  color: bgColorDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    BusListScreenController.passengerType.value == 2
                        ? BusListScreenController.passengerType.value = 1
                        : null;
                  },
                  child: Obx(
                    () => Container(
                      color: BusListScreenController.passengerType.value == 1
                          ? orange
                          : grey,
                      height: 45,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Center(
                        child: Text(
                          "Student",
                          style: TextStyle(
                            color:
                                BusListScreenController.passengerType.value == 1
                                    ? Colors.white
                                    : Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BusListScreenController.passengerType.value == 1
                        ? BusListScreenController.passengerType.value = 2
                        : null;
                  },
                  child: Obx(
                    () => Container(
                      color: BusListScreenController.passengerType.value == 2
                          ? orange
                          : grey,
                      height: 45,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Center(
                        child: Text(
                          "Faculty",
                          style: TextStyle(
                            color:
                                BusListScreenController.passengerType.value == 2
                                    ? Colors.white
                                    : Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          childCount: BusListScreenController.passengerType.value == 1
                                  ? BusListScreenController.StudentBus.length
                                  : BusListScreenController.StaffBus.length,
                          (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: ink,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    BusListScreenController
                                                .passengerType.value ==
                                            1
                                        ? BusListScreenController
                                            .StudentBus[index]
                                        : BusListScreenController
                                            .StaffBus[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 80,
                                decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          mainAxisExtent: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
