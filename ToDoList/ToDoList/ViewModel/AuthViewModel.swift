//
//  AuthViewModel.swift
//  ToDoList
//
//  Created by 23 on 2025/4/28.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel: ObservableObject{
    @Published var isLoggedIn: Bool = false
    @Published var isVerificationCodeSent: Bool = false
    
    @Published var user: FirebaseAuth.User? = nil
    let userRepository = UserRepository()
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(){
        listenToAuthState()
    }
    
    func listenToAuthState(){
        //This is to set up a Firebase Authentication state listener that tracks whether a user is logged in or out
        handle = Auth.auth().addStateDidChangeListener{ [weak self] auth, user in
            if let user = user{
                self?.user = user
                self?.isLoggedIn = true
                print("login with: \(user.uid)")
            }else{
                self?.user = nil
                self?.isLoggedIn = false
                print("not login")
            }
        }
    }
    
    /*
     For Sign In
     
     When Auth.auth().signIn(...) running, it trigers the Auth.auth().addStateDidChangeListener
     in the listenToAuthState() function.
     
     If no error occurs, FirebaseAuth knows that a user has logged in.
     So, isLoggedIn = true and user from FirebaseAuth.User has value
    */
    
    func signInWithEmail(email: String, password: String){
        
        /*
         Sign in with email requires user to create an account first.
         So, users that successfully sign in has already had an account for sure.
         
         That's why, we don't create a new user in here.
        */
        
        //FirebaseAuth function to sign in with email
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in
            if let error = error{
                print("Email login failed: \(error.localizedDescription)")
            }else{
                print("Email login successed: \(result?.user.email ?? "")")
            }
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String, phoneNumber: String){
        //FirebaseAuth function to create a new user
        Auth.auth().createUser(withEmail: email, password: password){
            authResult, error in
            if let error = error{
                print("Email sign up failed: \(error.localizedDescription)")
                return
            }
            
            /*
             Create User for our database
             
             Get the user that has been created by the FirebaseAuth
             Create our own User instance (in here is newUser)
             Filled in newUser attribute.
             
             For data that has been provided by FirebaseAuth, we can use it directly
             The one that has "user. " is form the FirebaseAuth data
             
             For additional data, we get it from the parameter.
             The parameter gets its value from the user input in the View.
            */
            
            //get the user from FirebaseAuth
            guard let user = authResult?.user else {
                return
            }
            
            //Make newUser instance from our User class
            let newUser = User(
                id: user.uid,
                name: name,
                email: user.email ?? "",
                telephone: phoneNumber,
                profileURL: user.photoURL
            )
            
            //Call the createUser from userRepository to save the user in our database
            self.userRepository.createUser(user, newUser)
            print("Email sign up successed: \(authResult?.user.email ?? "unknown")")
        }
    }
    
    func signInWithGoogle(){
        //Set up for Google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID
        else{
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController
        else{
            print("no rootViewController")
            return
        }
        
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {
            result, error in
            if let error = error{
                print("Google login failed: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = result?.user.idToken?.tokenString,
                  let accessToken = result?.user.accessToken.tokenString
            else{
                print("Google login without token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential){ authResult, error in
                if let error = error{
                    print("Firebase Google login failed: \(error.localizedDescription)")
                }else{
                    
                    /*
                     Create User for our database
                     
                     Get the user that has been created by the FirebaseAuth
                     Create our own User instance (in here is newUser)
                     Filled in newUser attribute.
                     
                     For data that has been provided by FirebaseAuth, we can use it directly
                     The one that has "user. " is form the FirebaseAuth data
                     
                     For additional data, we get it from the parameter.
                     The parameter gets its value from the user input in the View.
                    */
                    
                    //get the user from FirebaseAuth
                    guard let user = authResult?.user else {
                        return
                    }
                    
                    //Make newUser instance from our User class
                    let newUser = User(
                        id: user.uid,
                        name: user.displayName ?? "",
                        email: user.email ?? "",
                        telephone: user.phoneNumber ?? "",
                        profileURL: user.photoURL
                    )
                    
                    //Call the createUser from userRepository to save the user in our database
                    self.userRepository.createUser(user, newUser)
                    
                    print("Firebase Google login successful: \(authResult?.user.displayName ?? "")")
                }
            }
        }
    }
    
    func startPhoneVerification(phoneNumber: String){
        
        //Format the phone number to have a country code
        let phoneNumberFormatted = "+86\(phoneNumber)"
        print("phone number: \(phoneNumberFormatted)")
        
        //Use the formatted phone number to register a user in the Firebase
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberFormatted, uiDelegate: nil){ verificationID, error in
            if let error = error{
                print("failed to send verify code: \(error.localizedDescription)")
            }else{
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.isVerificationCodeSent = true //set to true when the verification code is sent
                print("success to send verify code using")
                
            }
        }
    }
    
    
    func verifyCode(smsCode: String){
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        else{
                print("no verification ID stored")
                return
            }
        
        print("sms code: \(smsCode)")
        
        //check the verification code and the code from user input
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        
        Auth.auth().signIn(with: credential){ result, error in
            if let error = error{
                print("wrong code: \(error.localizedDescription)")
            }else{
                
                /*
                 Create User for our database
                 
                 Get the user that has been created by the FirebaseAuth
                 Create our own User instance (in here is newUser)
                 Filled in newUser attribute.
                 
                 For data that has been provided by FirebaseAuth, we can use it directly
                 The one that has "user. " is form the FirebaseAuth data
                 
                 For additional data, we get it from the parameter.
                 The parameter gets its value from the user input in the View.
                */
                
                //get the user from FirebaseAuth
                guard let user = result?.user else {
                    return
                }
                
                //Make newUser instance from our User class
                let newUser = User(
                    id: user.uid,
                    name: user.displayName ?? "",
                    email: user.email ?? "",
                    telephone: user.phoneNumber ?? "",
                    profileURL: user.photoURL
                )
                
                //Call the createUser from userRepository to save the user in our database
                self.userRepository.createUser(user, newUser)
                
                print("code verified: \(result?.user.displayName ?? "")")
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            
            /*
             When Auth.auth().signOut() running, it trigers the Auth.auth().addStateDidChangeListener
             in the listenToAuthState() function.
             
             Then, FirebaseAuth knows that the user has logged out.
             So, user = nil and isLoggedIn = false
             */
        }catch{
            print("Failed Sign Out \(error.localizedDescription)")
        }
    }
    
}
