import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/state_option.dart';

abstract interface class StateRepository {
  Future<List<StateOption>> getStates({required String token});
}
