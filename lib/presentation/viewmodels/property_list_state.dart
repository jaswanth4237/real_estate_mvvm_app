import 'package:equatable/equatable.dart';
import '../../data/models/property_model.dart';
import '../../core/error/failures.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

class PropertyInitialState extends PropertyState {}

class PropertyLoadingState extends PropertyState {}

class PropertyLoadedState extends PropertyState {
  final List<PropertyModel> properties;
  const PropertyLoadedState(this.properties);

  @override
  List<Object?> get props => [properties];
}

class PropertyErrorState extends PropertyState {
  final String message;
  const PropertyErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
