import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    super.key,
    this.initialValue = 1,
    this.minValue = 1,
    this.maxValue = 99,
    this.onChanged,
  });

  final int initialValue;
  final int minValue;
  final int maxValue;
  final void Function(int)? onChanged;

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
      });
      widget.onChanged?.call(_quantity);
    }
  }

  void _increment() {
    if (_quantity < widget.maxValue) {
      setState(() {
        _quantity++;
      });
      widget.onChanged?.call(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRoundButton(
          icon: Icons.remove,
          onPressed: _decrement,
          enabled: _quantity > widget.minValue,
          theme: theme,
        ),
        Container(
          width: 44,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            _quantity.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        _buildRoundButton(
          icon: Icons.add,
          onPressed: _increment,
          enabled: _quantity < widget.maxValue,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
    required ThemeData theme,
  }) {
    final Color backgroundColor = theme.colorScheme.primary;
    final Color foregroundColor = theme.colorScheme.onPrimary;
    final Color disabledColor = Colors.grey.shade300;

    return Material(
      elevation: enabled ? 2 : 0,
      shape: const CircleBorder(),
      color: enabled ? backgroundColor : disabledColor,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: enabled ? foregroundColor : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
