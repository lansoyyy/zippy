import 'package:http/http.dart' as http;
import 'package:zippy/utils/keys.dart';

void sendSms() async {
  const String url = 'https://ws-v2.txtbox.com/messaging/v1/sms/push';

  Map<String, String> headers = {
    'X-TXTBOX-Auth': txboxKey,
  };

  Map<String, String> body = {
    'message': '123',
    'number': '09639530422',
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
