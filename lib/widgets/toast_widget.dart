import 'package:fluttertoast/fluttertoast.dart';
import 'package:zippy/utils/colors.dart';

Future<bool?> showToast(msg) {
  return Fluttertoast.showToast(
    backgroundColor: secondary,
    toastLength: Toast.LENGTH_LONG,
    msg: msg,
  );
}
