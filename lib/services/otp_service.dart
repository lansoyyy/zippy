import 'package:http/http.dart' as http;
import 'package:zippy/utils/keys.dart';

void sendSms(String number, String otp) async {
  const String url = 'https://ws-v2.txtbox.com/messaging/v1/sms/push';

  Map<String, String> headers = {
    'X-TXTBOX-Auth': txboxKey,
  };

  Map<String, String> body = {
    'message': '$otp is your OTP. Do not share it.',
    'number': number,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);
  } catch (e) {
    print('Error: $e');
  }
}
