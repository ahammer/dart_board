/// To Collect a map in a list through a reducer.
extension MapCollect<K, V, R> on Map<K, V> {
  List<R> collect<R>(R Function(K key, V value) convert) {
    final result = <R>[];
    forEach((key, value) => result.add(convert(key, value)));
    return result;
  }
}
