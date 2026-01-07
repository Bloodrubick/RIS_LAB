import 'package:flutter/material.dart';

class CurrencyInfoCard extends StatelessWidget {
  final String date;
  final String value;
  final bool isGrowth;

  const CurrencyInfoCard({
    super.key,
    required this.date,
    required this.value,
    this.isGrowth = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 8, 24),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isGrowth ? const Color(0xFF1FD522) : Colors.red,
                ),
              ),
            ),
            Icon(
              isGrowth ? Icons.arrow_upward : Icons.arrow_downward,
              size: 10,
              color: isGrowth ? const Color(0xFF1FD522) : Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
