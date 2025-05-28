//
//  LoginView.swift
//  ToDoList
//
//  Created by 23 on 2025/4/27.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isPasswordHidden = true
    @State var isRememberMe = false
    
    let authViewModel = AuthViewModel()
    
    var onPasswordHidden: () -> Void
    var onRememberMe: () -> Void
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Image("background_app")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("app_logo")
                    
                    Text("Sign in to your Account")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                        .padding(.bottom, 2)
                        
                    Text("Enter your email and password to log in")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    
                    //Email Input
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        
                    //Password Input
                    if(isPasswordHidden){
                        SecureField("Enter your password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                        //Show hiding password icon
                            .overlay {
                                HStack{
                                    Spacer()
                                    Image(systemName: "eye.slash")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            isPasswordHidden.toggle() //isPasswordHidden = false
                                            if(!isPasswordHidden){
                                                onPasswordHidden() //notify the value
                                            }
                                        }
                                }
                                .padding()
                            }
                    }else{ //the password is shown (not hidden)
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
                                            isPasswordHidden.toggle() //isPasswordHidden = true
                                            if(isPasswordHidden){
                                                onPasswordHidden() //notify the value
                                            }
                                        }
                                }
                                .padding()
                            }
                    }
                    
                    //Remember Me and Forgot Password
                    HStack{
                        //Remember Me
                        HStack{
                            Image(systemName: isRememberMe ? "checkmark.square.fill" : "square")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    isRememberMe.toggle() //change value
                                    if(isRememberMe){
                                        onRememberMe() //notify the value
                                    }
                                }
                            Text("Remember me")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        //Forgot Password
                        Button(action: {/* no action */}){
                            Text("Forgot Password ?")
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical)
                    
                    /*
                     When user has already make an account by using email,
                     user need to input the correct email and password.
                     
                     If the email and password is correct,
                     authViewModel.signInWithEmail(email: email, password: password)
                     will let the user sign in successfully.
                     
                     However, if user hasn't make any account by email, user needs
                     to go to the Sign Up section.
                    */
                    
                    //Login Button
                    Button(action:{
                        authViewModel.signInWithEmail(email: email, password: password)
                    }){
                        Text("Log In")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .fontWeight(.semibold)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                    
                    //Divider
                    HStack{
                        Rectangle()
                            .frame(height: 0.3) //to look like a line
                        
                        Text("Or")
                            .padding(.horizontal)
                            .font(.system(size: 14))
                        
                        Rectangle()
                            .frame(height: 0.3) //to look like a line
                    }
                    .foregroundColor(.gray)
                    
                    //Other Login Method
                    VStack{
                        
                        //Google Login
                        Button(action:{
                            authViewModel.signInWithGoogle() //call function when clicked
                            
                            /*
                             This function will redirect user to the Google Sign In API.
                             
                             If user can sign in to their google account successfully,
                             user can sign in to this app successfully too.
                            */
                            
                        }){
                            HStack{
                                Image("google_logo")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Continue with Google")
                            }
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                        }
                        .padding(.top)
                        
                        //Phone Login
                        //Go to the PhoneLoginView Page when clicked
                        NavigationLink(destination: PhoneLoginView()){
                            HStack{
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("Continue with Phone Number")
                            }
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                        
                        Spacer()
                    }
                    
                    /*
                     If user hasn't ever make an account yet, user need to click
                     the Sign Up button. Then user will be redirected to the Sign Up Page
                     */
                    
                    //Sign Up
                    HStack{
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        //Go to the SignUpView Page when clicked
                        NavigationLink(destination: SignUpView(email: "", password: "", isPasswordHidden: true, onPasswordHidden: {})){
                            Text("Sign Up")
                        }
                    }
                    .padding(.bottom)
                    
                }
                .font(.system(size: 14))
                .padding()
                .padding(.top, 60)
                .padding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear) //background color is transparent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onPasswordHidden: {}, onRememberMe: {})
    }
}
