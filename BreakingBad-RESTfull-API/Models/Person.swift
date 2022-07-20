//
//  Character.swift
//  BreakingBad-RESTfull-API
//
//  Created by Mitya Kim on 7/19/22.
//

import Foundation

//struct TopLevelObject: Decodable {
//    let persons: [Person]
//}

struct Person: Decodable {
    
    let img: String
    let name: String
    let occupation: [String]?
    let status: String
    let nickname: String
    let appearance: [Int]?
}

