//
//  Car.swift
//  FirebaseDynamicLinkTutorial
//
//  Created by liam on 2023/02/21.
//

import Foundation

struct Car: Codable, Identifiable {
    var id = UUID()
    
    var maker: String
    var name: String
}
