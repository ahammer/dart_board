// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_sweeper.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MineSweeper extends MineSweeper {
  @override
  final int width;
  @override
  final int height;
  @override
  final int bombs;
  @override
  final DateTime startTime;
  @override
  final DateTime? gameOverTime;
  @override
  final BuiltList<MineSweeperNode> nodes;

  factory _$MineSweeper([void Function(MineSweeperBuilder)? updates]) =>
      (new MineSweeperBuilder()..update(updates)).build();

  _$MineSweeper._(
      {required this.width,
      required this.height,
      required this.bombs,
      required this.startTime,
      this.gameOverTime,
      required this.nodes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(width, 'MineSweeper', 'width');
    BuiltValueNullFieldError.checkNotNull(height, 'MineSweeper', 'height');
    BuiltValueNullFieldError.checkNotNull(bombs, 'MineSweeper', 'bombs');
    BuiltValueNullFieldError.checkNotNull(
        startTime, 'MineSweeper', 'startTime');
    BuiltValueNullFieldError.checkNotNull(nodes, 'MineSweeper', 'nodes');
  }

  @override
  MineSweeper rebuild(void Function(MineSweeperBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MineSweeperBuilder toBuilder() => new MineSweeperBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MineSweeper &&
        width == other.width &&
        height == other.height &&
        bombs == other.bombs &&
        startTime == other.startTime &&
        gameOverTime == other.gameOverTime &&
        nodes == other.nodes;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, width.hashCode), height.hashCode),
                    bombs.hashCode),
                startTime.hashCode),
            gameOverTime.hashCode),
        nodes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MineSweeper')
          ..add('width', width)
          ..add('height', height)
          ..add('bombs', bombs)
          ..add('startTime', startTime)
          ..add('gameOverTime', gameOverTime)
          ..add('nodes', nodes))
        .toString();
  }
}

class MineSweeperBuilder implements Builder<MineSweeper, MineSweeperBuilder> {
  _$MineSweeper? _$v;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  int? _bombs;
  int? get bombs => _$this._bombs;
  set bombs(int? bombs) => _$this._bombs = bombs;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  DateTime? _gameOverTime;
  DateTime? get gameOverTime => _$this._gameOverTime;
  set gameOverTime(DateTime? gameOverTime) =>
      _$this._gameOverTime = gameOverTime;

  ListBuilder<MineSweeperNode>? _nodes;
  ListBuilder<MineSweeperNode> get nodes =>
      _$this._nodes ??= new ListBuilder<MineSweeperNode>();
  set nodes(ListBuilder<MineSweeperNode>? nodes) => _$this._nodes = nodes;

  MineSweeperBuilder();

  MineSweeperBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _width = $v.width;
      _height = $v.height;
      _bombs = $v.bombs;
      _startTime = $v.startTime;
      _gameOverTime = $v.gameOverTime;
      _nodes = $v.nodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MineSweeper other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MineSweeper;
  }

  @override
  void update(void Function(MineSweeperBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MineSweeper build() {
    _$MineSweeper _$result;
    try {
      _$result = _$v ??
          new _$MineSweeper._(
              width: BuiltValueNullFieldError.checkNotNull(
                  width, 'MineSweeper', 'width'),
              height: BuiltValueNullFieldError.checkNotNull(
                  height, 'MineSweeper', 'height'),
              bombs: BuiltValueNullFieldError.checkNotNull(
                  bombs, 'MineSweeper', 'bombs'),
              startTime: BuiltValueNullFieldError.checkNotNull(
                  startTime, 'MineSweeper', 'startTime'),
              gameOverTime: gameOverTime,
              nodes: nodes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nodes';
        nodes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MineSweeper', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
