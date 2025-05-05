import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/pages/order/review_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class ShopPage extends StatefulWidget {
  final String merchantId;
  const ShopPage({super.key, required this.merchantId});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> merchants = [];
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> selectedItems = [];
  bool isLoading = true;

  int get basketCount => selectedItems.length;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchMerchants();
      await fetchMenuItems();
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchMerchants() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Merchant')
        .where('uid', isEqualTo: widget.merchantId)
        .get();

    setState(() {
      merchants = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> fetchMenuItems() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Menu')
        .where('availability', isEqualTo: 'Available')
        .where('uid', isEqualTo: widget.merchantId)
        .get();

    setState(() {
      menuItems = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() => selectedItems.add(item));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Stack(
        children: [
          Center(
            child: CircularProgressIndicator(color: secondary),
          ),
        ],
      );
    }

    if (merchants.isEmpty || menuItems.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          const SizedBox(height: 20),
          _buildMerchantHeader(),
          const SizedBox(height: 10),
          // _buildCategoryTabs(),
          // const SizedBox(height: 10),
          _buildMenuItems(),
        ],
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
            _buildCartIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Row(
      children: [
        Visibility(
          visible: selectedItems.isNotEmpty,
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewPage(
                    merchantName: merchants[0]['businessName'],
                    merchantId: merchants[0]['uid'],
                    merchantLng: merchants[0]['lng'],
                    merchantLat: merchants[0]['lat'],
                    selectedItems: selectedItems,
                    basketCount: basketCount,
                    onUpdateCart: (updatedItems) {
                      setState(() => selectedItems = updatedItems);
                    },
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/cart.png',
              height: 20,
              width: 20,
            ),
          ),
        ),
        if (basketCount > 0)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$basketCount',
              style: const TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildMerchantHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: secondary),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(merchants[0]['img']),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFavoriteButton(),
              _buildMerchantInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 15),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Icon(Icons.error, color: Colors.red);
          }

          final favs = snapshot.data?['favorites'] ?? [];
          return Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () async {
                final action = favs.contains(merchants[0]['uid'])
                    ? FieldValue.arrayRemove([merchants[0]['uid']])
                    : FieldValue.arrayUnion([merchants[0]['uid']]);

                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .update({'favorites': action});
              },
              child: Icon(
                favs.contains(merchants[0]['uid'])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    favs.contains(merchants[0]['uid']) ? primary : Colors.white,
                size: 35,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMerchantInfo() {
    return Container(
      width: double.infinity,
      height: 36,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7.5),
          bottomRight: Radius.circular(7.5),
        ),
        color: secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: merchants[0]['businessName'] ?? 'Loading...',
              fontSize: 15,
              fontFamily: 'Bold',
              color: Colors.white,
            ),
            Row(
              children: [
                TextWidget(
                  text: '${merchants[0]['ratings']}',
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Icon(Icons.star_rate_rounded,
                    color: Colors.white, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              TextWidget(
                text: 'All',
                fontSize: 15,
                fontFamily: 'Medium',
                color: secondary,
              ),
              const Icon(Icons.circle, color: secondary, size: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: menuItems.map((item) => _buildMenuItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMenuItemImage(item),
          const SizedBox(width: 5),
          _buildMenuItemDetails(item),
        ],
      ),
    );
  }

  Widget _buildMenuItemImage(Map<String, dynamic> item) {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          image: item['imageUrl'] != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item['imageUrl']),
                )
              : null,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondary),
        ),
        child: item['imageUrl'] == null
            ? const Center(child: CircularProgressIndicator(color: secondary))
            : const Center(
                child: CircularProgressIndicator(color: Colors.transparent)),
      ),
    );
  }

  Widget _buildMenuItemDetails(Map<String, dynamic> item) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 33,
              decoration: const BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7.5),
                  topRight: Radius.circular(7.5),
                ),
              ),
              child: Center(
                child: TextWidget(
                  text: item['name'] ?? 'Loading...',
                  fontSize: 15,
                  fontFamily: 'Bold',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextWidget(
              text: item['description'] ?? 'No description available',
              fontSize: 12,
              fontFamily: 'Medium',
              color: Colors.black,
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: '₱ ${item['price']?.toString() ?? '0.00'}',
                    fontSize: 15,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  GestureDetector(
                    onTap: () => addToCart(item),
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'Add to Cart',
                          fontSize: 15,
                          fontFamily: 'Bold',
                          color: secondary,
                        ),
                        const Icon(Icons.arrow_right_alt_outlined,
                            color: secondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
