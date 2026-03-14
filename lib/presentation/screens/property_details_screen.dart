import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/property_details_viewmodel.dart';
import '../../core/performance/performance_monitor.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final int propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyDetailsViewModel>().loadPropertyDetails(widget.propertyId);
    });
    PerformanceMonitor().logMetric(
      metricType: "screenOpen", 
      value: 1, 
      screenName: "PropertyDetails"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PropertyDetailsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)));
          }
          if (vm.property == null) {
            return const Center(child: Text('Property not found'));
          }

          final property = vm.property!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: property.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: IconButton(
                      icon: Icon(
                        property.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: property.isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () => vm.toggleFavorite(),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              property.propertyType,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '\$${property.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        property.title,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem(Icons.king_bed, '${property.bedrooms}', 'Beds'),
                            _buildSpecItem(Icons.bathtub, '2', 'Baths'),
                            _buildSpecItem(Icons.square_foot, '1,200', 'Sqft'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        property.description,
                        style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
