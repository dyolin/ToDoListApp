//
//  User.swift
//  ToDoList
//
//  Created by 23 on 2025/4/28.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Identifiable, Codable{
    
    @DocumentID var id : String?
    var name: String = ""
    var email: String = ""
    var telephone: String
    var profileURL: URL?
}

extension User{
    //the database name in the Firebase to keep the user data
    static let userCollection = "userDB"
}
