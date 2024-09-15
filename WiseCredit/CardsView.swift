//
//  CardsView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let lastFourDigits: String
    let cardType: String
    let cardTier: String
}

struct CardsView: View {
    @State private var cards: [Card] = [
        Card(lastFourDigits: "1411", cardType: "Mastercard", cardTier: "Platinum"),
        Card(lastFourDigits: "2222", cardType: "Mastercard", cardTier: "Gold"),
        Card(lastFourDigits: "3333", cardType: "Visa", cardTier: "Silver")
    ]
    @State private var showAddNewCardView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Título principal
                    Text("My Cards")
                        .font(CustomFonts.PoppinsSemiBold(size: 24))
                        .foregroundColor(.black)
                        .padding(.leading)

                    // Sección de tarjetas (carousel)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Botón de añadir nueva tarjeta
                            Button(action: {
                                showAddNewCardView.toggle()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .frame(width: 200, height: 130)
                                        .shadow(radius: 5)

                                    Text("+")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.black)
                                }
                            }
                            .fullScreenCover(isPresented: $showAddNewCardView) {
                                AddNewCardView()
                            }

                            // Tarjetas existentes
                            ForEach(cards) { card in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black)
                                        .frame(width: 200, height: 130)
                                        .shadow(radius: 5)

                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "creditcard.fill")
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("•••• \(card.lastFourDigits)")
                                                .foregroundColor(.white)
                                                .font(CustomFonts.PoppinsMedium(size: 16))
                                        }

                                        Spacer()

                                        Text(card.cardType)
                                            .foregroundColor(.white)
                                            .font(CustomFonts.PoppinsSemiBold(size: 16))

                                        Text(card.cardTier)
                                            .foregroundColor(.gray)
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                    }
                                    .padding(20) // Ajuste para que los textos estén correctamente alineados dentro de la tarjeta
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 160) // Ajusta el tamaño de la vista de las tarjetas para que tengan el tamaño correcto

                    // Configuración de la tarjeta
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Card Setting")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ToggleSettingRow(title: "Online Payment")
                        ToggleSettingRow(title: "ATM Withdrawals")
                        ToggleSettingRow(title: "International")
                    }

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción de dismiss o navegación hacia atrás
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Services")
                        .font(CustomFonts.PoppinsMedium(size: 16))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// Componente para cada fila con toggle
struct ToggleSettingRow: View {
    var title: String
    @State private var isOn = true

    var body: some View {
        HStack {
            Text(title)
                .font(CustomFonts.PoppinsMedium(size: 16))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal)
    }
}

struct AddNewCardView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Add New Card View")
                .font(CustomFonts.PoppinsBold(size: 24))

            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
