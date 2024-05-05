//
//  NameDay.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation

struct ApiResponse: Decodable {
    let cachetid: String
    let version: String
    let uri: String
    let startdatum: String
    let slutdatum: String
    let dagar: [NameDay]
}

struct NameDay: Decodable, Identifiable {
    var id: String { return datum }
    let datum: String
    let veckodag: String
    let arbetsfri_dag: String?
    let röd_dag: String?
    let vecka: String
    let dag_i_vecka: String?
    let namnsdag: [String]
    let flaggdag: String?

    enum CodingKeys: String, CodingKey {
        case datum, veckodag, arbetsfri_dag = "arbetsfri_dag", röd_dag = "röd_dag", vecka, dag_i_vecka, namnsdag, flaggdag
    }
}
