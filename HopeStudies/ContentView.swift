//
//  ContentView.swift
//  HopeStudies
//
//  Created by Catarina Serrano on 4/13/21.
//  Copyright © 2021 Catarina Serrano. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        NavigationView{
            VStack{
                if self.status{
                    Homescreen()
                }
                else{
                    ZStack{
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show){
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                    
                }
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
            .onAppear{
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main){ (_) in
                
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    
                }
            }
        }
    }
}

struct Homescreen: View {
    var body: some View{
        VStack{
            Text("Login suceffuly completed !")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            
        }
    }
}


struct Login: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
     
        ZStack{
            ZStack(alignment: .topTrailing){
                GeometryReader{_ in
                    
                    VStack(spacing: 1){
                            Text("VACCINATION SCHEDULE")
                                .font(.system(size: 30, weight: .heavy, design: .default))
                                .foregroundColor(Color("Color"))
                                .multilineTextAlignment(.center)
                            Image("vaccine")
                            
                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                                .padding(.top, 25)
                            
                            HStack(spacing: 15){
                                VStack{
                                    if self.visible{
                                        TextField("Password", text: self.$pass)
                                    }
                                    else{
                                        SecureField("Password", text: self.$pass)
                                    }
                                }
                                
                                Button(action: {
                                    self.visible.toggle()
                                }){
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                                
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                            HStack{
                                
                                Spacer()
                                VStack(spacing: 60){
                                Button(action: {
                                    self.verify()
                                }) {
                                    Text("LOGIN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 50)
                                }
                                .background(Color("Color"))
                                .cornerRadius(10)
                                .padding(.top, 25)
                                
                                Button(action: {
                                    self.reset()
                                }){
                                    VStack(spacing: 50){
                                        Text("FORGOT MY PASSWORD")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.gray).opacity(0.7))
                                            .frame(width: UIScreen.main.bounds.width - 50)
                                        
                                        HStack(spacing: 34){
                                            
                                            Text("NEW HERE ?")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(.black))
                                            
                                            Button(action: {
                                                self.show.toggle()
                                                
                                            }) {
                                                Text("CREATE AN ACCOUNT")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color("Color"))
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                            .padding(.top, 20)
                        }
                        }
                        .padding(.horizontal, 25)
                }
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
        }
    }
    
    func verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password:self.pass){
                (res, err) in
                
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("Logged, we did it!")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else{
            self.error = "Please, fill all the fields"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email){
                (err) in
                if err != nil {
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
                return
            }
        }
        else{
            self.error = "Email not informed"
            self.alert.toggle()
        }
        
    }
    
}


struct SignUp: View {
    @State var color = Color.black.opacity(0.7)
    @State var firstname = ""
    @State var lastname = ""
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var age = ""
    @State var cpf = ""
    @State var cep = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
     
        ZStack{
            ZStack(alignment: .topLeading){
                GeometryReader{_ in
                    
                    VStack{
                        HStack{
                            TextField("First name", text: self.$firstname)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.firstname != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                            TextField("Last name", text: self.$lastname)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.lastname != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                        }
                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                                .padding(.top, 25)
                            
                            HStack(spacing: 15){
                                VStack{
                                    if self.visible{
                                        TextField("Password (least 6 characters)", text: self.$pass)
                                        .autocapitalization(.none)                                    }
                                    else{
                                        SecureField("Password (least 6 characters)", text: self.$pass)
                                        .autocapitalization(.none)
                                    }
                                }
                                
                                Button(action: {
                                    self.visible.toggle()
                                    
                                }){
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                                
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                        
                            HStack(spacing: 15){
                                VStack{
                                    if self.revisible{
                                        TextField("Confirm password", text: self.$repass)
                                    }
                                    else{
                                        SecureField("Confirm password", text: self.$repass)
                                    }
                                }
                                
                                Button(action: {
                                    self.revisible.toggle()
                                    
                                }){
                                    Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                                
                                
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack{
                            TextField("Age", text: self.$age)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.age != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            
                            
                            TextField("Identity number", text: self.$cpf)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.cpf != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        }
                        
                            TextField("Zipcode", text: self.$cep)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.cep != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        
                            Button(action: {
                                
                                self.register()
                                
                            }) {
                                Text("SIGN UP")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                        .background(Color("Color"))
                        .cornerRadius(10)
                            .padding(.top, 25)
                            
                        }
                        .padding(.horizontal, 25)
                }
                
                VStack(alignment: .leading, spacing: 10){
                    Button(action: {
                        self.show.toggle()
                        
                    }) {
                        
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(Color("Color"))
                    }
                    .padding()
                    
                    Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
                    .padding()
                }
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func register(){
        if self.email != "" {
            if self.pass == self.repass {
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    if err != nil {
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("sucess!!!")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }
                
            }
            else{
                self.error = "Password missmatch"
                self.alert.toggle()
            }
        }
        else {
            self.error = "Please, fill all the fields"
            self.alert.toggle()
        }
    }
}

struct ErrorView: View {
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View {
        GeometryReader{_ in
            VStack{
                HStack{
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "A link was sent to your email to reset your password" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
