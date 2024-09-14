import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final String title;
  final Widget label;
  final List<T> items;
  final String Function(T) itemTitleBuilder;
  final void Function(T) onSelected;
  final T? selectedItem;
  final double horizontalPadding;
  final TextEditingController controller;
  final double widthWidget;

  CustomDropdownMenu({
    required this.title,
    required this.items,
    required this.label,
    required this.itemTitleBuilder,
    required this.onSelected,
    this.selectedItem,
    required this.horizontalPadding,
    required this.widthWidget,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = widthWidget - (2 * horizontalPadding);

    return DropdownMenu<T>(
      width: width,
      controller: controller,
      label: label,
      initialSelection: selectedItem,
      hintText: 'Search $title',
      enableSearch: false,
      requestFocusOnTap: true,
      enableFilter: true,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            Colors.grey.shade200),
      ),
      dropdownMenuEntries: items.map((item) {
        return DropdownMenuEntry<T>(
          value: item,
          label: itemTitleBuilder(item),
        );
      }).toList(),
      onSelected: (value) {
        if (value != null) {
          onSelected(value);
        }
      },
    );
  }
}
