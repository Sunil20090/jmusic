import 'package:jmusic/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  int counter;
  int minLimit, maxLimit, change_by;
  Function(int value)? onChange;
  Counter({
    super.key,
    required this.counter,
    this.minLimit = 1,
    this.maxLimit = 10,
    this.change_by = 1,
    this.onChange,
  });

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: COLOR_GREY),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: (widget.onChange != null)
                ? () {
                    if (widget.minLimit < widget.counter) {
                      widget.counter -= widget.change_by;
                      widget.onChange!(widget.counter);
                    }
                  }
                : null,
            child: Icon(Icons.remove),
          ),
          Container(
            alignment: Alignment.center,
            width: 20,
            child: Text('${widget.counter}', style: getTextTheme().titleSmall),
          ),
          InkWell(
            onTap: (widget.onChange != null)
                ? () {
                    if (widget.maxLimit > widget.counter) {
                      widget.counter++;
                      widget.onChange!(widget.counter);
                    }
                  }
                : null,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
