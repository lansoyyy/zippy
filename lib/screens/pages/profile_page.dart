import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/toast_widget.dart';

import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Map<String, dynamic>? userData;
  File? _image;
  String? profileImage;
  bool isEditing = false;
  bool isEditingEmail = false;
  bool isEditingNumber = false;
  bool isEditingBday = false;
  bool isEditingHome = false;
  bool isEditingOffice = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController bdayController = TextEditingController();
  final TextEditingController homeController = TextEditingController();
  final TextEditingController officeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final userDoc = _firestore.collection('Users').doc(userId);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userData = data;
          profileImage = data['profile'];
          nameController.text = data['name'];
        });
      } else {
        showToast('User data not found.');
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _updateField(
      String field, String value, VoidCallback onSuccess) async {
    try {
      await _firestore.collection('Users').doc(userId).update({field: value});
      setState(() {
        userData![field] = value;
        onSuccess();
      });
      showToast('$field updated successfully.');
    } catch (e) {
      print("Error updating $field: $e");
      showToast('Failed to update $field.');
    }
  }

  Future<void> updateName() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'name': nameController.text});
      setState(() {
        userData!['name'] = nameController.text;
        isEditing = false;
      });
      showToast('Name updated successfully.');
    } catch (e) {
      print("Error updating name: $e");
      showToast('Failed to update name.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$userId.jpg');

        await ref.putFile(_image!);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({'profile': url});

        setState(() {
          profileImage = url;
        });

        showToast('Profile Image Updated');
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> updateEmail() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'email': emailController.text});
      setState(() {
        userData!['email'] = emailController.text;
        isEditingEmail = false;
      });
      showToast('Email updated successfully.');
    } catch (e) {
      print("Error updating email: $e");
      showToast('Failed to update email.');
    }
  }

  Future<void> updateNumber() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'number': numberController.text});
      setState(() {
        userData!['number'] = numberController.text;
        isEditingNumber = false;
      });
      showToast('Number updated successfully.');
    } catch (e) {
      print("Error updating number: $e");
      showToast('Failed to update number.');
    }
  }

  Future<void> updateBday() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'bday': bdayController.text});
      setState(() {
        userData!['bday'] = bdayController.text;
        isEditingBday = false;
      });
      showToast('Number updated successfully.');
    } catch (e) {
      print("Error updating number: $e");
      showToast('Failed to update number.');
    }
  }

  Future<void> updateHome() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'homeAddress': homeController.text});
      setState(() {
        userData!['homeAddress'] = homeController.text;
        isEditingHome = false;
      });
      showToast('Number updated successfully.');
    } catch (e) {
      print("Error updating number: $e");
      showToast('Failed to update number.');
    }
  }

  Future<void> updateOffice() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'officeAddress': officeController.text});
      setState(() {
        userData!['officeAddress'] = officeController.text;
        isEditingOffice = false;
      });
      showToast('Number updated successfully.');
    } catch (e) {
      print("Error updating number: $e");
      showToast('Failed to update number.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildProfileImage(),
            _buildNameSection(),
            _buildPersonalInfoSection(),
            _buildSavedAddressesSection(),
            _buildRecentTransactions(),
            _buildAdditionalOptions(),
            _buildDeleteAccountButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new,
                      color: secondary, size: 18),
                  const SizedBox(width: 10),
                  TextWidget(
                    text: 'Back',
                    fontSize: 15,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _showLogoutDialog,
              child: Row(
                children: [
                  TextWidget(
                    text: 'Logout',
                    fontSize: 15,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.logout, color: secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: secondary),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                minRadius: 75,
                maxRadius: 75,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : const AssetImage('assets/images/Group 121 (2).png')
                        as ImageProvider,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 120, top: 110, bottom: 20),
            child: Container(
              width: 40,
              height: 40,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: secondary),
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt_rounded),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return Center(
      child: isEditing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    controller: nameController,
                    style: const TextStyle(
                        color: secondary, fontSize: 28, fontFamily: 'Bold'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => _updateField(
                      'name', nameController.text, () => isEditing = false),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      nameController.text = userData!['name'];
                    });
                  },
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: userData?['name'] ?? '....',
                  fontSize: 28,
                  color: secondary,
                  fontFamily: 'Bold',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: secondary),
                  onPressed: () => setState(() => isEditing = true),
                ),
              ],
            ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        _buildSectionHeader('Personal Information'),
        _buildEditableField('EMAIL ADDRESS', 'email', emailController,
            isEditingEmail, () => isEditingEmail = true, updateEmail),
        _buildEditableField('MOBILE NUMBER', 'number', numberController,
            isEditingNumber, () => isEditingNumber = true, updateNumber),
        _buildEditableField('BIRTHDATE', 'bday', bdayController, isEditingBday,
            () => isEditingBday = true, updateBday),
      ],
    );
  }

  Widget _buildSavedAddressesSection() {
    return Column(
      children: [
        _buildSectionHeader('Saved Addresses'),
        _buildAddressTile('HOME', userData?['homeAddress'], editHome),
        _buildAddressTile('OFFICE', userData?['officeAddress'], editOffice),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      children: [
        _buildSectionHeader('Recent Transactions'),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Orders')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Completed')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.black));
            }

            final data = snapshot.data!.docs;
            return data.isEmpty
                ? Center(
                    child: TextWidget(
                      text: 'No Recent Transaction.',
                      fontSize: 18,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                  )
                : SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final order = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: order['merchantName'],
                                fontSize: 15,
                                color: secondary,
                                fontFamily: 'Bold',
                              ),
                              Column(
                                children: [
                                  TextWidget(
                                    text:
                                        'Total: ₱ ${order['total'].toStringAsFixed(2)}',
                                    fontSize: 12,
                                    color: secondary,
                                    fontFamily: 'Medium',
                                  ),
                                  TextWidget(
                                    text: DateFormat.yMMMd()
                                        .add_jm()
                                        .format(order['date'].toDate()),
                                    fontSize: 8,
                                    color: secondary,
                                    fontFamily: 'Regular',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        _buildTileWidget(
            'Favorites', const Icon(Icons.favorite, color: Colors.white)),
        _buildTileWidget(
            'Terms and Conditions',
            TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium')),
        _buildTileWidget(
            'Privacy Policy',
            TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium')),
        _buildTileWidget(
            'Developers',
            TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium')),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: TextWidget(
              text: 'Delete Account',
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'Bold',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
                TextWidget(
                  text: 'Edit',
                  fontSize: 14,
                  color: secondary,
                  fontFamily: 'Medium',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      String label,
      String field,
      TextEditingController controller,
      bool isEditing,
      VoidCallback onEdit,
      VoidCallback onUpdate) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label,
            fontSize: 10,
            color: secondary,
            fontFamily: 'Regular',
          ),
          Row(
            children: [
              isEditing
                  ? Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            controller: controller,
                            style: const TextStyle(
                                color: secondary,
                                fontSize: 14,
                                fontFamily: 'Medium'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check,
                              color: Colors.green, size: 20),
                          onPressed: onUpdate,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel,
                              color: Colors.red, size: 17),
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                              controller.text = userData![field];
                            });
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        TextWidget(
                          text: userData?[field] ?? '....',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: secondary, size: 17),
                          onPressed: onEdit,
                        ),
                      ],
                    ),
            ],
          ),
          const Divider(color: secondary),
        ],
      ),
    );
  }

  Widget _buildAddressTile(String label, String? address, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(label == 'HOME' ? home : office, width: 24, height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: label,
                fontSize: 10,
                color: secondary,
                fontFamily: 'Regular',
              ),
              SizedBox(
                width: 250,
                child: TextWidget(
                  align: TextAlign.start,
                  text: address ?? '....',
                  fontSize: 14,
                  color: secondary,
                  fontFamily: 'Medium',
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: secondary, size: 17),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildTileWidget(String title, Widget suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
                suffix,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> editHome() async {
    final p = await PlacesAutocomplete.show(
      mode: Mode.overlay,
      context: context,
      apiKey: kGoogleApiKey,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search Address',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [location.Component(location.Component.country, "ph")],
    );

    if (p != null) {
      final places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final detail = await places.getDetailsByPlaceId(p.placeId!);
      await _updateField('homeAddress', detail.result.name, () {});
      await _updateField(
          'homeLat', detail.result.geometry!.location.lat.toString(), () {});
      await _updateField(
          'homeLng', detail.result.geometry!.location.lng.toString(), () {});
    }
  }

  Future<void> editOffice() async {
    final p = await PlacesAutocomplete.show(
      mode: Mode.overlay,
      context: context,
      apiKey: kGoogleApiKey,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search Address',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [location.Component(location.Component.country, "ph")],
    );

    if (p != null) {
      final places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final detail = await places.getDetailsByPlaceId(p.placeId!);
      await _updateField('officeAddress', detail.result.name, () {});
      await _updateField(
          'officeLat', detail.result.geometry!.location.lat.toString(), () {});
      await _updateField(
          'officeLng', detail.result.geometry!.location.lng.toString(), () {});
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextWidget(
            text: 'Are you sure you want to logout?',
            fontSize: 20,
            fontFamily: "ExtraBold",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: secondary),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: TextWidget(
                      text: 'No',
                      fontSize: 17,
                      color: white,
                      fontFamily: "Bold",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: secondary),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                      showToast('Logout Successful');
                    },
                    child: TextWidget(
                      text: 'Logout',
                      fontSize: 17,
                      color: secondary,
                      fontFamily: "Bold",
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
