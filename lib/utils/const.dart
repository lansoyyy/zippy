import 'dart:math';

String userId = '';

String logo = 'assets/images/logo.png';
String label = 'assets/images/label.png';
String avatar = 'assets/images/avatar.png';
String icon = 'assets/images/icon.png';
String label2 = 'assets/images/image.png';

List socials = [
  'assets/images/phone.png',
  'assets/images/apple.png',
  'assets/images/google.png',
  'assets/images/facebook.png'
];

List foodCategories = [
  'assets/images/fastfood.png',
  'assets/images/coffee.png',
  'assets/images/donut.png',
  'assets/images/bbq.png',
  'assets/images/pizza.png'
];
List foodCategoriesName = [
  'Fastfood',
  'Drinks',
  'Donut',
  'BBQ',
  'Pizza',
];

List shopCategories = [
  'Combo',
  'Meals',
  'Snacks',
  'Drinks',
  'Add-ons',
];

String home = 'assets/images/home.png';
String office = 'assets/images/office.png';
String groups = 'assets/images/groups.png';
String gcash = 'assets/images/image 5.png';
String paymaya = 'assets/images/image 6.png';
String bpi = 'assets/images/clarity_bank-solid.png';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double calculateTravelTimeInMinutes(double distance, double speed) {
  double travelTimeInSeconds = calculateTravelTime(distance, speed);
  return travelTimeInSeconds / 60.0;
}

double calculateTravelTime(double distance, double speed) {
  return distance / speed;
}
