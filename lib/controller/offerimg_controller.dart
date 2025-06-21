import 'package:form_validation/model/offer_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferimgController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<OfferModel> offerList = <OfferModel>[].obs;
  bool isLoading=false;
  
  void fetchOffers() async{
    try {
      isLoading=true;
      final QuerySnapshot snapshot= await _firestore.collection('offers').get();
      offerList.value = snapshot.docs.map((doc) {
        return OfferModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      
      
    } catch (e) {
      print("Error fetching offers: $e");
      
    }
    finally{
      isLoading=false;
    }

  }

}