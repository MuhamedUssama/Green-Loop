class QrCodeModel {
  final String id;
  final String userId;
  final String redeemId;
  final String code;
  final String redeemName;
  final String redeemDescription;
  final bool isScanned;
  final DateTime createdAt;

  QrCodeModel({
    required this.id,
    required this.userId,
    required this.redeemId,
    required this.code,
    required this.redeemName,
    required this.redeemDescription,
    required this.isScanned,
    required this.createdAt,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      redeemId: json['redeem_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      redeemName: json['redeem_name'] as String? ?? '',
      redeemDescription: json['redeem_description'] as String? ?? '',
      isScanned: json['is_scanned'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'redeem_id': redeemId,
      'code': code,
      'redeem_name': redeemName,
      'redeem_description': redeemDescription,
      'is_scanned': isScanned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
