class GraphData<X> {
  final X x;
  final double y;
  final String unit;

  const GraphData({required this.x, required this.y, this.unit = ""});
}

class MinMaxGraphData<X> extends GraphData {
  final double yMax;

  const MinMaxGraphData(
      {required X x, required double y, required this.yMax, String unit = ""})
      : super(x: x, y: y, unit: unit);
}
