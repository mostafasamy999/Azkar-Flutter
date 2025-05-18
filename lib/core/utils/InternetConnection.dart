import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternetConnection() async {
  final bool isConnected = await InternetConnectionChecker.instance.hasConnection;
  if (isConnected) {
    print('Device is connected to the internet');
    return true;
  } else {
    print('Device is not connected to the internet');
    return false;
  }

}
