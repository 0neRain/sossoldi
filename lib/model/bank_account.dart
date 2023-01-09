import 'package:sossoldi/model/base_entity.dart';

const String bankAccountTable = 'bankAccount';

class BankAccountFields extends BaseEntityFields {
  static String id = 'id';
  static String name = 'name';
  static String value = 'value';
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';

  static final List<String> allFields = [
    BaseEntityFields.id,
    name,
    value,
    BaseEntityFields.createdAt,
    BaseEntityFields.updatedAt
  ];
}

class BankAccount extends BaseEntity {
  final String name;
  final String value;

  const BankAccount(
      {int? id,
      required this.name,
      required this.value,
      DateTime? createdAt,
      DateTime? updatedAt})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  BankAccount copy(
          {int? id,
          String? name,
          String? value,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BankAccount(
          id: id ?? this.id,
          name: name ?? this.name,
          value: value ?? this.value,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt);

  static BankAccount fromJson(Map<String, Object?> json) => BankAccount(
      id: json[BaseEntityFields.id] as int?,
      name: json[BankAccountFields.name] as String,
      value: json[BankAccountFields.value] as String,
      createdAt: DateTime.parse(json[BaseEntityFields.createdAt] as String),
      updatedAt: DateTime.parse(json[BaseEntityFields.updatedAt] as String));

  Map<String, Object?> toJson() => {
        BaseEntityFields.id: id,
        BankAccountFields.name: name,
        BankAccountFields.value: value,
        BaseEntityFields.createdAt: createdAt?.toIso8601String(),
        BaseEntityFields.updatedAt: updatedAt?.toIso8601String(),
      };
}
