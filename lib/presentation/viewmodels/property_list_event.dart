import 'package:equatable/equatable.dart';
import '../../domain/entities/filter_params.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class FetchPropertiesEvent extends PropertyEvent {
  final int page;
  const FetchPropertiesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class ApplyFilterEvent extends PropertyEvent {
  final FilterParams filters;
  const ApplyFilterEvent(this.filters);

  @override
  List<Object?> get props => [filters];
}
