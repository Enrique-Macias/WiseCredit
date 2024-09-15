//
//  CalculationView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct BankInfo: Identifiable {
    let id = UUID()
    let bankImage: String
    let bankName: String
    let monthlyPayment: Double
    let commission: Double
    let interestRate: Double
    let cat: Double
}

struct CalculationView: View {
    @Environment(\.presentationMode) var presentationMode  // Para manejar el dismiss

    // Datos de bancos de manera estática por ahora
    let banks: [BankInfo] = [
        BankInfo(bankImage: "bank1", bankName: "BBVA Bancomer", monthlyPayment: 1500, commission: 1.2, interestRate: 3.5, cat: 12.3),
        BankInfo(bankImage: "bank2", bankName: "American Express", monthlyPayment: 1450, commission: 1.5, interestRate: 4.0, cat: 13.1),
        BankInfo(bankImage: "bank3", bankName: "Santander", monthlyPayment: 1550, commission: 1.0, interestRate: 3.2, cat: 11.8),
        BankInfo(bankImage: "bank4", bankName: "Banamex", monthlyPayment: 1400, commission: 1.3, interestRate: 4.5, cat: 14.0),
        BankInfo(bankImage: "bank5", bankName: "Banregio", monthlyPayment: 1480, commission: 1.4, interestRate: 3.8, cat: 12.5)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TabView {
                        ForEach(banks.prefix(5)) { bank in
                            VStack(spacing: 20) {
                                // Imagen del banco
                                Image(bank.bankImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 200)
                                    .padding(.top, 20)
                                
                                // Nombre del banco
                                Text(bank.bankName)
                                    .font(CustomFonts.PoppinsSemiBold(size: 24))
                                    .foregroundColor(.black)
                                
                                // Tarjeta de información combinada
                                VStack(spacing: 20) {
                                    // Sección de monto y detalles
                                    VStack(spacing: 10) {
                                        Text("Monthly Payment")
                                            .font(CustomFonts.PoppinsMedium(size: 18))
                                            .foregroundColor(.gray)
                                        
                                        Text("$\(String(format: "%.2f", bank.monthlyPayment))")
                                            .font(CustomFonts.PoppinsSemiBold(size: 36))
                                            .foregroundColor(.black)
                                    }
                                    
                                    // Detalles de comisión, tasa de interés y CAT
                                    VStack(spacing: 4) {
                                        Text("Comisión apertura: \(bank.commission, specifier: "%.2f")%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                        Text("Tasa de interes: \(bank.interestRate, specifier: "%.2f")%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                        Text("CAT: \(bank.cat, specifier: "%.2f")%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)  // Ancho completo con un padding horizontal de 20
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                                .padding(.horizontal, 20)  // Ancho completo con padding
                                
                                // Botón para seleccionar este plan
                                Button(action: {
                                    print("Plan \(bank.bankName) seleccionado")
                                }) {
                                    Text("Choose this plan")
                                        .font(CustomFonts.PoppinsBold(size: 18))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Estilo de paginación
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss cuando se presiona la flecha
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Recommended Banks")
                        .font(CustomFonts.PoppinsSemiBold(size: 18))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct CalculationView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationView()
    }
}
