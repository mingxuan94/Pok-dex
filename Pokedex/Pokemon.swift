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
    let sprites : PokemonSprite
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}
struct PokemonSprite: Codable {
    let front_default: String
}

// A list of pokemons mapped to is_caught
struct PokemonCaught {
    var caught = [String: Bool]()
}


struct PokemonFlavors: Codable {
    let flavor_text_entries: [PokemonFlavorLanguage]
}

struct PokemonFlavorLanguage: Codable {
    let language: Language
    let flavor_text: String
}

struct Language: Codable {
    let name: String
}
