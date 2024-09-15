//
//  CreditSimulationView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct CreditSimulationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var loanAmount: String = ""  // Campo para ingresar el monto
    @State private var selectedMonths: String = "6 months"  // Opción seleccionada en el dropdown
    @State private var showDropdown = false  // Para mostrar u ocultar el menú desplegable
    @State private var showCalculationView = false  // Controla la presentación de CalculationView
    @State private var score: Double = 300  // Estado para controlar el score

    let monthsOptions = ["6 months", "12 months", "18 months", "24 months", "36 months"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Color de fondo para toda la pantalla
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Tarjeta de crédito
                    Image("prestamo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                        .padding(.top, 10)
                    
                    // Sección de detalles del préstamo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Loan Amount")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.black)
                        
                        // Campo para ingresar el monto
                        HStack {
                            TextField("Enter amount", text: $loanAmount)
                                .keyboardType(.decimalPad)
                                .foregroundStyle(Color.black)
                                .font(CustomFonts.PoppinsBold(size: 44))
                                
                            Text("$")
                                .font(CustomFonts.PoppinsBold(size: 44))
                                .foregroundColor(.black)
                        }
                        
                        Divider()
                            .background(Color.black)
                    }
                    .padding(.horizontal)
                    
                    // Sección para la tasa mensual
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Rate")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.black)
                        
                        // Menú desplegable
                        ZStack {
                            Button(action: {
                                withAnimation {
                                    showDropdown.toggle()
                                }
                            }) {
                                HStack {
                                    Text(selectedMonths)
                                        .font(CustomFonts.PoppinsSemiBold(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                            }
                            
                            if showDropdown {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(monthsOptions, id: \.self) { option in
                                        Button(action: {
                                            self.selectedMonths = option
                                            withAnimation {
                                                self.showDropdown = false
                                            }
                                        }) {
                                            Text(option)
                                                .font(CustomFonts.PoppinsMedium(size: 16))
                                                .foregroundColor(.black)
                                                .padding(.vertical, 6)
                                                .padding(.leading, 20)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                                .padding(.top, 50)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Score Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Score")
                            .font(CustomFonts.PoppinsSemiBold(size: 18))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                        
                        // Barra deslizante de score
                        HStack {
                            Slider(value: $score, in: 300...850)
                                .accentColor(scoreColor(for: score)) // Cambia el color de la barra
                                .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        
                        // Mostrar el valor del score actual
                        Text("Score: \(Int(score))")
                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Botón de calcular
                    Button(action: {
                        showCalculationView = true  // Muestra la vista CalculationView
                    }) {
                        Text("Calculate")
                            .font(CustomFonts.PoppinsBold(size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .fullScreenCover(isPresented: $showCalculationView) {
                        CalculationView(loanAmount: Double(loanAmount) ?? 0.0, selectedMonths: Int(selectedMonths.components(separatedBy: " ")[0]) ?? 6, score: score) 
                    }
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
                        Text("Credit Simulator")
                            .font(CustomFonts.PoppinsMedium(size: 16))
                    }
                }
            }
        }
    }
    
    // Función para definir el color de la barra del score
    func scoreColor(for value: Double) -> Color {
        if value <= 500 {
            return .red
        } else if value <= 700 {
            return .yellow
        } else {
            return .green
        }
    }
}

struct CreditSimulationView_Previews: PreviewProvider {
    static var previews: some View {
        CreditSimulationView()
    }
}
