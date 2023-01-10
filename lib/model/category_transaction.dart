import '../database/sossoldi_database.dart';
import 'base_entity.dart';

const String categoryTransactionTable = 'categoryTransaction';

class CategoryTransactionFields extends BaseEntityFields {
  static String id = 'id';
  static String name = 'name';
  static String symbol = 'symbol';
  static String note = 'note';
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';

  static final List<String> allFields = [
    BaseEntityFields.id,
    name,
    symbol,
    note,
    BaseEntityFields.createdAt,
    BaseEntityFields.updatedAt
  ];
}

class CategoryTransaction extends BaseEntity {
  final String name;
  final String? symbol;
  final String? note;

  const CategoryTransaction(
      {int? id,
      required this.name,
      this.symbol,
      this.note,
      DateTime? createdAt,
      DateTime? updatedAt})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  CategoryTransaction copy(
          {int? id,
          String? name,
          String? symbol,
          String? note,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CategoryTransaction(
          id: id ?? this.id,
          name: name ?? this.name,
          symbol: symbol ?? this.symbol,
          note: note ?? this.note,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt);

  static CategoryTransaction fromJson(Map<String, Object?> json) =>
      CategoryTransaction(
          id: json[BaseEntityFields.id] as int?,
          name: json[CategoryTransactionFields.name] as String,
          symbol: json[CategoryTransactionFields.symbol] as String,
          note: json[CategoryTransactionFields.note] as String,
          createdAt: DateTime.parse(json[BaseEntityFields.createdAt] as String),
          updatedAt:
              DateTime.parse(json[BaseEntityFields.updatedAt] as String));

  Map<String, Object?> toJson() => {
        BaseEntityFields.id: id,
        CategoryTransactionFields.name: name,
        CategoryTransactionFields.symbol: symbol,
        CategoryTransactionFields.note: note,
        BaseEntityFields.createdAt: createdAt?.toIso8601String(),
        BaseEntityFields.updatedAt: updatedAt?.toIso8601String(),
      };
}

class CategoryTransactionMethods extends SossoldiDatabase {
  Future<CategoryTransaction> insert(CategoryTransaction item) async {
    final database = await SossoldiDatabase.instance.database;
    final id = await database.insert(categoryTransactionTable, item.toJson());
    return item.copy(id: id);
  }


  Future<CategoryTransaction> selectById(int id) async {
    final database = await SossoldiDatabase.instance.database;

    final maps = await database.query(
      categoryTransactionTable,
      columns: CategoryTransactionFields.allFields,
      where: '${CategoryTransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CategoryTransaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
      // reutrn null;
    }
  }

  Future<List<CategoryTransaction>> selectAll() async {
    final database = await SossoldiDatabase.instance.database;

    final orderByASC = '${CategoryTransactionFields.createdAt} ASC';

    // final result = await database.rawQuery('SELECT * FROM $tableExample ORDER BY $orderByASC')
    final result = await database.query(categoryTransactionTable, orderBy: orderByASC);

    return result.map((json) => CategoryTransaction.fromJson(json)).toList();
  }

  Future<int> updateItem(CategoryTransaction item) async {
    final database = await SossoldiDatabase.instance.database;

    // You can use `rawUpdate` to write the query in SQL
    return database.update(
      categoryTransactionTable,
      item.toJson(),
      where:
      '${CategoryTransactionFields.id} = ?', // Use `:` if you will not use `sqflite_common_ffi`
      whereArgs: [item.id],
    );
  }

  Future<int> deleteById(int id) async {
    final database = await SossoldiDatabase.instance.database;

    return await database.delete(categoryTransactionTable,
        where:
        '${CategoryTransactionFields.id} = ?', // Use `:` if you will not use `sqflite_common_ffi`
        whereArgs: [id]);
  }

}