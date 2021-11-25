class UiModel {
  final String name;
  final Map<String, dynamic> params;
  final List<UiModel> children;
  final UiModel parent;

  UiModel(
      {required this.name,
      required this.params,
      required this.children,
      required this.parent});
}
