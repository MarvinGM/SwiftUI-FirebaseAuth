//
//  ContentView.swift
//  SwiftUI FirebaseAuth
//
//  Created by Amben on 6/24/21.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            //success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }// end of SignIn Function
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            //success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }// end of SignUp Function
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }// end of signout
    
}// end of AppViewModel which is ObservableObject

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel // viewModel that inherit the properties of AppViewModel
    
    var body: some View {
        NavigationView {
            
            if viewModel.signedIn {
                VStack {
                    
                    Text("You are Signed In")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .foregroundColor(Color.blue)
                            .padding()
                    })
                }
            }
            else {
                SignInView()
            }
            
        }// end of navigation view
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
        
    }// end of body
}// end of main contentView

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                
                //Email Field in SignInView
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                //Password Field in SignInView
                SecureField("Enter Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                //SignIn button in SignInView
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        print("zxc")
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Sign In")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50, alignment: .center)
                        .cornerRadius(8)
                        .background(Color.blue)
                })// end of SignIn button
                
                Spacer()
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
                
            }//end of VStack
            .padding()
            Spacer()
        }//end of VStack
        .navigationTitle("SwiftUI Sign In")
        
    }//end of body
}// end of struct SignInView

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        VStack {
            Image(systemName: "folder.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                
                //Email Field in SignUpView
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                //Password Field in SignUpView
                SecureField("Enter Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                //Create Account button in SignUpView
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50, alignment: .center)
                        .cornerRadius(8)
                        .background(Color.blue)
                })//end of Create Account button
            }//end of VStack
            .padding()
            
            Spacer()
        }//end of VStack
        .navigationTitle("SwiftUI Sign Up")
        
    }//end of body
}// end of struct SignUpView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            
    }
}
