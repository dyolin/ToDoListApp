//
//  SwiftUIView.swift
//  ToDoList
//
//  Created by 23 on 2025/5/5.
//

import SwiftUI

struct PhoneLoginView: View {
    @State var phoneNumber = ""
    @State var smsCode = ""
    
    @StateObject var authViewModel = AuthViewModel()
    
    //phone number validation (11 digits and start with 1)
    var isPhoneNumberValid: Bool {
        return phoneNumber.count == 11 && phoneNumber.starts(with: "1")
    }
    
    var body: some View {
        ZStack{
            Image("background_app")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("app_logo")
                
                Text("Sign in using Phone Number")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.bottom, 2)
                
                Text("Enter your phone number to log in")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                //Phone Number Input
                TextField("Enter your phone number", text: $phoneNumber)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                //Check the phone number
                if(!isPhoneNumberValid){
                    Text("Phone number is invalid!")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }else{ //Shown only when the phone number is valid
                    
                    /*
                     After user fill in the right phone number, the "Send Verification Code"
                     button will be displayed.
                     User will click it.
                     authViewModel.startPhoneVerification(phoneNumber: phoneNumber) is running.
                     
                     Then, the authViewModel.isVerificationCodeSent will change to true.
                     Ask user to input the verification code.
                     
                     User will click the "Verify code button".
                     authViewModel.verifyCode(smsCode: smsCode) is running.
                     
                     If the input code is correct, user will log in successfully
                    */
                    
                    //Verification code input
                    if(authViewModel.isVerificationCodeSent == true){
                        TextField("Enter the verification code", text: $smsCode)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        //Check the input code when the button is clicked
                        Button(action:{
                            authViewModel.verifyCode(smsCode: smsCode)
                        }){
                            Text("Verify Code")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .fontWeight(.semibold)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.vertical)
                        
                    //Show the "Send Verification Code" button
                    }else{
                        Button(action:{authViewModel.startPhoneVerification(phoneNumber: phoneNumber)}){
                            Text("Send Verification Code")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .fontWeight(.semibold)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.vertical)
                    }
                }
                
                Spacer()
                
            }
            .font(.system(size: 14))
            .padding()
            .padding(.top, 60)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PhoneLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLoginView()
    }
}
