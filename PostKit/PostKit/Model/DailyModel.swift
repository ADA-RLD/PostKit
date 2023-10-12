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

    @Published var weather : String?
    @Published var dessert : String?
    @Published var drink : String?

    init(_storeName: String? = nil, _storeTone: String, _weather: String? = nil, _dessert: String? = nil, _drink: String? = nil) {
        self.storeName = _storeName
        self.storeTone = _storeTone
        self.weather = _weather
        self.dessert = _dessert
        self.drink = _drink
    }
}
