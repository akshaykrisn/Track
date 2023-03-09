import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class busListScreenController extends GetxController{
  RxInt passengerType = 1.obs;

  List<String> StudentBus = [
    'S1',
    'S1-A',
    'S2',
    'S3',
    'S4',
    'S5',
    'S6',
    'S7',
    'S7A',
    'S7B',
    'S8',
    'S9',
    'S10',
    'S11'
  ];
  List<String> StaffBus = [
    '11',
    '122',
    '144',
    '188',
    '33',
    '55',
    '66'
  ];
}