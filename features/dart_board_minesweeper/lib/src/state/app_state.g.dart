// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MinesweeperState extends MinesweeperState {
  @override
  final String difficulty;
  @override
  final MineSweeper mineSweeper;

  factory _$MinesweeperState(
          [void Function(MinesweeperStateBuilder)? updates]) =>
      (new MinesweeperStateBuilder()..update(updates)).build();

  _$MinesweeperState._({required this.difficulty, required this.mineSweeper})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        difficulty, 'MinesweeperState', 'difficulty');
    BuiltValueNullFieldError.checkNotNull(
        mineSweeper, 'MinesweeperState', 'mineSweeper');
  }

  @override
  MinesweeperState rebuild(void Function(MinesweeperStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MinesweeperStateBuilder toBuilder() =>
      new MinesweeperStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MinesweeperState &&
        difficulty == other.difficulty &&
        mineSweeper == other.mineSweeper;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, difficulty.hashCode), mineSweeper.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MinesweeperState')
          ..add('difficulty', difficulty)
          ..add('mineSweeper', mineSweeper))
        .toString();
  }
}

class MinesweeperStateBuilder
    implements Builder<MinesweeperState, MinesweeperStateBuilder> {
  _$MinesweeperState? _$v;

  String? _difficulty;
  String? get difficulty => _$this._difficulty;
  set difficulty(String? difficulty) => _$this._difficulty = difficulty;

  MineSweeperBuilder? _mineSweeper;
  MineSweeperBuilder get mineSweeper =>
      _$this._mineSweeper ??= new MineSweeperBuilder();
  set mineSweeper(MineSweeperBuilder? mineSweeper) =>
      _$this._mineSweeper = mineSweeper;

  MinesweeperStateBuilder();

  MinesweeperStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _difficulty = $v.difficulty;
      _mineSweeper = $v.mineSweeper.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MinesweeperState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MinesweeperState;
  }

  @override
  void update(void Function(MinesweeperStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MinesweeperState build() {
    _$MinesweeperState _$result;
    try {
      _$result = _$v ??
          new _$MinesweeperState._(
              difficulty: BuiltValueNullFieldError.checkNotNull(
                  difficulty, 'MinesweeperState', 'difficulty'),
              mineSweeper: mineSweeper.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mineSweeper';
        mineSweeper.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MinesweeperState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
