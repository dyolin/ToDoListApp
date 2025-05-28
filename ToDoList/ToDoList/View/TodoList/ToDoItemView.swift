//
//  ToDoItemView.swift
//  ToDoList
//
//  Created by 23 on 2025/3/17.
//

import SwiftUI

struct ToDoItemView: View {

    //create an instance of model
    @Binding var item : ToDoItemModel
    var viewModel: ToDoListViewModel
    var onItemChecked: () -> Void //function to notify when the item is checked
    
    //@State: if the variable is changed, the view is updated
    @State private var isDetailedSheetShown = false
        
    var body: some View {
        HStack{
            //SF Symbol
            Image(systemName: item.isChecked ? "record.circle" : "circle")
                .padding()
                .onTapGesture {
                    //to change the value of the isChecked
                    item.isChecked.toggle()
                    viewModel.updateItem(item) //update the new value to the database
                     if(item.isChecked){
                        onItemChecked() //notify when the isChecked = true
                    }
                }
            
            VStack(alignment: .leading){
                Text(item.title)
                    .padding(.bottom, 2)
                
                //Show the description if not empty
                if(!item.description.isEmpty){
                    Text(item.description)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            
            Spacer()
            
            //Info Button
            //When the isClicked = true, the info.circle image will be displayed
            if(item.isClicked){
                Button(action: {
                    //When the button is clicked, isDetailedSheetShown = true
                    isDetailedSheetShown = true
                }){
                    //Make the info.circle image as a button
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.plain)
            }
        }
        .font(.body)
        .padding()
        
        /* make the content rectangle, so we can click in the wider area
         If not use this, we need to click precisely at the text which is hard */
        .contentShape(Rectangle())
        .onTapGesture {
            item.isClicked.toggle() //change the value of isClicked
            viewModel.updateItem(item) //update the value to the database
        }
        
        //When the value of isDetailedSheetShown = true, the sheet will be presented
        .sheet(isPresented: $isDetailedSheetShown){
            //call which view to be shown
            ToDoItemDetailView(item: $item, viewModel: viewModel)
        }
    }
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(
            item: .constant(ToDoItemModel(
                title: "Eating",
                description: "Eat at 5",
                userID: "",
                isChecked: false,
                isClicked: false
            )),
            viewModel: ToDoListViewModel(),
            onItemChecked: {}
        )
    }
}
