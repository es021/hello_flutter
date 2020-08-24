
// @new_entity - model
class TaskModel {

  static final table = "tasks";
  static final col_id = 'id';
  static final col_title = 'title';
  static final col_desc = 'desc';
  static final col_is_checked = 'is_checked';
  static final col_created_at = 'created_at';
  static final col_updated_at = 'updated_at';

  static listSql() {
    var sql = '''
          SELECT * FROM $table 
          ORDER BY $col_is_checked asc, $col_id desc
          ''';
    print(sql);
    return sql;
  }

  static createSql() {
    var sql = '''
          CREATE TABLE IF NOT EXISTS $table (
            $col_id INTEGER PRIMARY KEY,
            $col_title TEXT NOT NULL,
            $col_desc TEXT,
            $col_is_checked CHAR(1) NOT NULL DEFAULT '0',
            $col_created_at INTEGER DEFAULT (cast(strftime('%s','now') as int)),
            $col_updated_at INTEGER
          )
          ''';
    print(sql);
    return sql;
  }

  int id;
  String title;
  int desc;
  String is_checked;
  int created_at;
  int updated_at;
  // ... more property

  TaskModel();

  TaskModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    desc = map["desc"];
    is_checked = map["is_checked"];
    created_at = map["created_at"];
    updated_at = map["updated_at"];
  }
}
