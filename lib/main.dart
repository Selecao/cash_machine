import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cashmachine/models/cash.dart';
import 'package:cashmachine/models/atm.dart';

void main() {
  runApp(CashMachine());
}

class CashMachine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var atm = ATM();

  TextStyle style =
      TextStyle(color: Colors.white, fontSize: 15, fontFamily: "SF  Pro  Text");

  final _textController = TextEditingController();
  String value;

  List<Cash> _generateCashToLoad() {
    List<Cash> _initialLoad = [];

    Map<Cash, int> bag = {
      Cash('5000'): 2,
      Cash('2000'): 5,
      Cash('1000'): 10,
      Cash('500'): 10,
      Cash('200'): 10,
      Cash('100'): 10,
    };

    for (Cash key in bag.keys) {
      List<Cash> generatedCash = List.generate(bag[key], (index) => key);
      _initialLoad.addAll(generatedCash);
    }
    return _initialLoad;
  }

  @override
  void initState() {
    super.initState();

    atm.loadCash(_generateCashToLoad());
    //_textController = TextEditingController(text: '1234');
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_atm.png',
            ),
            SizedBox(width: 3),
            Text('ATM'),
          ],
        ),
        flexibleSpace: Image.asset(
          'assets/images/back_app_bar.png',
          fit: BoxFit.cover,
        ),
        centerTitle: false,
        elevation: 10,

        //title: Text('Flutter Demo Home Page'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/back_top.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 29),
                          Text(
                            'Введите сумму',
                            style: style,
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              controller: _textController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                alignLabelWithHint: true,
                                /*suffixIcon: Text(
                                  '.00 руб',
                                  textAlign: TextAlign.left,
                                  style: style.copyWith(fontSize: 30),
                                ),*/
                                contentPadding: EdgeInsets.zero,
                                counterText: '',
                                isDense: true,
                                suffixText: '.00 руб',
                                suffixStyle: style.copyWith(fontSize: 30),
                              ),
                              cursorColor: Colors.white,
                              style: style.copyWith(fontSize: 30),
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              maxLength: 6,
                              onChanged: (value) {
                                print('input: $value');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              color: Color(0xFFe61ead),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                setState(() {
                  atm.withdrawCash(int.tryParse(_textController.text) ?? 0);
                  _textController.clear();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 40,
                ),
                child: Text(
                  'Выдать сумму',
                  style: style.copyWith(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            _separator(),
            atm.isOverLimit
                ? Container(
                    height: MediaQuery.of(context).size.width / 4,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Center(
                      /*padding: const EdgeInsets.symmetric(
                        vertical: 44,
                        horizontal: 55,
                      ),*/
                      child: Text(
                        'Банкомат не может выдать, запрашиваемую сумму',
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                          fontSize: 18,
                          color: Color(0xFFe61ead),
                        ),
                      ),
                    ),
                  )
                : _buildGridView(
                    text: 'Банкомат выдал следующие купюры',
                    cashGridList: atm.getDeployedList),
            _separator(),
            _buildGridView(
                text: 'Баланс банкомата', cashGridList: atm.moneyLimits),
            _separator(),
            //Spacer(),
            Image.asset(
              'assets/images/back_bottom.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView({String text, Map<String, int> cashGridList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            '$text',
            textAlign: TextAlign.left,
            style: style.copyWith(fontSize: 13, color: Color(0xFFa3a2ac)),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width / 4,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: IgnorePointer(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 10.0,
                mainAxisSpacing: 4,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (_, index) => GridTile(
                child: Text(
                  '${cashGridList[atm.displayedCashValues[index].text] ?? 0} X ${atm.displayedCashValues[index].text} рублей',
                  style: style.copyWith(
                    fontSize: 14,
                    color: Color(0xFF3827b4),
                  ),
                ),
              ),
              itemCount: atm.displayedCashValues.length,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _separator() {
  return Container(
    height: 10,
    color: Color(0xFF3827b4).withOpacity(0.06),
  );
}
