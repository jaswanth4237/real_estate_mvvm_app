import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../viewmodels/property_list_viewmodel.dart';
import '../viewmodels/property_list_event.dart';
import '../viewmodels/property_list_state.dart';
import '../widgets/property_card.dart';
import '../../core/theme/app_theme.dart';
import '../../core/performance/performance_monitor.dart';
import '../../domain/entities/filter_params.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PropertyListViewModel>().add(const FetchPropertiesEvent());
    
    _scrollController.addListener(() {
      if (_scrollController.hasClients && _scrollController.position.atEdge) {
        PerformanceMonitor().logMetric(
          metricType: "scrollFps", 
          value: 60, // Placeholder
          screenName: "PropertyList"
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EstateView', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final service = context.read<ThemeService>();
              service.setTheme(service.selectedTheme == 'light' ? 'dark' : 'light');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<PropertyListViewModel, PropertyState>(
        builder: (context, state) {
          if (state is PropertyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PropertyLoadedState) {
            if (state.properties.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No properties found', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                ),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: state.properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: state.properties[index]);
              },
            );
          } else if (state is PropertyErrorState) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text('Pull to refresh'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<PropertyListViewModel>().add(const FetchPropertiesEvent()),
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    context.read<PropertyListViewModel>().add(ApplyFilterEvent(FilterParams()));
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            _filterOption(sheetContext, 'Budget: Under \$500,000', FilterParams(maxPrice: 500000)),
            _filterOption(sheetContext, 'Premium: Over \$500,000', FilterParams(minPrice: 500000)),
            const SizedBox(height: 16),
            const Text('Bedrooms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            _filterOption(sheetContext, '3 or More Bedrooms', FilterParams(bedrooms: 3)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(BuildContext context, String title, FilterParams params) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.read<PropertyListViewModel>().add(ApplyFilterEvent(params));
        Navigator.pop(context);
      },
    );
  }
}
