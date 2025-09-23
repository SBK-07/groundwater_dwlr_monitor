import 'package:flutter/material.dart';

class SwipableContainer extends StatelessWidget {
  final PageController controller;
  final double currentIndex;
  final List<Widget> pages;

  const SwipableContainer({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: pages[index % pages.length],
                );
              },
            ),
            Positioned(
              top: 184,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 36, color: Colors.blue[700]),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 184,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_right, size: 36, color: Colors.blue[700]),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentIndex.round() == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      color: currentIndex.round() == index ? Colors.blue[700] : Colors.grey[400],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}