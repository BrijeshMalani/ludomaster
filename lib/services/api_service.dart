import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utils/common.dart';
import '../models/app_data_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ApiService {
  static const String baseUrl = 'https://shatars.com/getappdata.php';
  static const String pkgId = 'com.gamewarrier.gamechanger.ludomaster';

  static Future<AppDataModel?> fetchAppData() async {
    try {
      print('Making API request to: $baseUrl?pkgid=$pkgId');
      final response = await http.get(
        Uri.parse('$baseUrl?pkgid=$pkgId'),
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Parsed JSON Response: $jsonResponse');

        if (jsonResponse['flag'] == true &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          print('Creating AppDataModel from response data');
          final appData = AppDataModel.fromJson(jsonResponse['data'][0]);
          print('Created AppDataModel: $appData');
          return appData;
        } else {
          print('Invalid response format or empty data');
          print('Flag: ${jsonResponse['flag']}');
          print('Data: ${jsonResponse['data']}');
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('Error in fetchAppData: $e');
      return null;
    }
  }
}

class PurchaseService {
  static String noAdsProductId = Common.no_ads_product_id;
  static String noAdsKey = Common.no_ads_key;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(_onPurchaseUpdated, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error
    });
  }

  Future<bool> isNoAdsPurchased() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(noAdsKey) ?? false;
  }

  Future<void> buyNoAds() async {
    final available = await _iap.isAvailable();
    if (!available) throw Exception('Store not available');
    final ProductDetailsResponse response =
        await _iap.queryProductDetails({noAdsProductId});
    if (response.notFoundIDs.isNotEmpty) throw Exception('Product not found');
    final ProductDetails product = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyProduct(String productId) async {
    final available = await _iap.isAvailable();
    if (!available) throw Exception('Store not available');
    final ProductDetailsResponse response =
        await _iap.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty) throw Exception('Product not found');
    final ProductDetails product = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID == noAdsProductId &&
          purchase.status == PurchaseStatus.purchased) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(noAdsKey, true);
        _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
