import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class PollutantsShimmerLoader extends StatelessWidget {
  const PollutantsShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) => const PollutantsShimmerLoaderItem(),
      ),
    );
  }
}

class PollutantsShimmerLoaderItem extends StatefulWidget {
  const PollutantsShimmerLoaderItem({Key? key}) : super(key: key);

  @override
  State<PollutantsShimmerLoaderItem> createState() =>
      _PollutantsShimmerLoaderItemState();
}

class _PollutantsShimmerLoaderItemState
    extends State<PollutantsShimmerLoaderItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AnimatedOpacity(
          opacity: _animation.value,
          duration: const Duration(milliseconds: 500),
          child: Container(
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black12,
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: SmoothBorderRadius(cornerRadius: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
