//
//  NewItemView.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import SwiftUI

struct NewItemView: View {
    
    @State private var newItem = ToDoItemModel(
        title: "",
        description: "",
        userID: "",
        isChecked: false,
        isClicked: false
    )
    
    //Cursor automatically focused on the title Text Field
    enum FocusableField : Hashable{
        case title //set where the cursor should focus on
    }
    
    //property wrapper
    @FocusState private var focusField : Bool
    
    
    //Dismiss is to make the sheet disappear automatically
    @Environment(\.dismiss)
    private var dismiss //call as a function
    
    /* The dismiss function is called in the cancel() function
    This cancel() function is called as the action of Cancel Button */
    private func cancel(){
        dismiss()
    }
    
    
    //Function for save the new item
    var on_commit : (_ newItem: ToDoItemModel) -> Void
    
    /*When this function is called, the new item will be saved by the onCommit
    and the sheet will be closed by the dismiss function() */
    private func commit(){
        on_commit(newItem) //completion handle
        dismiss() //This dismiss function will close the sheet
    }
    
    
    var body: some View {
        NavigationView {
            Form{
                //Input title
                TextField("title", text: $newItem.title)
                    .focused($focusField) //cursor automatically focused in here
                
                //Input description
                TextField("Description", text: $newItem.description)
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline) //Title inline with Cancel and Add
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    //Call the commit function when the add button is clicked
                    Button(action: commit) {
                        Text("Add")
                    }
                    .disabled(newItem.title.isEmpty)
                    //if the title is empty, the add button is disabled
                }
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    //Call the cancel function when the cancel button is clicked
                    Button(action: cancel) {
                        Text("Cancel")
                    }
                }
            }
        }
        //Focus after 0.1 delay
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                focusField = true
            }
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView{
            newItem in print("Hello World! \(newItem.title)")
        }
    }
}
