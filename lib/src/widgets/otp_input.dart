import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({this.otpLength = 6, this.controller, this.focusNode, super.key, this.hasError = false, this.onReset});
  final int otpLength;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool hasError;
  final Function()? onReset;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late bool _errorState;
  late FocusNode _focusNode;
  List<String> _values = [];

  @override
  void initState() {
    _errorState = widget.hasError;
    _focusNode = widget.focusNode ?? FocusNode();
    widget.controller?.addListener(_onTextCleared);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextCleared);
      widget.controller?.addListener(_onTextCleared);
    }
    _errorState = widget.hasError;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextCleared);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _focusNode.requestFocus();
      },
      child: Stack(
        children: [
          Offstage(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              maxLength: widget.otpLength,
              decoration: const InputDecoration(
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {
                  if (_errorState) {
                    _errorState = false;
                    widget.onReset?.call();
                  }
                  if (value.isEmpty) {
                    _values.clear();
                  }
                  _values = value.split('');
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 56, maxWidth: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.otpLength, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    width: 48,
                    alignment: Alignment.center,
                    child: Text(
                      index >= _values.length || _values[index].isEmpty ? ' ' : _values[index],
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: _errorState ? mRedColor : Colors.black87),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTextCleared() {
    if (widget.controller?.text.isEmpty ?? true) {
      setState(() {
        _values.clear();
      });
    }
  }
}
