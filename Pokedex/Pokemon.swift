//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ming Xuan on 23/5/20.
//  Copyright © 2020 MX. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

// A list of pokemons mapped to is_caught
struct PokemonCaught {
    var caught = [String: Bool]()
}


