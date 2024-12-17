import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.onTap,
    required this.icons,
    required this.iconColor,
    this.subTitle,
    this.showArrow = false,
    this.seconderyText = ' ',
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icons;
  final Color iconColor;
  final bool showArrow;
  final String seconderyText;
  final String? subTitle;
  final String title;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.grey[200],
      padding: const EdgeInsets.all(0),
      onPressed: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Icon(widget.icons, color: widget.iconColor),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.subTitle != null)
                            Text(
                              widget.subTitle!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 131, 131, 131),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: widget.showArrow,
                    child: Row(
                      children: [
                        Text(
                          widget.seconderyText,
                          style: TextStyle(
                            fontSize: 6,
                            color: Colors.grey[400],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
