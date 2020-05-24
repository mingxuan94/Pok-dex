//
//  ViewController.swift
//  Pokedex
//
//  Created by Ming Xuan on 23/5/20.
//  Copyright © 2020 MX. All rights reserved.
//

import UIKit
    
class ViewController: UITableViewController, UISearchBarDelegate {
    
//    let pokemon = [
//        Pokemon(name: "Bulbasaur", number: 1),
//        Pokemon(name: "Ivysaur", number: 2),
//        Pokemon(name: "Venusaur", number: 3)
//    ]
    @IBOutlet var searchBar: UISearchBar!
    
    // Initialise values here
    var pokemon: [Pokemon] = []
    var pokemonSearch: [Pokemon] = []
    
    func capitaliseName(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    // Get the list of Pokemons from API here (Limit 151)
    // Loading page
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.pokemonSearch = self.pokemon
                DispatchQueue.main.async { // Background task to foreground
                     self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    // Has 1 section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Since flat list
    }
    
    // How many rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonSearch.count
//        return pokemon.count
    }
    
    // Connect data to our view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make sure same cell doesnt appear twitce
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        // ? means - If variable is nil, ignore this line
        cell.textLabel?.text = capitaliseName(text: pokemonSearch[indexPath.row].name) // Grab the row element
        return cell
    }
    
    // Go to the next view -> PokemonViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewCOntroller {
                destination.pokemon = pokemonSearch[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchText == "" {
          pokemonSearch = pokemon
          tableView.reloadData()
          return
      }
      
      pokemonSearch.removeAll()
      
      for poke in pokemon {
          
          if poke.name.contains(searchText.lowercased()) {
              pokemonSearch.append(poke)
              tableView.reloadData()
          }
      }
      
      tableView.reloadData()
    }
      
    
}

