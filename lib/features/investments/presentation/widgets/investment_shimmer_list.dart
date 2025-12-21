import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InvestmentShimmerList extends StatelessWidget {
  final int itemCount;

  const InvestmentShimmerList({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) => _InvestmentShimmerItem(),
    );
  }
}

class _InvestmentShimmerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(height: 16, width: 150, color: Colors.grey),
                  const Spacer(),
                  Container(height: 16, width: 80, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              // Platform + Dates
              Row(
                children: [
                  Container(height: 16, width: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 16, color: Colors.grey)),
                  const SizedBox(width: 8),
                  Container(height: 16, width: 60, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              // Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 50, color: Colors.grey),
                      const SizedBox(height: 4),
                      Container(height: 16, width: 60, color: Colors.grey),
                    ],
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
