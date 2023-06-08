//
//  CloneApp.swift
//  CloneHouse
//
//  Created by 유정주 on 2023/06/08.
//

import Foundation

struct CloneApp: Hashable {
    let id = UUID()
    
    let title: String
    var iconName: String { title + "Icon" }
    let description: String
    let version: String
    let releaseDate: String
}
