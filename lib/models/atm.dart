import 'dart:math';

import 'cash.dart';

/*void main() {
  var atm = CashMachine();

  List<Cash> _initialLoad = [];

  void generateCashToLoad() {
    Map<Cash, int> data = {
      Cash('5000'): 2,
      Cash('2000'): 5,
      Cash('1000'): 10,
      Cash('500'): 10,
      Cash('200'): 10,
      Cash('100'): 10,
    };

    for (Cash key in data.keys) {
      List<Cash> generatedCash = List.generate(data[key], (index) => key);
      _initialLoad.addAll(generatedCash);
    }
  }

  generateCashToLoad();

  atm.loadCash(_initialLoad);
  atm.printBanknoteStatus();
  print('ATM balance: ${atm.balance}');
  print('ATM minimal: ${atm.lowestCash}');

  atm.withdrawCash(6550);
  atm.printBanknoteStatus();
  print('ATM balance: ${atm.balance}');
  print('ATM minimal: ${atm.lowestCash}');

  atm.withdrawCash(9000);
  atm.printBanknoteStatus();
  print('ATM balance: ${atm.balance}');
  print('ATM minimal: ${atm.lowestCash}');

  atm.withdrawCash(1100);
  atm.printBanknoteStatus();
  print('ATM balance: ${atm.balance}');
  print('ATM minimal: ${atm.lowestCash}');
}*/

class ATM {
  List<Cash> _cashList = [];
  List<Cash> get cashList => _cashList;

  List<Cash> _deployedList = [];

  Map<String, int> get getDeployedList => cashListFilter(_deployedList);

  Map<String, int> get moneyLimits => cashListFilter(cashList);

  Map<String, int> cashListFilter(List<Cash> listToFilter) {
    Map<String, int> list = {};

    if (listToFilter.isNotEmpty) {
      for (Cash cashName in listToFilter) {
        String value = cashName.text;
        int quantity =
            listToFilter?.where((element) => element.text == value)?.length;

        list['$value'] = quantity;
      }
    }
    return list;
  }

  final List<Cash> cashValues = [
    Cash('5000'),
    Cash('2000'),
    Cash('1000'),
    Cash('500'),
    Cash('200'),
    Cash('100'),
  ];

  List<Cash> get displayedCashValues => [
        cashValues[5],
        cashValues[3],
        cashValues[4],
        cashValues[2],
        cashValues[1],
        cashValues[0],
      ];

  bool isCashWithdrawable = true;

  int get lowestCash =>
      _cashList?.map((element) => element.value)?.toList()?.reduce(min);

  int get balance => _cashList
      ?.map((element) => element.value)
      ?.toList()
      ?.fold(0, (previousValue, element) => previousValue + element);

  void loadCash(List<Cash> loadedCash) {
    List<Cash> validCash =
        loadedCash.where((element) => cashValues.contains(element)).toList();

    _cashList.addAll(validCash);

    _cashList.sort((a, b) => b.value - a.value);
  }

  void printBanknoteStatus() {
    print('Balance is:');
    for (String key in moneyLimits.keys) {
      print('$key: ${moneyLimits[key]}');
    }
  }

  void withdrawCash(int requestedCash) {
    print('Requested cash is: $requestedCash');
    List<Cash> withdraw = [];
    isCashWithdrawable = false;

    if (requestedCash > 0 &&
        _cashList.isNotEmpty &&
        (requestedCash % lowestCash == 0) &&
        requestedCash <= balance) {
      int rest = requestedCash;
      List<Cash> bufferList = List.from(_cashList);

      for (Cash cash in cashList) {
        if (rest < cash.value) {
          continue;
        } else {
          rest = rest - cash.value;
          bufferList.remove(cash);
          withdraw.add(cash);

          if (rest == 0) {
            _cashList = bufferList;
            _deployedList = withdraw;
            isCashWithdrawable = true;
            break;
          }
        }
      }
    } else {
      print('Cannot get requested cash amount');
      _deployedList = [];
    }
    print('Withdrawed cash:');
    _deployedList.forEach((element) => print('- ${element.text}'));
  }
}
