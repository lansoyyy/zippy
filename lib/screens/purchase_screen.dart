import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Map<String, dynamic>? userData;
  String? profileImage;

  bool hasLoaded = true;

  @override
  void initState() {
    super.initState();

    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      userDoc.snapshots().listen((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            userData = data;
            profileImage = data['profile'];
          });
        } else {
          showToast('User data not found.');
        }
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasLoaded
          ? Stack(
              children: [
                _buildTopSection(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: secondary,
              ),
            ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: const BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCravingOptions(),
        ],
      ),
    );
  }

  Widget _buildCravingOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCravingOption(
          Icons.fastfood_outlined,
          'Food',
          false,
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
        _buildCravingOption(
            Icons.production_quantity_limits_sharp, 'Purchase', true,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PurchaseScreen()))),
        _buildCravingOption(Icons.directions_car_filled_outlined, 'Ride', false,
            onTap: () => showToast('Coming soon.')),
        _buildCravingOption(Icons.card_giftcard, 'Surprise', false,
            onTap: () => showToast('Coming soon.')),
        _buildCravingOption(Icons.local_shipping_outlined, 'Package', false,
            onTap: () => showToast('Coming soon.')),
      ],
    );
  }

  Widget _buildCravingOption(IconData icon, String label, bool selected,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 5.0),
          Text(label,
              style:
                  const TextStyle(color: Colors.white, fontFamily: 'Medium')),
          if (selected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 40.0,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 275,
              child: TextWidget(
                align: TextAlign.start,
                text:
                    'Hi! ${'${userData?['name'].toString().split(' ')[0]}' ?? 'User'}, Welcome Back!',
                fontSize: 22,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
              child: CircleAvatar(
                maxRadius: 25,
                minRadius: 25,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : const AssetImage('assets/images/Group 121 (2).png')
                        as ImageProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SearchPage()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What are you craving today?',
                    hintStyle: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
