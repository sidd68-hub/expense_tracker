import 'package:flutter/foundation.dart';

void main(){
  // 1010101 change it Octal 0 to 7
  // 1*2^0 = 1
  // 0* 2^1 = 0
  // 1* 2 ^2 =4
  // 0* 2^3=0
  // 1* 2^4=16
  // 0* 2^5=0
  // 1* 2^6=64
  // Total = 64+16+4+1 = 85
  // Output :- 125
  getOctalCode('1010101');
}

getOctalCode(String number){
  String reverseNumber = getReverse(number);
  print("The Original Number $number and Reverse Number is $reverseNumber");
  for(int i =0; i<reverseNumber.length;i++){

  }
}

String getReverse(String number){
  List <String> newData = [];
  String data;
  for(int i = number.length -1; i >= 0 ;i--){
    newData.add(number[i]);
  }

  return newData.join("");
}


