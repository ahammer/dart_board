// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_sweeper_node.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MineSweeperNode extends MineSweeperNode {
  @override
  final bool isVisible;
  @override
  final bool isTagged;
  @override
  final int neighbours;
  @override
  final double random;
  @override
  final bool? isBomb;

  factory _$MineSweeperNode([void Function(MineSweeperNodeBuilder)? updates]) =>
      (new MineSweeperNodeBuilder()..update(updates)).build();

  _$MineSweeperNode._(
      {required this.isVisible,
      required this.isTagged,
      required this.neighbours,
      required this.random,
      this.isBomb})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isVisible, 'MineSweeperNode', 'isVisible');
    BuiltValueNullFieldError.checkNotNull(
        isTagged, 'MineSweeperNode', 'isTagged');
    BuiltValueNullFieldError.checkNotNull(
        neighbours, 'MineSweeperNode', 'neighbours');
    BuiltValueNullFieldError.checkNotNull(random, 'MineSweeperNode', 'random');
  }

  @override
  MineSweeperNode rebuild(void Function(MineSweeperNodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MineSweeperNodeBuilder toBuilder() =>
      new MineSweeperNodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MineSweeperNode &&
        isVisible == other.isVisible &&
        isTagged == other.isTagged &&
        neighbours == other.neighbours &&
        random == other.random &&
        isBomb == other.isBomb;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, isVisible.hashCode), isTagged.hashCode),
                neighbours.hashCode),
            random.hashCode),
        isBomb.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MineSweeperNode')
          ..add('isVisible', isVisible)
          ..add('isTagged', isTagged)
          ..add('neighbours', neighbours)
          ..add('random', random)
          ..add('isBomb', isBomb))
        .toString();
  }
}

class MineSweeperNodeBuilder
    implements Builder<MineSweeperNode, MineSweeperNodeBuilder> {
  _$MineSweeperNode? _$v;

  bool? _isVisible;
  bool? get isVisible => _$this._isVisible;
  set isVisible(bool? isVisible) => _$this._isVisible = isVisible;

  bool? _isTagged;
  bool? get isTagged => _$this._isTagged;
  set isTagged(bool? isTagged) => _$this._isTagged = isTagged;

  int? _neighbours;
  int? get neighbours => _$this._neighbours;
  set neighbours(int? neighbours) => _$this._neighbours = neighbours;

  double? _random;
  double? get random => _$this._random;
  set random(double? random) => _$this._random = random;

  bool? _isBomb;
  bool? get isBomb => _$this._isBomb;
  set isBomb(bool? isBomb) => _$this._isBomb = isBomb;

  MineSweeperNodeBuilder();

  MineSweeperNodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isVisible = $v.isVisible;
      _isTagged = $v.isTagged;
      _neighbours = $v.neighbours;
      _random = $v.random;
      _isBomb = $v.isBomb;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MineSweeperNode other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MineSweeperNode;
  }

  @override
  void update(void Function(MineSweeperNodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MineSweeperNode build() {
    final _$result = _$v ??
        new _$MineSweeperNode._(
            isVisible: BuiltValueNullFieldError.checkNotNull(
                isVisible, 'MineSweeperNode', 'isVisible'),
            isTagged: BuiltValueNullFieldError.checkNotNull(
                isTagged, 'MineSweeperNode', 'isTagged'),
            neighbours: BuiltValueNullFieldError.checkNotNull(
                neighbours, 'MineSweeperNode', 'neighbours'),
            random: BuiltValueNullFieldError.checkNotNull(
                random, 'MineSweeperNode', 'random'),
            isBomb: isBomb);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
