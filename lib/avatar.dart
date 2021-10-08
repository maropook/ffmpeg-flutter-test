class Avatar {
  Avatar({
    required int id,
    required String name,
    required String activeImagePath,
    required String stopImagePath,
  }) {
    _id = id;
    _activeImagePath = activeImagePath;
    _stopImagePath = stopImagePath;
    _name = name;
  }
  late int _id;
  late String _name;
  late String _activeImagePath;
  late String _stopImagePath;

  String get activeImagePath => _activeImagePath;
  String get stopImagePath => _stopImagePath;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': _id,
      'name': _name,
      'activeImagePath': _activeImagePath,
      'stopImagePath': _stopImagePath,
    };
  }
}
