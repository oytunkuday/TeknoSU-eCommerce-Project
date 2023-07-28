import 'package:flutter/material.dart';

class OrderActionMenu extends StatefulWidget {
  const OrderActionMenu(
      {Key? key, required this.onChanged, required this.value})
      : super(key: key);

  final void Function(String?) onChanged;
  final String value;

  @override
  State<OrderActionMenu> createState() => _OrderActionMenuState();
}

class _OrderActionMenuState extends State<OrderActionMenu> {
  List<DropdownMenuItem<String>> sortingOptions = [
    'Processing',
    'In-Transit',
    'Delivered',
    'Cancelled'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text('Send to ' + value),
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: sortingOptions,
      onChanged: widget.onChanged,
      value: widget.value,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}
