import '../estate/estate.dart';
import '../user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SessionRes {
  bool? success; // If request sending and response obtaining was successful
  bool? session; // Is the session still active or not
}

abstract class UserRes {
  bool? success; // If request sending and response obtaining was successful
}

abstract class EstateRes {
  bool? success; // If request sending and response obtaining was successful
}
