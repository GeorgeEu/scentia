import 'package:flutter/material.dart';

import '../services/cloud_functions.dart';

class OffersWidget extends StatefulWidget {
  final List<Map<String, dynamic>> offers;

  const OffersWidget({Key? key, required this.offers}) : super(key: key);

  @override
  _OffersWidgetState createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  final CloudFunctions _cloudFunctions = CloudFunctions();
  bool _isProcessing = false;
  String? _feedbackMessage;

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) {
      return Center(
        child: Text('No offers available.'),
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 52.0 * widget.offers.length,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.offers.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.grey,
                indent: 24,
                thickness: 0.25,
                height: 0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final offer = widget.offers[index];

              return InkWell(
                onTap: () async {
                  setState(() {
                    _isProcessing = true;
                  });

                  try {
                    int tokensAmount = offer['tokens'];

                    // Ensure tokensAmount is an integer
                    if (tokensAmount is! int) {
                      tokensAmount = int.parse(tokensAmount.toString());
                    }

                    int newBalance = await _cloudFunctions.processTokens(tokensAmount);

                    setState(() {
                      _isProcessing = false;
                      _feedbackMessage = 'Tokens added successfully! New balance: $newBalance';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_feedbackMessage!)),
                    );
                  } catch (e) {
                    setState(() {
                      _isProcessing = false;
                      _feedbackMessage = 'Error processing tokens: $e';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_feedbackMessage!)),
                    );
                  }
                },
                child: Container(
                  height: 52.0,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${offer['tokens']} Tokens',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        offer['price'].toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_isProcessing)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
