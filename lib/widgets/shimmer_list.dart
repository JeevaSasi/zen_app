import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget.rectangular(
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget.rectangular(height: 24),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 16,
                        ),
                        const SizedBox(width: 16),
                        ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 4),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ShimmerWidget.rectangular(
                        width: 100,
                        height: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 