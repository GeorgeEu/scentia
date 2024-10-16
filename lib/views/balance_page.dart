import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scientia/views/offers_widget.dart';

class BalancePage extends StatelessWidget {
  final int balance;
  final List<Map<String, dynamic>> offers;
  const BalancePage({super.key, required this.balance, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SvgPicture.asset(
                width: 125,
                height: 125,
                'assets/s_logo.svg', // Path to your SVG file
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Scentia Tokens',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'Only pay for the services you use, whenever you need them. ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'More about Tokens ',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.bottom,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 14, // Adjust the size as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), // Adjust the radius as needed
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300, // Shadow color with some transparency
                      spreadRadius: 0, // Spread of the shadow
                      blurRadius: 1, // Softness of the shadow
                      offset: Offset.zero, // Negative offset to apply the shadow only at the top
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            balance.toString(),
                            style: TextStyle(
                                fontSize: 24,
                                height: 1,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          'τ',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        'your balance',
                        style: TextStyle(fontSize: 13, color: Colors.grey, height: 1),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showBottomSheet(context); // Call the method here
                        },
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(Colors.blue.shade700),
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(vertical: 16.0)),
                          alignment: Alignment.center,
                          elevation: WidgetStateProperty.all(0.1),
                        ),
                        child: Text(
                          'Buy Tokens',
                          style: TextStyle(color: Colors.white, height: 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Text(
                'Choose package',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade600
                ),
              ),
            ),
            OffersWidget(offers: offers),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'By proceeding and purchasing Tokens, you agree with the',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: ' Terms and Conditions.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
