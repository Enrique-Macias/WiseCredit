//
//  CalculationView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI
import UIKit

struct CalculationView: View {
    @Environment(\.presentationMode) var presentationMode  // Para manejar el dismiss
    @ObservedObject var bankViewModel = BankViewModel()
    @State private var isShowingShareSheet = false
    @State private var pdfURL: URL?
    
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
                                    
                                    // Botón para compartir el PDF
                                    Button(action: {
                                        print("Plan \(bank.name) seleccionado")
                                        generateAndSharePDF(bank: bank, cat: cat, pagoMensual: pagoMensual, tasaInteresAjustada: tasaInteresAjustada, comisionApertura: comisionApertura)
                                    }) {
                                        Text("Share PDF")
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
            // Presentar el share sheet
            .sheet(isPresented: $isShowingShareSheet) {
                if let pdfURL = pdfURL {
                    ActivityView(activityItems: [pdfURL])
                } else {
                    Text("No PDF available")
                }
            }
        }
    }
    
    // Función para calcular la amortización
    func calcularAmortizacion(monto: Double, plazo: Int, tasaInteres: Double) -> [AmortizacionRow] {
        let interesMensual = tasaInteres / 100 / 12
        let pagoMensual = calcularPagoMensual(monto: monto, plazo: plazo, tasaInteres: tasaInteres)
        var saldo = monto
        var amortizacion: [AmortizacionRow] = []
        
        let today = Date()
        let calendar = Calendar.current
        
        for i in 1...plazo {
            let interes = saldo * interesMensual
            let capital = pagoMensual - interes
            saldo -= capital
            
            // Calcular la fecha de pago
            if let fechaPago = calendar.date(byAdding: .month, value: i, to: today) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let fechaPagoStr = dateFormatter.string(from: fechaPago)
                
                amortizacion.append(AmortizacionRow(pago: i, montoPagar: pagoMensual, saldoRestante: max(saldo, 0), fechaPago: fechaPagoStr))
            }
        }
        
        return amortizacion
    }
    
    // Modelo para una fila de la tabla de amortización
    struct AmortizacionRow {
        let pago: Int
        let montoPagar: Double
        let saldoRestante: Double
        let fechaPago: String
    }
    
    // Función para generar y compartir el PDF
    func generateAndSharePDF(bank: Bank, cat: Double, pagoMensual: Double, tasaInteresAjustada: Double, comisionApertura: Double) {
        // Calcular la tabla de amortización
        let amortizacion = calcularAmortizacion(monto: loanAmount, plazo: selectedMonths, tasaInteres: tasaInteresAjustada)
        
        // Configurar el renderer de PDF
        let format = UIGraphicsPDFRendererFormat()
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792) // Tamaño estándar de página A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Estilos de texto
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 24)]
            let headerAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18)]
            let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
            
            var yPosition: CGFloat = 20
            
            // Título
            let title = "Loan Details - \(bank.name)"
            title.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 40
            
            // Información del préstamo
            let loanInfo = """
            Loan Amount: $\(String(format: "%.2f", loanAmount))
            Monthly Payment: $\(String(format: "%.2f", pagoMensual))
            Total Amount to Pay: $\(String(format: "%.2f", pagoMensual * Double(selectedMonths)))
            Adjusted Interest Rate: \(String(format: "%.2f", tasaInteresAjustada))%
            Opening Commission: \(String(format: "%.2f", comisionApertura))%
            CAT: \(String(format: "%.2f", cat))%
            """
            loanInfo.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: regularAttributes)
            yPosition += 120
            
            // Título de la tabla de amortización
            let tableTitle = "Amortization Schedule"
            tableTitle.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: headerAttributes)
            yPosition += 30
            
            // Encabezados de la tabla
            let tableHeaders = "Payment | Amount Due | Remaining Balance | Payment Date"
            tableHeaders.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: regularAttributes)
            yPosition += 20
            
            // Dibujar una línea debajo de los encabezados
            context.cgContext.move(to: CGPoint(x: 20, y: yPosition))
            context.cgContext.addLine(to: CGPoint(x: pageBounds.width - 20, y: yPosition))
            context.cgContext.strokePath()
            yPosition += 10
            
            // Contenido de la tabla
            for row in amortizacion {
                let rowText = "\(row.pago) | $\(String(format: "%.2f", row.montoPagar)) | $\(String(format: "%.2f", row.saldoRestante)) | \(row.fechaPago)"
                rowText.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: regularAttributes)
                yPosition += 20
                
                // Verificar si es necesario crear una nueva página
                if yPosition > pageBounds.height - 50 {
                    context.beginPage()
                    yPosition = 20
                }
            }
        }
        
        // Guardar el PDF en un archivo temporal
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("LoanDetails_\(bank.name).pdf")
        
        do {
            try data.write(to: tempURL)
            
            // Establecer la URL y mostrar el share sheet
            self.pdfURL = tempURL
            self.isShowingShareSheet = true
        } catch {
            print("Error al escribir el PDF: \(error)")
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
