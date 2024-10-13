import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BalancePage extends StatelessWidget {
  final int balance;
  const BalancePage({super.key, required this.balance});

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
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Only pay for the services you use, whenever you need them. ',
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
                        size: 14,  // Adjust the size as needed
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
                    topLeft: Radius.circular(16),  // Adjust the radius as needed
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300, // Shadow color with some transparency
                      spreadRadius: 0,  // Spread of the shadow
                      blurRadius: 1,    // Softness of the shadow
                      offset: Offset.zero,  // Negative offset to apply the shadow only at the top
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
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        Text(
                          'τ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        'your balance',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          overlayColor:
                          WidgetStateProperty.all(Colors.blue.shade700),
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          // Change background color to grey
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Set border radius to 8
                            ),
                          ),
                          padding: WidgetStateProperty.all(EdgeInsets.only(
                            top: 16.0,    // Top padding
                            bottom: 16.0, // Bottom padding
                          )),
                          alignment: Alignment.center,
                          // Align the content to the center
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
}
