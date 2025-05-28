//
//  UserRepository.swift
//  ToDoList
//
//  Created by 23 on 2025/5/6.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserRepository {
    func createUser(_ user: FirebaseAuth.User, _ newUser: User) {
        
        /*
         When we create a user in the sign in or sign up function from the AuthViewModel
         Firebase has created a user for its own authentication.
         
         We want to keep that user in our own database.
         The user we want to keep and the user from the Firebase has to have the same id.
         
         Access our database that is used to keep the user's data.
         Access the user ID of the FirebaseAuth.user
         
        */
        
        let userRef = Firestore.firestore().collection(User.userCollection).document(user.uid)

        /*
         If the document with that user ID is found, it means that user has been created.
         
         This can happen because the function to sign in with Google and sign in with phone number.
         These two functions provide for new user and also for existed users to log in.
         
         Therefore, we give error to prevent creating the same user.
         Because for users that only wants to log in, we don't need to save it again in the database.
        */
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                //prevent in creating the same user
                print("User document already exists")
                
            }else { //If the document with that userID is not found, that means it is a new user
                do {
                    
                    /*
                     When we create a new user, Firebase also creates a user for its own.
                     That means Firebase has the data of that new user.
                     
                     We only need to get that new user data from the Firebase.
                     We can also save additional data that we need.
                     Then, we save it in our own database.
                     
                     When we create newUser as an instance of our own User class.
                     We can use the Firebase user data (like uid, email, photo profile, etc).
                     For data that we want to be the same as Firebase user, just call it.
                     
                     For additional data, (in here: name, phoneNumber),
                     we can get them from the user input in our sign up form.
                    */
                    
                /* This code is in the AuthViewModel
                 
                    let newUser = User(
                        id: user.uid,
                        name: name,
                        email: user.email ?? "",
                        telephone: phoneNumber,
                        profileURL: user.photoURL
                    )
                */
                    /*
                     After creating the newUser, we keep it in our database
                     setData function will create a new document
                     Because we don't have a document with current userID
                     (because it is a new user)
                    */
                    
                    try userRef.setData(from: newUser)
                    print("User saved to Firestore")
                } catch {
                    print("Failed to save user: \(error.localizedDescription)")
                }
            }
        }
        
    }
}
