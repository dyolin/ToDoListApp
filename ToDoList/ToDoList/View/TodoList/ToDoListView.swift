//
//  ContentView.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import SwiftUI

struct ToDoListView: View {
    //property wrap
    @StateObject private var viewModel = ToDoListViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    //variable to check if the NewItemView sheet is presented
    @State private var isAddToDoItemDialogPresented = false
    
    //Function to change the value of isAddToDoItemDialogPresented from false to true
    private func presentAddToDoItemView(){
        isAddToDoItemDialogPresented.toggle() //change the variable value
    }
    
    //Function to Delete item in 3 seconds
    private func deleteItemAfterDelay(_ item: ToDoItemModel){
        
        //set the deadline +3 for 3 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            viewModel.deleteItem(item) //delete item directly from the database
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                //Show all the to do item that has been made
                ForEach($viewModel.todoLists) { $item in
                    ToDoItemView(
                        item : $item,
                        viewModel: viewModel,
                        onItemChecked: {deleteItemAfterDelay(item)}
                        /*
                         When the onItemChecked : Void from the ToDoItemView notify that
                         the value of isChecked = true, deleteItemAfterDelay(item) function
                         will be executed.
                         */
                    )
                    
                    //Swipe to Delete
                    .listStyle(.plain)
                    .swipeActions(edge: .trailing){ //swipe from trailing to leading
                        Button(role: .destructive){
                            viewModel.deleteItem(item) //delete directly from the database
                        }label: {
                            Label("Delete", systemImage: "trash") //show the trash icon
                        }
                    }
                }
            }
            .navigationTitle("To Do List")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    //Call the signOut function from authViewModel when button is clicked
                    Button(action: {authViewModel.signOut()}){
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    /*
                     Call the presentAddToDoItemView() function when the button is clicked.
                     The function will change the value of isAddToDoItemDialogPresented
                     from false to true.
                     Then, the sheet will be displayed.
                     */
                    Button(action: {presentAddToDoItemView()})
                    {
                        Label("Add", systemImage: "plus")
                    }
                }
                
            }
            
            //When isAddToDoItemDialogPresented = true, the sheet will be displayed
            .sheet(isPresented: $isAddToDoItemDialogPresented) {
                NewItemView{
                    newItem in viewModel.addItem(newItem) //add the new item to the database
                }
            }
        }
        
        /*
         This function is to show to do items that correspond with the current user.
         onChange function is to handle updating the user ID when the current user is changed.
         */
        
        .onChange(of: authViewModel.user){
            newUser in viewModel.userID = newUser?.uid ?? ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
