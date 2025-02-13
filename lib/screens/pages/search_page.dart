import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:zippy/screens/pages/shop_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildMerchantList(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: secondary),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() => _nameSearched = value),
                controller: _searchController,
                decoration: const InputDecoration(
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
    );
  }

  Widget _buildMerchantList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Merchant')
          .where('businessName',
              isGreaterThanOrEqualTo: toBeginningOfSentenceCase(_nameSearched))
          .where('businessName',
              isLessThan: '${toBeginningOfSentenceCase(_nameSearched)}z')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child:
                Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        final data = snapshot.requireData;
        return Column(
          children: data.docs.map((doc) => _buildMerchantCard(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMerchantCard(QueryDocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShopPage(merchantId: doc['uid']),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMerchantImage(doc),
            const SizedBox(width: 5),
            _buildMerchantDetails(doc),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantImage(QueryDocumentSnapshot doc) {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(doc['img']),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondary),
        ),
      ),
    );
  }

  Widget _buildMerchantDetails(QueryDocumentSnapshot doc) {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondary),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: doc['businessName'],
                fontSize: 16,
                fontFamily: 'Bold',
              ),
              TextWidget(
                text: doc['desc'],
                fontSize: 10,
                fontFamily: 'Regular',
              ),
              Wrap(
                children: (doc['categories'] as List<dynamic>)
                    .map<Widget>((category) {
                  return TextWidget(
                    text: '$category • ',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  );
                }).toList(),
              ),
              TextWidget(
                text: 'Price range ₱20',
                fontSize: 10,
                fontFamily: 'Regular',
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextWidget(
                  text: '20% off first purchase. min ₱500',
                  fontSize: 10,
                  fontFamily: 'Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
