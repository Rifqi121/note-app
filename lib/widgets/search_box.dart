import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onSearch;
  final String hintText;

  const SearchBox({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
