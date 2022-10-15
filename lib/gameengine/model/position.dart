import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int row;
  final int column;
  const Position(this.row, this.column);

  @override
  List<Object> get props => [row, column];
}
