class BusinessInfo {
  final int id;
  final List<BankAccount> accounts;
  final String email;
  final String? phone;
  final String? facebook;
  final String? telegram;
  final String? tiktok;
  final String? instagram;
  final String? youtube;
  final String address;

  BusinessInfo({
    required this.id,
    required this.accounts,
    required this.email,
    this.phone,
    this.facebook,
    this.telegram,
    this.tiktok,
    this.instagram,
    this.youtube,
    required this.address,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      id: json['id'],
      accounts: (json['accounts'] as List)
          .map((account) => BankAccount.fromJson(account))
          .toList(),
      email: json['email'],
      phone: json['phone'],
      facebook: json['facebook'],
      telegram: json['telegram'],
      tiktok: json['tiktok'],
      instagram: json['instagram'],
      youtube: json['youtube'],
      address: json['address'] ?? '',
    );
  }
}

class BankAccount {
  final int id;
  final String bank;
  final String accountNumber;
  final String accountHolderName;
  final int info;

  BankAccount({
    required this.id,
    required this.bank,
    required this.accountNumber,
    required this.accountHolderName,
    required this.info,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      bank: json['bank'],
      accountNumber: json['account_number'],
      accountHolderName: json['account_holder_name'],
      info: json['info'],
    );
  }
}
