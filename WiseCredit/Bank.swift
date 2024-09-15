//
//  Bank.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import Foundation

struct Bank: Identifiable, Codable {
    @DocumentID var id: String?  // El ID del documento
    var cat: String
    var comisionApertura: String
    var imageUrl: String
    var name: String
    var tasaInteres: String
}

import FirebaseFirestore

class BankViewModel: ObservableObject {
    @Published var banks: [Bank] = []
    
    func fetchBanks() {
        let db = Firestore.firestore()
        
        db.collection("bancos").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener los bancos: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot {
                    self.banks = snapshot.documents.compactMap { document in
                        try? document.data(as: Bank.self)
                    }
                }
            }
        }
        // Ordenar los bancos por CAT de menor a mayor
        self.banks.sort { (Double($0.cat) ?? 0.0) < (Double($1.cat) ?? 0.0) }
    }
}


func ajustarTasaPorScore(tasaBase: Double, score: Double) -> Double {
    var tasaAjustada = tasaBase
    
    if score >= 720 {
        tasaAjustada = tasaBase  // Excelente
    } else if score >= 690 {
        tasaAjustada = tasaBase * 1.05  // Bueno
    } else if score >= 630 {
        tasaAjustada = tasaBase * 1.10  // Regular
    } else {
        tasaAjustada = tasaBase * 1.15  // Malo
    }
    return tasaAjustada
}

func calcularPagoMensual(monto: Double, plazo: Int, tasaInteres: Double) -> Double {
    let interesMensual = tasaInteres / 100 / 12
    let pagoMensual = (monto * interesMensual) / (1 - pow(1 + interesMensual, -Double(plazo)))
    return pagoMensual
}

func calcularCAT(monto: Double, plazo: Int, pagos: [Double], comisionApertura: Double) -> Double {
    let comision = (comisionApertura / 100) * monto
    var sumaPagosValorPresente = 0.0
    
    for j in 1...plazo {
        sumaPagosValorPresente += pagos[j - 1] / pow(1 + 0.01, Double(j) / 12)
    }
    
    let montoTotalAPagar = sumaPagosValorPresente + comision
    let cat = pow((montoTotalAPagar / monto), (12 / Double(plazo))) - 1
    return cat * 100
}


