import 'package:flutter/material.dart';

class NumPadWidget extends StatelessWidget {
  const NumPadWidget({super.key, this.onPressed, this.onDelete});
  final ValueChanged<String>? onPressed;
  final Function? onDelete;
  final _buttonSize = 32.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildNumberButton('1', context)),
              Expanded(child: _buildNumberButton('2', context)),
              Expanded(child: _buildNumberButton('3', context)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildNumberButton('4', context)),
              Expanded(child: _buildNumberButton('5', context)),
              Expanded(child: _buildNumberButton('6', context)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildNumberButton('7', context)),
              Expanded(child: _buildNumberButton('8', context)),
              Expanded(child: _buildNumberButton('9', context)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(child: _buildNumberButton('0', context)),
              Expanded(
                  child: _buildNoOutlineButton(Icon(
                Icons.backspace_outlined,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 30,
              ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number, BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed?.call(number),
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: BorderSide(width: 1.0, color: Theme.of(context).highlightColor),
        fixedSize: Size.fromRadius(_buttonSize),
        foregroundColor: Colors.white,
      ),
      child: Text(number, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  Widget _buildNoOutlineButton(Widget child) {
    return OutlinedButton(
      onPressed: () => onDelete?.call(),
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(color: Colors.transparent),
        fixedSize: Size.fromRadius(_buttonSize),
        foregroundColor: Colors.white,
      ),
      child: child,
    );
  }
}
