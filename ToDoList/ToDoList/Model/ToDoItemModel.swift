//
//  ToDoItemModel.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import Foundation
import FirebaseFirestoreSwift

struct ToDoItemModel : Identifiable, Codable{
    @DocumentID var id : String?
    var title: String
    var description: String
    
    var userID: String
    
    var isChecked: Bool //variable for circle on the left side of to do item
    var isClicked: Bool //variable for info circle on the right side of to do item
    
}

extension ToDoItemModel{
    //the database name in the Firebase to save to do item data
    static let collectionName = "todoItems"
}
