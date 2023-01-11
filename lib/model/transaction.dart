import '../database/sossoldi_database.dart';
import 'base_entity.dart';

const String transactionTable = 'transaction';

class TransactionFields extends BaseEntityFields {
  static String id = 'id';
  static String date = 'date';
  static String amount = 'amount';
  static String type = 'type';
  static String note = 'note';
  static String idBankAccount = 'idBankAccount'; // FK
  static String idBudget = 'idBudget'; // FK
  static String idCategory = 'idCategory'; // FK
  static String idRecurringTransaction = 'idRecurringTransaction'; // FK
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';

  static final List<String> allFields = [
    BaseEntityFields.id,
    date,
    amount,
    type,
    note,
    idBankAccount,
    idBudget,
    idCategory,
    idRecurringTransaction,
    BaseEntityFields.createdAt,
    BaseEntityFields.updatedAt
  ];
}

enum Type { income, expense, transfer }

class Transaction extends BaseEntity {
  final DateTime date;
  final num amount;
  final Type type;
  final String? note;
  final int idBankAccount;
  final int idBudget;
  final int idCategory;
  final int? idRecurringTransaction;

  const Transaction(
      {int? id,
      required this.date,
      required this.amount,
      required this.type,
      this.note,
      required this.idBankAccount,
      required this.idBudget,
      required this.idCategory,
      this.idRecurringTransaction,
      DateTime? createdAt,
      DateTime? updatedAt})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  Transaction copy(
          {int? id,
          DateTime? date,
          int? amount,
          Type? type,
          String? note,
          int? idBankAccount,
          int? idBudget,
          int? idCategory,
          int? idRecurringTransaction,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Transaction(
          id: id ?? this.id,
          date: date ?? this.date,
          amount: amount ?? this.amount,
          type: type ?? this.type,
          note: note ?? this.note,
          idBankAccount: idBankAccount ?? this.idBankAccount,
          idBudget: idBudget ?? this.idBudget,
          idCategory: idCategory ?? this.idCategory,
          idRecurringTransaction:
              idRecurringTransaction ?? this.idRecurringTransaction,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt);

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
      id: json[BaseEntityFields.id] as int?,
      date: DateTime.parse(json[TransactionFields.date] as String),
      amount: json[TransactionFields.amount] as num,
      type: Type.values[json[TransactionFields.type] as int],
      note: json[TransactionFields.note] as String,
      idBankAccount: json[TransactionFields.idBankAccount] as int,
      idBudget: json[TransactionFields.idBudget] as int,
      idCategory: json[TransactionFields.idCategory] as int,
      idRecurringTransaction: json[TransactionFields.idCategory] as int?,
      createdAt: DateTime.parse(json[BaseEntityFields.createdAt] as String),
      updatedAt: DateTime.parse(json[BaseEntityFields.updatedAt] as String));

  Map<String, Object?> toJson() => {
        BaseEntityFields.id: id,
        TransactionFields.date: date.toIso8601String(),
        TransactionFields.amount: amount,
        TransactionFields.type: type.index,
        TransactionFields.note: note,
        TransactionFields.idBankAccount: idBankAccount,
        TransactionFields.idBudget: idBudget,
        TransactionFields.idCategory: idCategory,
        TransactionFields.idRecurringTransaction: idRecurringTransaction,
        BaseEntityFields.createdAt: createdAt?.toIso8601String(),
        BaseEntityFields.updatedAt: updatedAt?.toIso8601String(),
      };
}

class TransactionMethods extends SossoldiDatabase {
  Future<Transaction> insert(Transaction item) async {
    final database = await SossoldiDatabase.instance.database;
    final id = await database.insert(transactionTable, item.toJson());
    return item.copy(id: id);
  }


  Future<Transaction> selectById(int id) async {
    final database = await SossoldiDatabase.instance.database;

    final maps = await database.query(
      transactionTable,
      columns: TransactionFields.allFields,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Transaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Transaction>> selectAll() async {
    final database = await SossoldiDatabase.instance.database;

    final orderByASC = '${TransactionFields.createdAt} ASC';

    // final result = await database.rawQuery('SELECT * FROM $tableExample ORDER BY $orderByASC')
    final result = await database.query(transactionTable, orderBy: orderByASC);

    return result.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<int> updateItem(Transaction item) async {
    final database = await SossoldiDatabase.instance.database;

    // You can use `rawUpdate` to write the query in SQL
    return database.update(
      transactionTable,
      item.toJson(),
      where:
      '${TransactionFields.id} = ?', // Use `:` if you will not use `sqflite_common_ffi`
      whereArgs: [item.id],
    );
  }

  Future<int> deleteById(int id) async {
    final database = await SossoldiDatabase.instance.database;

    return await database.delete(transactionTable,
        where:
        '${TransactionFields.id} = ?', // Use `:` if you will not use `sqflite_common_ffi`
        whereArgs: [id]);
  }

}