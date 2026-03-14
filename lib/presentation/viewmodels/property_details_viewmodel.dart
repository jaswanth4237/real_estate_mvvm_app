import 'package:flutter/material.dart';
import '../../domain/usecases/get_property_details_usecase.dart';
import '../../data/models/property_model.dart';
import '../../data/datasources/local/property_database.dart';

class PropertyDetailsViewModel extends ChangeNotifier {
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final LocalPropertyDataSource localDataSource;

  PropertyDetailsViewModel({
    required this.getPropertyDetailsUseCase,
    required this.localDataSource,
  });

  PropertyModel? _property;
  PropertyModel? get property => _property;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadPropertyDetails(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getPropertyDetailsUseCase.execute(id);
    result.fold(
      (data) {
        _property = data;
        _isLoading = false;
        notifyListeners();
      },
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> toggleFavorite() async {
    if (_property != null) {
      final updatedProperty = _property!.copyWith(isFavorite: !_property!.isFavorite);
      _property = updatedProperty;
      await localDataSource.toggleFavorite(updatedProperty);
      notifyListeners();
    }
  }
}
