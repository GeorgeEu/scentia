import 'package:cloud_firestore/cloud_firestore.dart';

class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch and sort offers by price
  Future<List<Map<String, dynamic>>> getUsdOffers() async {
    try {
      CollectionReference usdCollectionRef = _firestore
          .collection('accounting')
          .doc('offers')
          .collection('usd');

      QuerySnapshot snapshot = await usdCollectionRef.get();

      List<Map<String, dynamic>> offers = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      // Sort by price (numeric value) before formatting
      offers.sort((a, b) => a['price'].compareTo(b['price']));

      // After sorting, format the price with the $ sign
      offers = offers.map((offer) {
        double price = offer['price'] as double;
        offer['price'] = '\$${price.toStringAsFixed(2)}';
        return offer;
      }).toList();

      return offers;
    } catch (e) {
      print('Error fetching or sorting offers: $e');
      throw Exception('Failed to fetch or sort offers');
    }
  }

}
