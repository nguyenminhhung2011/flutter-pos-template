class CustomerModel {
  late String customerName, phoneNumber, type, profilePicture, emailAddress, customerAddress, dueAmount, openingBalance, remainedBalance;

  CustomerModel(
      {required this.customerName,
      required this.phoneNumber,
      required this.type,
      required this.profilePicture,
      required this.emailAddress,
      required this.customerAddress,
      required this.dueAmount,
      required this.openingBalance,
      required this.remainedBalance});

  CustomerModel.fromJson(Map<dynamic, dynamic> json)
      : customerName = json['customerName'] as String,
        phoneNumber = json['phoneNumber'] as String,
        type = json['type'] as String,
        profilePicture = json['profilePicture'] as String,
        emailAddress = json['emailAddress'] as String,
        customerAddress = json['customerAddress'] as String,
        dueAmount = json['due'] as String,
        openingBalance = json['openingBalance'] as String,
        remainedBalance = json['remainedBalance'] as String;
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'customerName': customerName,
        'phoneNumber': phoneNumber,
        'type': type,
        'profilePicture': profilePicture,
        'emailAddress': emailAddress,
        'customerAddress': customerAddress,
        'due': dueAmount,
        'openingBalance': openingBalance,
        'remainedBalance': remainedBalance,
      };
}
