//
//  TDDBManager.swift
//  ToDo
//
//  Created by 김태훈 on 2020/11/10.
//
//
//import Foundation
//import SQLite3
//
//class TDDBManager {
//
//    let path: String = {
//        let fm = FileManager.default
//        return fm.urls(for: .libraryDirectory, in: .userDomainMask).last!
//            .appendingPathComponent("TD.db").path
//    }()
//
//    let createTableString = """
//        CREATE TABLE IF NOT EXISTS TD(
//        id INTEGER PRIMARY KEY AUTOINCREMENT,
//        title CHAR(50),
//        description CHAR(255),
//        date DATETIME);
//    """
//
//    var db: OpaquePointer?
//
//    init(){
//        if sqlite3_open(path, &db) == SQLITE_OK {
//            if sqlite3_exec(db, createTableString, nil, nil, nil) == SQLITE_OK {
//                return
//            }
//        } else{
//            // let errMsg = String.init(cString: sqlite3_errmsg(db))
//            print("Unable to open DB.")
//        }
//    }
//    deinit {
//        sqlite3_close(db)
//    }
//
//    func insertTD(title: String, description: String) -> Int{
//        let insertStmtString = "INSERT INTO TD(title, description, date) VALUES(?, ?, DateTime(CURRENT_TIMESTAMP);"
//
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare(db, insertStmtString, -1, &stmt, nil) == SQLITE_OK {
//            sqlite3_bind_text(stmt, 1, title, -1, nil)
//            sqlite3_bind_text(stmt, 2, description, -1, nil)
//
//            if sqlite3_step(stmt) == SQLITE_DONE {
//                print("\nInsert row Success")
//            } else{
//                print("\nInsert row Failed")
//            }
//        } else{
//            print("\nInsert Statement is not prepared")
//        }
//        sqlite3_finalize(stmt)
//        return Int(sqlite3_last_insert_rowid(db))
//    }
//
//    func updateTD(id: Int, title: String, description: String) {
//        let modifyStmtString = "UPDATE TD SET title = ?, description = ?, date = DateTime(CURRENT_TIMESTAMP) WHERE id = ?;"
//
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare(db, modifyStmtString, -1, &stmt, nil) == SQLITE_OK {
//            sqlite3_bind_text(stmt, 1, title, -1, nil)
//            sqlite3_bind_text(stmt, 2, description, -1, nil)
//            sqlite3_bind_int(stmt, 3, -1)
//
//            if sqlite3_step(stmt) == SQLITE_DONE{
//                print("\nUpdate row Success")
//            } else{
//                print("\nUpdate row Failed")
//            }
//        } else {
//            print("\nUPdate Statement is not prepared")
//        }
//        sqlite3_finalize(stmt)
//    }
//
//    func deleteTD(id: Int){
//        let deleteStmtString = "DELETE FROM TD WHERE id = \(id);"
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare(db, deleteStmtString, -1, &stmt, nil) == SQLITE_OK {
//            if sqlite3_step(stmt) == SQLITE_DONE {
//                print("\nDelete row Success")
//            } else {
//                print("\nDelete row Failed")
//            }
//        } else {
//            print("\nDelete Stmt is not prepared")
//        }
//        sqlite3_finalize(stmt)
//    }
//
//    func fetchTD() -> [TDItem] {
//        let quaryStmtString = "SELECT * FROM TD;"
//        var items: [TDItem] = []
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare(db, quaryStmtString, -1, &stmt, nil) == SQLITE_OK{
//            while(sqlite3_step(stmt) == SQLITE_ROW) {
//                let ids = Int(sqlite3_column_int(stmt, 0))
//                guard let titles = sqlite3_column_text(stmt, 1) else{
//                    continue
//                }
//                guard let descriptions = sqlite3_column_text(stmt, 2) else{
//                    continue
//                }
//                guard let dates = sqlite3_column_text(stmt, 3) else{
//                    continue
//                }
//                let title = String(cString: titles)
//                let desc = String(cString: descriptions)
//                let date = String(cString: dates)
//
//                let item = TDItem(id: ids, title: title, description: desc, date: date)
//                items.append(item)
//            }
//        } else {
//            print("\nFetch Stmt is not prepared")
//        }
//        sqlite3_finalize(stmt)
//        return items
//    }
//}
