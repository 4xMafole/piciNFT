class NFTManagementException implements Exception {
  final String errorMessageCode;

  NFTManagementException({required this.errorMessageCode});

  @override
  String toString() => errorMessageCode;
}
