class UserModel {
  static final table = "users";
  static final col_id = 'id';
  static final col_name = 'name';
  static final col_age = 'age';
  static final col_is_checked = 'is_checked';


  static createSql() {
    var sql = '''
          CREATE TABLE IF NOT EXISTS $table (
            $col_id INTEGER PRIMARY KEY,
            $col_name TEXT NOT NULL,
            $col_age INTEGER NOT NULL,
            $col_is_checked CHAR(1) NOT NULL DEFAULT '0'
          )
          ''';
    print(sql);
    return sql;
  }

  int id;
  String name;
  int age;
  String is_checked;
  // ... more property

  UserModel();

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    age = map["age"];
    is_checked = map["is_checked"];
  }
}
