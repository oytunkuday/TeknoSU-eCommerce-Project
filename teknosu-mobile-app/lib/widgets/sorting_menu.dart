import 'package:flutter/material.dart';

class SortingMenu extends StatefulWidget {
  const SortingMenu({Key? key, required this.onChanged, required this.value})
      : super(key: key);

  final void Function(String?) onChanged;
  final String value;

  @override
  State<SortingMenu> createState() => _SortingMenuState();
}

class _SortingMenuState extends State<SortingMenu> {
  List<DropdownMenuItem<String>> sortingOptions = [
    'Price Ascending',
    'Price Descending',
    'Rating Ascending',
    'Rating Descending'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: sortingOptions,
      onChanged: widget.onChanged,
      value: widget.value,
      icon: const Icon(Icons.sort),
    );
  }
}
