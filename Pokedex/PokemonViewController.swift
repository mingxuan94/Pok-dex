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
                                self.type1Label.text = typeEntry.type.name
                            }
                            else if typeEntry.slot == 2 {
                                self.type2Label.text = typeEntry.type.name
                            }
                        }
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

