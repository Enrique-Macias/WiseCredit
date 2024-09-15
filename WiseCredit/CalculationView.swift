//
//  CalculationView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct CalculationView: View {
    @Environment(\.presentationMode) var presentationMode  // Para manejar el dismiss
    @ObservedObject var bankViewModel = BankViewModel()

    var loanAmount: Double  // Monto ingresado por el usuario
    var selectedMonths: Int  // Meses seleccionados
    var score: Double  // Score ingresado por el usuario

    // Propiedad computada para calcular el CAT y ordenar los bancos
    var sortedBanks: [(bank: Bank, cat: Double, pagoMensual: Double, tasaInteresAjustada: Double, comisionApertura: Double)] {
        let banksWithCAT = bankViewModel.banks.map { bank -> (bank: Bank, cat: Double, pagoMensual: Double, tasaInteresAjustada: Double, comisionApertura: Double) in
            // Limpiar y convertir las tasas y comisiones
            let tasaInteresBase = Double(bank.tasaInteres.replacingOccurrences(of: "%", with: "")) ?? 0.0
            let comisionApertura = Double(bank.comisionApertura.replacingOccurrences(of: "%", with: "")) ?? 0.0
            
            // Calcular tasa de interés ajustada
            let tasaInteresAjustada = ajustarTasaPorScore(tasaBase: tasaInteresBase, score: score)
            
            // Calcular pago mensual
            let pagoMensual = calcularPagoMensual(monto: loanAmount, plazo: selectedMonths, tasaInteres: tasaInteresAjustada)
            
            // Crear array de pagos
            let pagos = Array(repeating: pagoMensual, count: selectedMonths)
            
            // Calcular CAT
            let cat = calcularCAT(monto: loanAmount, plazo: selectedMonths, pagos: pagos, comisionApertura: comisionApertura)
            
            return (bank: bank, cat: cat, pagoMensual: pagoMensual, tasaInteresAjustada: tasaInteresAjustada, comisionApertura: comisionApertura)
        }
        // Ordenar los bancos por CAT de menor a mayor
        let sortedBanks = banksWithCAT.sorted { $0.cat < $1.cat }
        return sortedBanks
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    if bankViewModel.banks.isEmpty {
                        Text("Cargando bancos...")
                    } else {
                        TabView {
                            ForEach(sortedBanks.prefix(5), id: \.bank.id) { bankWithCAT in
                                let bank = bankWithCAT.bank
                                let cat = bankWithCAT.cat
                                let pagoMensual = bankWithCAT.pagoMensual
                                let tasaInteresAjustada = bankWithCAT.tasaInteresAjustada
                                let comisionApertura = bankWithCAT.comisionApertura

                                VStack(spacing: 20) {
                                    // Imagen del banco
                                    if let imageUrl = URL(string: bank.imageUrl) {
                                        AsyncImage(url: imageUrl) { image in
                                            image.resizable()
                                                .scaledToFit()
                                                .frame(width: 300, height: 200)
                                                .padding(.top, 20)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    
                                    // Nombre del banco
                                    Text(bank.name)
                                        .font(CustomFonts.PoppinsSemiBold(size: 24))
                                        .foregroundColor(.black)
                                    
                                    // Mostrar información calculada
                                    VStack(spacing: 20) {
                                        Text("Monthly Payment")
                                            .font(CustomFonts.PoppinsMedium(size: 18))
                                            .foregroundColor(.gray)
                                        Text("$\(String(format: "%.2f", pagoMensual))")
                                            .font(CustomFonts.PoppinsSemiBold(size: 36))
                                            .foregroundColor(.black)
                                        Text("Comisión apertura: \(String(format: "%.2f", comisionApertura))%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                        Text("Tasa de interés ajustada: \(String(format: "%.2f", tasaInteresAjustada))%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                        Text("CAT: \(String(format: "%.2f", cat))%")
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(radius: 5)
                                    .padding(.horizontal, 20)
                                    
                                    // Botón para seleccionar el plan
                                    Button(action: {
                                        print("Plan \(bank.name) seleccionado")
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
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    }
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
            .onAppear {
                bankViewModel.fetchBanks()  // Cargar los bancos cuando la vista aparece
            }
        }
    }
}

struct CalculationView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationView(
            loanAmount: 10000,  // Ejemplo de monto del préstamo
            selectedMonths: 12,  // Ejemplo de meses seleccionados
            score: 650  // Ejemplo de puntaje de crédito
        )
    }
}

