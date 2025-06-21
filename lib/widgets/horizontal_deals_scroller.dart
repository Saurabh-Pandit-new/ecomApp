import 'dart:async';
import 'package:flutter/material.dart';
import 'package:form_validation/controller/offerimg_controller.dart';
import 'package:form_validation/model/offer_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HorizontalDealsScroller extends StatefulWidget {
  const HorizontalDealsScroller({super.key});

  @override
  State<HorizontalDealsScroller> createState() => _HorizontalDealsScrollerState();
}

class _HorizontalDealsScrollerState extends State<HorizontalDealsScroller> {
  final ScrollController _scrollController = ScrollController();
   final OfferimgController offerController = Get.put(OfferimgController());
  late Timer _scrollTimer;

  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        _scrollPosition += 2; // speed: increase value for faster scroll
        if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
          _scrollPosition = 0.0;
        }
        _scrollController.animateTo(
          _scrollPosition,
          duration: const Duration(milliseconds:150),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    offerController.fetchOffers();

    return Obx(() {
      final List<OfferModel> offers = offerController.offerList;

      if (offers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: List.generate(offers.length, (index) {
            final offer = offers[index];
            return Container(
              height: 140,
              width: 262,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12),bottom: Radius.circular(12)),
                    child: Image.network(
                      offer.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
