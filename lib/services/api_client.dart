//first add http package
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient{
  final Uri currencyURL = Uri.https("free.currconv.com","/api/v7/currencies",
      {"apiKey":"8ce60f4193dd91695657"});
      //first parameter of URI should be just the main url
      //second parameter will be the endpoint
      //the last parameter is a map for the different properties

      //Now Make a Function to get the currencies list
      Future<List<String>> getCurrencies() async{
        http.Response res = await http.get(currencyURL);
        if(res.statusCode ==200){
          var body = jsonDecode(res.body);
          var list = body["results"];
          List<String> currencies = (list.keys).toList();
          print(currencies);
          return currencies;

        }else {
          throw Exception("Failed to connect to API");
        }
      }
      //getting exchange rate
      Future<double> getRate(String from,String to) async{
        final Uri rateUrl = Uri.https("free.currconv.com","/api/v7/convert",
            {"apiKey":"8ce60f4193dd91695657",
              "q":"${from}_${to}",
              "compact":"ultra"});
        http.Response res = await http.get(rateUrl);
        if(res.statusCode == 200){
          var body = jsonDecode(res.body);
          return body["${from}_${to}"];

        }else{
          throw Exception("Failed to connect to API");

        }
      }

      }
