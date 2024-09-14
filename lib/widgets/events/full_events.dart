import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scientia/widgets/empty_state_page.dart';  // Ensure you have the flutter_svg package included in your pubspec.yaml file

class FullEvents extends StatefulWidget {
  final List<Map<String, dynamic>> events;

  FullEvents({super.key, required this.events});

  @override
  _FullEventsState createState() => _FullEventsState();
}

class _FullEventsState extends State<FullEvents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: widget.events.isNotEmpty
          ? ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          final event = widget.events[index];
          return InkWell(
            onTap: () {
              showEventBottomSheet(
                context,
                event['name'],
                event['organizer'],
                event['desc'],
                event['imageUrl'],
                event['date'],
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8, top: 4),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        event['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Image not available'); // Error text if image fails to load
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['date'],
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            event['name'],
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            event['organizer'],
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 0.5,
          ); // Your separator widget
        },
      )
          : Center(
        child: EmptyStatePage(
          message: 'There are no events yet',
        ),
      ),
    );
  }

  void showEventBottomSheet(BuildContext context, String name, String organizer, String desc, String imageUrl, String formattedDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.68,  // Adjust as needed
          minChildSize: 0.3,
          maxChildSize: 0.9,  // Adjust as needed
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                      child: SvgPicture.asset(
                        'assets/drag-handle.svg', // Path to your SVG file
                        width: 40,  // Adjust the size as needed
                        height: 4,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,  // or the aspect ratio of your image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Image not available'); // Error text if image fails to load
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      organizer,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      desc,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
