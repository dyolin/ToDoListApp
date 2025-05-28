//
//  DescriptionView.swift
//  ToDoList
//
//  Created by 23 on 2025/3/29.
//

import SwiftUI

struct ToDoItemDetailView: View {
    //create model instance
    @Binding var item : ToDoItemModel
    var viewModel: ToDoListViewModel
    
    //@State: when the value of these variables changes, the view will be changed too
    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedDescription = ""
    
    //Dismiss is to make the sheet disappear automatically
    @Environment(\.dismiss)
    private var dismiss //call as a function
    
    /* The dismiss function is called in the close() function
    This close() function is called as the action of Close Button */
    private func close(){
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form{
                
                Section(header: Text("Title")) {
                    if(isEditing){ //in edit mode, use the text field to receive input
                        TextField("", text: $editedTitle)
                            .autocapitalization(.none)
                        
                    }else{ //not an edit mode, use text to just display the title
                        Text(item.title)
                    }
                }
                                
                Section(header: Text("Description")) {
                    if(isEditing){ //in edit mode, use the text field to receive input
                        TextEditor(text: $editedDescription)
                            .frame(minHeight: 100)
                            .autocapitalization(.none)
                        
                    }else{ //not an edit mode, use text to just display the title
                        Text(item.description.isEmpty ? "No Description" : item.description)
                            .foregroundColor(item.description.isEmpty ? Color.gray : Color.black)
                    }
                }
            }
            .navigationTitle(item.title + " Details")
            .navigationBarTitleDisplayMode(.inline) //title inline with Close and Edit
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    
                    /* If not edit mode, the button displays "Edit"
                    In edit mode, the button displays "Done" */
                    Button(isEditing ? "Done" : "Edit") {
                        
                        if(isEditing){
                            //Change the value of the item attribute to the new value
                            item.title = editedTitle
                            item.description = editedDescription
                            viewModel.updateItem(item) //update the database
                            
                        }else{
                            //When edit, the text field will show the current title and description.
                            editedTitle = item.title
                            editedDescription = item.description
                        }
                        isEditing.toggle() //change the value of isEditing
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: close) { //call close() function when button clicked
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct ToDoItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemDetailView(
            item: .constant(ToDoItemModel(
                    title: "Eating",
                    description: "",
                    userID: "",
                    isChecked: false,
                    isClicked: false
            )),
            viewModel: ToDoListViewModel()
        )
    }
}
