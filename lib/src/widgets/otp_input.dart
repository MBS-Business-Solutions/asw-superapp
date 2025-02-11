import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({this.otpLength = 6, this.controller, this.focusNode, super.key});
  final int otpLength;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late FocusNode _focusNode;
  List<String> _values = [];

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    super.initState();
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
                      style: const TextStyle(fontSize: 20, color: Colors.black87),
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
}
