//
//  HomeView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // Usamos el viewModel para obtener el nombre
    @State private var notificationCount: Int = 2  // Número de notificaciones
    @State private var balance: Double = 13553.00  // Ejemplo de balance
    @State private var transactionHistory: [Transaction] = [
        Transaction(category: "Food", amount: -40.99, type: .payment),
        Transaction(category: "AI-Bank", amount: 460.00, type: .deposit)
    ]
    @State private var selectedTimeRange: TimeRange = .oneDay // Valor por defecto para el rango de tiempo seleccionado

    var body: some View {
        NavigationView {
            ZStack {
                // Color de fondo para toda la pantalla
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Divider debajo del texto de bienvenida y el botón de notificaciones
                    Divider()  // Color del divider
                        .padding(.top, -0.2)
                    // Ajuste para acercar el divider al toolbar
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Balance Section alineado a la izquierda con Balance a la derecha del monto
                        HStack(alignment: .bottom) {
                            Text("$ \(String(format: "%.2f", balance))")
                                .font(CustomFonts.PoppinsSemiBold(size: 32))
                                .foregroundColor(.black)
                            Text("Balance")
                                .font(CustomFonts.PoppinsMedium(size: 16))
                                .foregroundColor(.gray)
                                .padding(.bottom, 6)
                                .padding(.leading, 8)  // Añadir espacio entre el número y "Balance"
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                        
                        // Chart Section con sombra y botones debajo
                        VStack(spacing: 16) {
                            // Gráfica
                            ChartView(selectedTimeRange: $selectedTimeRange)
                                .frame(height: 200)
                                .padding(.horizontal)
                                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 10)  // Agregar sombra
                            
                            // Botones para seleccionar el rango de tiempo (1D, 5D, 1M, etc.)
                            TimeRangeButtons(selectedTimeRange: $selectedTimeRange)
                                .padding(.horizontal)
                        }
                        
                        // Servicios Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Servicios")
                                .font(CustomFonts.PoppinsSemiBold(size: 18))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                // Left: Progress Circle Section (rectángulo vertical)
                                ZStack {
                                    VStack(spacing: 16) {
                                        CircularProgressView(progress: 0.31)  // 31% Progress
                                            .frame(width: 120, height: 120)
                                        
                                        Text("Tokens To Buy\nFor 33%")
                                            .multilineTextAlignment(.center)
                                            .font(CustomFonts.PoppinsMedium(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text("8990TB")
                                            .font(CustomFonts.PoppinsSemiBold(size: 20))
                                            .foregroundColor(.red)
                                    }
                                    .padding()
                                    .frame(height: 260)  // Ajustamos la altura del rectángulo vertical
                                    .background(Color.black)
                                    .cornerRadius(20)
                                }
                                
                                // Right: Two bonus boxes
                                VStack(spacing: 16) {
                                    BonusBoxView(bonusAmount: "$22.42", isRed: true)
                                    BonusBoxView(bonusAmount: "$122.00", isRed: false)
                                }
                                .frame(maxHeight: 260)  // Asegurar que la altura de los dos cuadros sea la misma que el rectángulo
                            }
                            .padding(.horizontal)
                        }
                        
                        // Transaction History Section
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Transactions history")
                                    .font(CustomFonts.PoppinsSemiBold(size: 18))
                                Spacer()
                                Text("Today")
                                    .font(CustomFonts.PoppinsMedium(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            ForEach(transactionHistory) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding(.bottom, 95)  // Añadir un padding extra al final para mejor scroll
                    }
                }
            }
            .toolbar {
                // Elemento de la barra superior - Leading (Texto de bienvenida)
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Welcome,")
                            .font(CustomFonts.PoppinsMedium(size: 16))
                            .foregroundColor(.gray)
                        // Mostrar el nombre del usuario desde AuthViewModel
                        Text("\(authViewModel.userName)!")
                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                            .foregroundColor(.black)
                    }
                }
                
                // Elemento de la barra superior - Trailing (Botón de notificaciones)
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        Button(action: {
                            print("Notificaciones presionadas")
                        }) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                        }
                        
                        // Círculo rojo si hay más de una notificación
                        if notificationCount > 1 {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .offset(x: 8, y: -10)
                        }
                    }
                }
            }
        }
    }
}



// Componente para el círculo de progreso
struct CircularProgressView: View {
    var progress: CGFloat  // El progreso entre 0.0 y 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.2)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: 270.0))  // Inicia desde arriba
            
            Text("\(Int(progress * 100))%")
                .font(CustomFonts.PoppinsSemiBold(size: 24))
                .foregroundColor(.white)
        }
    }
}

