//
//  RegisterView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var date = Date()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    // Main title
                    Text("Registro")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .foregroundStyle(.primary)
                        .padding(.bottom, 22)
                    
                    // Name Field
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Donathan Smith", text: $name)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Correo electrónico", text: $email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Phone Field
                    HStack {
                        Image(systemName: "phone")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        TextField("Teléfono", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Confirm Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .padding()
                            .foregroundStyle(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    
                    // Date picker
                    HStack {
                        Text("Fecha de nacimiento")
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .frame(width: 140, height: 0)
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Spacer()

                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("btIcon")
                    .resizable()
                    .foregroundStyle(colorScheme == .light ? Color.accentColor : .white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
        }
    }
}

#Preview {
    RegisterView()
}
