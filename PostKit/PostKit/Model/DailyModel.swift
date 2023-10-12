//
//  Daily.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

final class DailyModel : ObservableObject{
    let storeName : String?
    let storeTone : String

    @Published var recordID = UUID()
    @Published var recordDate : Date
    @Published var weather : String?
    @Published var dessert : String?
    @Published var drink : String?

    init(_storeName: String?, _storeTone: String, _recordID: UUID = UUID(), _recordDate: Date, _weather: String? = nil, _dessert: String? = nil, _drink: String? = nil) {
        self.storeName = _storeName
        self.storeTone = _storeTone
        self.recordID = _recordID
        self.recordDate = _recordDate
        self.weather = _weather
        self.dessert = _dessert
        self.drink = _drink
    }
}