// Componente para los bonus boxes
struct BonusBoxView: View {
    var bonusAmount: String
    var isRed: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {  // Ajuste del alineamiento a la izquierda
            Image(systemName: "cube.box.fill")
                .font(.title2)
                .foregroundColor(isRed ? .white : .gray)
            
            Text("Bonus received")
                .font(CustomFonts.PoppinsMedium(size: 16))
                .foregroundColor(isRed ? .white : .gray)
            
            Text(bonusAmount)
                .font(CustomFonts.PoppinsSemiBold(size: 20))
                .foregroundColor(isRed ? .white : .white)
        }
        .padding(.leading, 8)  // Agregar un pequeño padding a la izquierda
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)  // Alinear todo a la izquierda
        .background(isRed ? Color.red : Color.black)
        .cornerRadius(20)
    }
}

// Gráfica de ejemplo usando SwiftUI Charts con valores en ejes X e Y
struct ChartView: View {
    @Binding var selectedTimeRange: TimeRange
    
    var body: some View {
        Chart {
            ForEach(ChartData.getData(for: selectedTimeRange)) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Amount", dataPoint.amount)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(.white)
            }
        }
        .chartXAxis {
            AxisMarks(values: selectedTimeRange.axisValues) {
                AxisValueLabel()
                    .foregroundStyle(.white)  // Cambiar el color de las etiquetas X a blanco
            }
        }
        .chartYAxis {
            AxisMarks(values: [0, 50, 100, 500]) {
                AxisValueLabel()
                    .foregroundStyle(.white)  // Cambiar el color de las etiquetas Y a blanco
            }
        }
        .chartYScale(domain: 0...500)  // Asegura que el eje Y tenga el rango correcto
        .padding()
        .background(Color.black)
        .cornerRadius(20)
        .shadow(radius: 10)  // Agregar sombra a la gráfica
    }
}

// Botones para seleccionar el rango de tiempo
struct TimeRangeButtons: View {
    @Binding var selectedTimeRange: TimeRange
    
    var body: some View {
        HStack {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    selectedTimeRange = range
                }) {
                    Text(range.rawValue)
                        .font(CustomFonts.PoppinsMedium(size: 14))
                        .foregroundColor(selectedTimeRange == range ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedTimeRange == range ? Color.black : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// Estructura de datos de la gráfica con más datos, filtrada por rango de tiempo
struct ChartData: Identifiable {
    let id = UUID()
    let date: String
    let amount: Double
    
    static func getData(for range: TimeRange) -> [ChartData] {
        switch range {
        case .oneDay:
            return sampleData.filter { $0.date == "1D" }
        case .fiveDays:
            return sampleData.filter { ["1D", "2D", "3D", "4D", "5D"].contains($0.date) }
        case .oneMonth:
            return sampleData.filter { ["1M", "15D", "10D", "5D"].contains($0.date) }
        case .threeMonths:
            return sampleData.filter { ["3M", "2M", "1M"].contains($0.date) }
        case .sixMonths:
            return sampleData.filter { ["6M", "3M", "2M", "1M"].contains($0.date) }
        case .oneYear:
            return sampleData
        }
    }
    
    static let sampleData: [ChartData] = [
        ChartData(date: "1D", amount: 50),
        ChartData(date: "2D", amount: 80),
        ChartData(date: "3D", amount: 150),
        ChartData(date: "4D", amount: 200),
        ChartData(date: "5D", amount: 120),
        ChartData(date: "6D", amount: 180),
        ChartData(date: "7D", amount: 220),
        ChartData(date: "10D", amount: 300),
        ChartData(date: "15D", amount: 400),
        ChartData(date: "1M", amount: 350),
        ChartData(date: "2M", amount: 200),
        ChartData(date: "3M", amount: 250),
        ChartData(date: "6M", amount: 100),
        ChartData(date: "1Y", amount: 409)
    ]
}

// Enum para los rangos de tiempo
enum TimeRange: String, CaseIterable {
    case oneDay = "1D"
    case fiveDays = "5D"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    
    var axisValues: [String] {
        switch self {
        case .oneDay:
            return ["1D"]
        case .fiveDays:
            return ["1D", "2D", "3D", "4D", "5D"]
        case .oneMonth:
            return ["5D", "10D", "15D", "1M"]
        case .threeMonths:
            return ["1M", "2M", "3M"]
        case .sixMonths:
            return ["1M", "3M", "6M"]
        case .oneYear:
            return ["1M", "3M", "6M", "1Y"]
        }
    }
}

// Estructura de datos para las transacciones
struct Transaction: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let type: TransactionType
}

enum TransactionType {
    case payment
    case deposit
}

// Vista para cada fila de transacción
struct TransactionRow: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: transaction.type == .payment ? "cart.fill" : "banknote.fill")
                    .font(.title2)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text(transaction.category)
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                Text(transaction.type == .payment ? "Payment" : "Deposit")
                    .font(CustomFonts.PoppinsMedium(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(transaction.amount > 0 ? "+" : "-") $\(String(format: "%.2f", abs(transaction.amount)))")
                .font(CustomFonts.PoppinsSemiBold(size: 16))
                .foregroundColor(transaction.amount > 0 ? .black : .red)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
