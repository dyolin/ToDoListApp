//
//  SignUpView.swift
//  ToDoList
//
//  Created by 23 on 2025/5/5.
//

import SwiftUI

struct SignUpView: View {
    @State var name = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    @State var isPasswordHidden = true
    
    let authViewModel = AuthViewModel()
    
    var onPasswordHidden: () -> Void
    
    var body: some View {
        ZStack {
            Image("background_app")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("app_logo")
                
                Text("Sign up your Account")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .padding(.top, 20)
                
                VStack(alignment: .leading){
                    //Name input
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    if(name.isEmpty){
                        Text("Name is required")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //Phone number input
                    TextField("Enter your phone number", text: $phoneNumber)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    if(phoneNumber.count != 11 || !phoneNumber.starts(with: "1")){
                        Text("Phone number is invalid!")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //Email Input
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    if(!email.contains("@")){
                        Text("Email is invalid!")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //Password Input
                    if(isPasswordHidden){
                        SecureField("Enter your password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .overlay {
                                HStack{
                                    Spacer()
                                    Image(systemName: "eye.slash")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            isPasswordHidden.toggle()
                                            if(!isPasswordHidden){
                                                onPasswordHidden()
                                            }
                                        }
                                }
                                .padding()
                            }
                    }else{
                        TextField("Enter your password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .overlay {
                                HStack{
                                    Spacer()
                                    Image(systemName: "eye.fill")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            isPasswordHidden.toggle()
                                            if(isPasswordHidden){
                                                onPasswordHidden()
                                            }
                                        }
                                }
                                .padding()
                            }
                    }
                    
                    if(password.count < 6){
                        Text("Password must contain of 6 characters long or more.")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                    }
                }
                
                /*
                 User can only create an account if all the input is valid.
                 
                 When user click the sign up button, a new user account will be created.
                 User can automatically enter the app.
                 */
                
                
                //SignUp Button
                if(email.contains("@") && password.count >= 6 && !name.isEmpty && phoneNumber.count == 11 && phoneNumber.starts(with: "1")){
                    Button(action:{
                        authViewModel.signUpWithEmail(email: email, password: password, name: name, phoneNumber: phoneNumber)
                    }){
                        Text("Sign Up")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .fontWeight(.semibold)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .font(.system(size: 14))
            .padding()
            .padding(.top, 60)
            .padding(.bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(onPasswordHidden: {})
    }
}
