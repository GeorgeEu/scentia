import 'package:flutter/material.dart';
import 'package:scientia/widgets/empty_state_widget.dart';
import 'package:scientia/widgets/st_row.dart';
import '../../views/events_page.dart';
import '../st_chevron_right.dart';
import '../st_header.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Ensure you have the flutter_svg package included in your pubspec.yaml file

class Events extends StatefulWidget {
  final List<Map<String, dynamic>> events;

  const Events({super.key, required this.events});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StRow(
          stHeader: StHeader(text: 'Events'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventsPage(events: widget.events))
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EventsPage(events: widget.events))
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: widget.events.isNotEmpty
                ? ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.events.length > 3 ? 3 : widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return InkWell(
                  onTap: () {
                    showEventBottomSheet(
                        context,
                        event['name'],
                        event['address'],
                        event['desc'],
                        event['imageUrl'],
                        event['date']);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 16.0 : 0.0, // Add padding only for the first item
                      bottom: index == (widget.events.length > 3 ? 2 : widget.events.length - 1) ? 16.0 : 0.0, // Add padding only for the last item
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
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
                                // Use the image URL from Firestore
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Image not available'); // Error text if image fails to load
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['date'],
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    event['name'],
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    event['address'],
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.5,
                  indent: 113,
                ); // Your separator widget
              },
            )
                : SizedBox(
              height: 186,
              width: double.infinity,
              child: EmptyStateWidget(
                path: 'assets/platopys.png',
                size: 130,
                message: 'There are no events yet',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showEventBottomSheet(BuildContext context, String name, String address,
      String desc, String imageUrl, String formattedDate) {
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
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      address,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      desc,
                      style: const TextStyle(
                          fontSize: 16),
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
