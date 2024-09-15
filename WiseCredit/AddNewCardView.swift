//
//  AddNewCardView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI
import Firebase

struct AddNewCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardNumber1 = ""
    @State private var cardNumber2 = ""
    @State private var cardNumber3 = ""
    @State private var cardNumber4 = ""
    @State private var cardHolder = "Tom Hillson"
    @State private var expirationMonth = "05"
    @State private var expirationYear = "25"
    @State private var cvc = "092"
    @State private var isDefaultCard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Ocultar teclado al hacer tap en cualquier parte de la pantalla
                        UIApplication.shared.endEditing()
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Tarjeta representada como figura
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .frame(height: 200)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("••• \(cardNumber4)")
                                    .foregroundColor(.white)
                                    .font(CustomFonts.PoppinsMedium(size: 16))
                            }
                            Text("\(cardNumber1) \(cardNumber2) \(cardNumber3) \(cardNumber4)")
                                .foregroundColor(.white)
                                .font(CustomFonts.PoppinsSemiBold(size: 22))
                            
                            Text("Card Holder")
                                .foregroundColor(.gray)
                                .font(CustomFonts.PoppinsMedium(size: 14))
                            
                            Text(cardHolder)
                                .foregroundColor(.white)
                                .font(CustomFonts.PoppinsSemiBold(size: 18))
                        }
                        .padding(20)
                    }
                    .padding(.horizontal)
                    
                    // Sección de ingreso de información
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Enter Information")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.black)
                        
                        // Número de tarjeta
                        HStack(spacing: 10) {
                            TextField("1234", text: $cardNumber1)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            TextField("5678", text: $cardNumber2)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            TextField("9012", text: $cardNumber3)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            TextField("3456", text: $cardNumber4)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        
                        // Nombre del titular
                        TextField("Card Holder", text: $cardHolder)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        
                        // Fecha de expiración y CVC
                        HStack(spacing: 10) {
                            TextField("MM", text: $expirationMonth)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            TextField("YY", text: $expirationYear)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            TextField("CVC", text: $cvc)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        
                        //                        // Switch para marcar como tarjeta por defecto
                        //                        Toggle(isOn: $isDefaultCard) {
                        //                            Text("Mark as default card")
                        //                                .font(CustomFonts.PoppinsMedium(size: 14))
                        //                                .foregroundColor(.gray)
                        //                        }
                        //                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Botón para agregar tarjeta
                                        Button(action: addNewCardToFirebase) {
                                            Text("Add Card")
                                                .font(CustomFonts.PoppinsBold(size: 18))
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom, 20)
                } //
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Add New Card")
                        .font(CustomFonts.PoppinsMedium(size: 16))
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    // Función para agregar la tarjeta a Firebase
    func addNewCardToFirebase() {
        let db = Firestore.firestore()
        
        let cardData: [String: Any] = [
            "cardNumber1": cardNumber1,
            "cardNumber2": cardNumber2,
            "cardNumber3": cardNumber3,
            "cardNumber4": cardNumber4,
            "cardHolder": cardHolder,
            "expirationMonth": expirationMonth,
            "expirationYear": expirationYear,
            "cvc": cvc,
            "isDefaultCard": isDefaultCard
        ]
        
        db.collection("cards").addDocument(data: cardData) { error in
            if let error = error {
                print("Error adding card: \(error.localizedDescription)")
            } else {
                print("Card successfully added!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// Extensión para cerrar el teclado
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView()
    }
}

