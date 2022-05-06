import 'dart:ui';

import 'package:cconvert/services/api_client.dart';
import 'package:cconvert/widgets/drop_down.dart';
import 'package:flutter/material.dart';

//to run main app
void main() {
  runApp(MyApp());
}

//Homepage of app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:HomePage() ,
    );
  }
}

//we can add containers etc
class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  //first create an instance of the API client
  ApiClient client = ApiClient();
  //Setting the Main Colors
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  //Setting the variables
  List<String> currencies;
  String from;
  String to;

  //variables for exchange rates
  double rate;
  String result = "";

  //make a function to call the api

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async{
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.0,
                  child: Text("Currency Converter",style:TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,

                  )),

                ),
                Expanded(child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //set the text field
                      TextField(
                        onSubmitted: (value) async{
                          //now make the function to get the exchange rates
                          rate = await client.getRate(from, to);
                          setState(() {
                            result = (rate * double.parse(value)).toStringAsFixed(3);
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Input value to convert",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            color: secondColor,
                          )),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [
                          //we can't give drop menu an empty list, so we need
                          //to create a function to get the available
                          //currencies from API

                          //custom widget for the currencies drop down button
                          customDropDown(currencies, from, (val){
                            setState(() {
                              from = val;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: (){
                              String temp = from;
                              setState(() {
                                from = to;
                                to = temp;

                              });
                            },
                            child: Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor: secondColor,),

                          customDropDown(currencies, to, (val){
                            setState(() {
                              to = val;
                            });
                          }),

                        ],
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        width: double.infinity,
                        padding:  EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),

                        ),
                        child: Column(
                          children: [
                            Text("Result",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            )),
                            Text(result, style: TextStyle(
                              color: secondColor,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            )),
                          ],
                        ),

                      )

                    ],
                  ),
                ))
              ],

            ),
          ),
        ),
    );
  }
}
