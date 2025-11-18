class RvmModel {
  final String id;
  final String name;
  final String welcome;
  final String location;
  final String status;
  final double rating;
  final int distance;

  RvmModel({
    required this.id,
    required this.name,
    required this.welcome,
    required this.location,
    this.status = 'Available',
    this.rating = 4.8,
    this.distance = 150,
  });
}