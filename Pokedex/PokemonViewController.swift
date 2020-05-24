//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Ming Xuan on 23/5/20.
//  Copyright © 2020 MX. All rights reserved.
//

import Foundation
import UIKit

//var pokdex = PokemonCaught.init(caught:[ : ])

class PokemonViewCOntroller: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var image: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    var pokemon: Pokemon!
    
    @IBAction func toggleCatch() {
      // gotta catch 'em all!
        
        // Toggled from Catch -> Release
//        if pokdex.caught[nameLabel.text!] == false || pokdex.caught[nameLabel.text!] == nil {
        if UserDefaults.standard.bool(forKey: self.pokemon.name) == false {
            button.setTitle("Release", for: .normal)
//            pokdex.caught[self.pokemon.name] = true
            UserDefaults.standard.set(true, forKey: self.pokemon.name)
        }
//        // Toggled from Release -> Catch
        else {
            button.setTitle("Catch", for: .normal)
//            pokdex.caught[self.pokemon.name] = false
            UserDefaults.standard.set(false, forKey: self.pokemon.name)
        }
        UserDefaults.standard.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        func capitaliseName(text: String) -> String {
               return text.prefix(1).uppercased() + text.dropFirst()
           }
           
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async
                    {
                        self.nameLabel.text = capitaliseName(text: self.pokemon.name)
                        self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                        
                        for typeEntry in pokemonData.types {
                            if typeEntry.slot == 1 {
                                self.type1Label.text = capitaliseName(text: typeEntry.type.name)
                            }
                            else if typeEntry.slot == 2 {
                                self.type2Label.text = capitaliseName(text: typeEntry.type.name)
                            }
                        }
                        
                        // Load Image
                        let pokemonImageUrl = URL(string: pokemonData.sprites.front_default)
                        print(pokemonImageUrl!)
                        guard let i = pokemonImageUrl else {
                            return
                        }
                        URLSession.shared.dataTask(with: i) {(image_data,response,error) in
                            guard let image_data = image_data else {
                                return
                            }
                            do {
                                let pokemonImage = try? Data(contentsOf: pokemonImageUrl!)
                                self.image.image = UIImage(data: pokemonImage!)
                            }
                            
                        }.resume()
                        
                        // To get flavor description of pokemon
                        // E.g URL https://pokeapi.co/api/v2/pokemon-species/25/
                        // Go to URL -> loop through all flavour text entries -> if language.name == 'en', print flavour_text
                        let pokemonUrlDescript = URL(string: "https://pokeapi.co/api/v2/pokemon-species/"+String(pokemonData.id))
                        print(pokemonUrlDescript!)
                        guard let p = pokemonUrlDescript else {
                            return
                        }
                        URLSession.shared.dataTask(with: p) {(data, response, error) in
                            guard let data = data else {
                                return
                            }
                            do {
                                let pokemonFlavorData = try JSONDecoder().decode(PokemonFlavors.self, from: data)
                                DispatchQueue.main.async {
                                    for flavor in pokemonFlavorData.flavor_text_entries {
                                        if flavor.language.name == "en" {
                                            self.descriptionLabel.text = flavor.flavor_text
                                        }
                                    }
                                }
                            }
                            catch let error {
                                print("\(error)")}
                        }.resume()
                                

                        
                }
                
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
        
        if UserDefaults.standard.bool(forKey: self.pokemon.name) == true {
            self.button.setTitle("Release", for: .normal)
        }
        else if UserDefaults.standard.bool(forKey: self.pokemon.name) == false {
            self.button.setTitle("Catch", for: .normal)
        }
        
        }
        
    }

