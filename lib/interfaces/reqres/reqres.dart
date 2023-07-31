import 'dart:ffi';

import '../estate/estate.dart';
import '../user/user.dart';

abstract class UserRes {
  Bool? success; // If request sending and response obtaining was successful
  List<Individual>? user;
  List<Company>? user2;
  
  List<IndividualEstate>? estates;
  List<CompanyEstate>? estates2;
}

abstract class SessionRes {
  Bool? success; // If request sending and response obtaining was successful
  Bool? session; // Is the session still active or not
}