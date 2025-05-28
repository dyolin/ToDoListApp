//
//  File.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import Foundation
import FirebaseFirestore
import Combine

class ToDoListViewModel : ObservableObject{
    //create an instance of the model
    @Published var todoLists = [ToDoItemModel]()
    var todolistRepository = TodolistRepositories()
    
    @Published var errorMessage : String?
    
    /*
     This function is to connect the todolist with the current login userID.
     So, the to do item that is being shown is a to do item that belongs the current user.
     */
    @Published var userID: String = ""{
        didSet{
            if(!userID.isEmpty){
                todolistRepository.subscribe(for: userID) //observe the update of specific userID
            }else{
                /*
                 When the user logs out, do not need to pay attention to any update.
                 Clear all the current to do list array.
                */
                todolistRepository.unsubscribe()
                todoLists = []
            }
        }
    }
    
    init(){
        /*  todolistRepository.$todoItems: access the todoItems from TodolistRepositories
            assign(to: &$todoLists): automatically updates todoLists whenever todoItems changes in the repository */
        todolistRepository.$todoItems.assign(to: &$todoLists)
    }
    
    func addItem(_ newItem: ToDoItemModel){
        do{
            //make the new variable because newItem from the parameter is immutable (can't be changed)
            var item = newItem
            
            item.userID = self.userID //set the item.userID to the current userID
            try todolistRepository.addTodoItems(item) //save the item that has the userID value
            
            errorMessage = nil
        }
        catch{
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func updateItem(_ item: ToDoItemModel){
        todolistRepository.updateTodoItems(item)
    }
    
    func deleteItem(_ item: ToDoItemModel){
        todolistRepository.deleteTodoItems(item)
    }
}
