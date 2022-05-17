import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List selectSizeList;

  const ProductSize({required this.selectSizeList});

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int select = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.selectSizeList.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  select = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: select == i
                      ? Theme.of(context).colorScheme.secondary
                      : const Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Text(
                  "${widget.selectSizeList[i]}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: select == i ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
