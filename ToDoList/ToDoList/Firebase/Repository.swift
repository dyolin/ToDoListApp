//
//  Repository.swift
//  ToDoList
//
//  Created by 23 on 2025/4/14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
import Factory

public class TodolistRepositories: ObservableObject{
    
    @Published var todoItems = [ToDoItemModel]()
    private var listenerRegistration : ListenerRegistration?
    
    /*
     This init function is moved to the ToDoListViewModel
     Because we want to only show the to do item that belongs to the current user.
     So, we only need to subscribe to the current user's to do list.
     
     The ToDoListViewModel becomes the bridge that connects the user to his to do list
     */
    
/*
    init{
        subscribe()
        
    }
*/
    
    deinit{
        unsubscribe()
    }
    
    func addTodoItems(_ todoItem : ToDoItemModel) throws{
        
        /*
         Access the database that keep the todoItem.
         Add the new to do item inside that database
        */
        
        try Firestore.firestore().collection(ToDoItemModel.collectionName).addDocument(from: todoItem)
    }
    
    func updateTodoItems(_ todoItem : ToDoItemModel) {
        
        //get the ID of the todoItem that wants to be updated
        guard let documentID = todoItem.id else{
            print("Document ID has no value")
            return
        }
        
        print("Update document with ID: \(documentID)")
        
        /*
         Access the database that keep the todoItem.
         Access the to do item that want to be updated.
         Update the certain field of the todoItem.
        */
        
        Firestore.firestore().collection(ToDoItemModel.collectionName).document(documentID).updateData([
            "title" : todoItem.title,
            "description" : todoItem.description,
            "isChecked" : todoItem.isChecked,
            "isClicked" : todoItem.isClicked
        ])
    }
    
    func deleteTodoItems(_ todoItem : ToDoItemModel){
        
        //get the ID of the todoItem that wants to be deleted
        guard let documentID = todoItem.id else{
            print("Document not found")
            return
        }
        
        /*
         Access the database that keep the todoItem.
         Access the to do item that want to be deleted.
         Delete the todoItem.
        */
        
        Firestore.firestore().collection(ToDoItemModel.collectionName).document(documentID).delete { error in
            if let error = error {
                print("Error deleting item: \(error.localizedDescription)")
            }else{
                print("Item deleted")
            }
        }
    }
    
    //Listen the changes of data stored in Firestore
    
    func subscribe(for userID: String){
        unsubscribe() //to avoid duplicate listeners
        
        if listenerRegistration == nil {
            
            /*
             Access the database that keep the todoItem.
             Find the todoItem that the userID field is same with the current user's ID.
             
             Listen only to that item(s)
            */
            
            let query = Firestore.firestore().collection(ToDoItemModel.collectionName).whereField("userID", isEqualTo: userID)
            
            listenerRegistration = query.addSnapshotListener { querySnapshot, error in
                
                //guard let unwrap for optional variables
                //Error for empty database
                guard let documents = querySnapshot?.documents else{
                    print("no document in this collection")
                    return
                }
                
                /*
                 Firebase document has a different structure from Swift object
                 compactMap function is to convert the structure from the Firebase into the structure for Swift object
                 compactMap can also automatically manages @DocumentID
                */
                
                self.todoItems = documents.compactMap{queryDocumentSnapshot in
                    do{
                        return try queryDocumentSnapshot.data(as: ToDoItemModel.self)
                    }catch{
                        print("error when mapping the documents")
                        return nil
                    }
                    
                }
            }
        }
    }
    
    func unsubscribe(){
        //Stop listening to the updates in the todolist database
        if listenerRegistration != nil{
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
}
