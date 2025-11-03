import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Chat input field with send button
class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isEnabled;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: appColors.surface,
        border: Border(top: BorderSide(color: appColors.lightSage, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40,
                    maxHeight: 120,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: appColors.lightSage.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    enabled: widget.isEnabled,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(
                      fontSize: 15,
                      color: appColors.darkCharcoal,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about the images...',
                      hintStyle: TextStyle(
                        color: appColors.graphite.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send Button
              GestureDetector(
                onTap: _hasText && widget.isEnabled ? _handleSend : null,
                child: AnimatedScale(
                  scale: _hasText && widget.isEnabled ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _hasText && widget.isEnabled
                          ? appColors.indigoInk
                          : appColors.mutedSand,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
