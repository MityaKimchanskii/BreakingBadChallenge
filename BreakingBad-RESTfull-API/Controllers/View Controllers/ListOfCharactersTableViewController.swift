//
//  ListOfCharactersTableViewController.swift
//  BreakingBad-RESTfull-API
//
//  Created by Mitya Kim on 7/19/22.
//

import UIKit

class ListOfCharactersTableViewController: UITableViewController {

    // MARK: - Properties
    var persons: [Person] = []
    var searchName: [String]!
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var listOfPersonsTableView: UITableView!
    
    // MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllCharacters()
        searchBar.delegate = self
    }

    // MARK: - Actions
    @IBAction func filterBySeasonAppearance(_ sender: Any) {
        seasonAppearanceAlertController()
    }
    
    // MARK: - Helper Methods
    func fetchAllCharacters() {
        PersonController.fetchCharacters { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let persons):
                    self?.persons = persons
                    self?.listOfPersonsTableView.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        let person = persons[indexPath.row]
        cell.person = person
        return cell
    }

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsSegue",
           let indexpath = listOfPersonsTableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? DetailsViewController {
            let personDetails = persons[indexpath.row]
            
            PersonController.fetchImageForPerson(person: personDetails) { result in
                DispatchQueue.main.async {
                    destinationVC.nameLabel.text = personDetails.name
                    destinationVC.nicknameLabel.text = personDetails.nickname
                    destinationVC.statusLabel.text = personDetails.status
                    guard let appearance = personDetails.appearance else { return }
                    let stringAppearance = appearance.map { String($0) }.joined(separator: ", ")
                    destinationVC.appearanceLabel.text = stringAppearance
                    destinationVC.occupationLabel.text = personDetails.occupation?.joined(separator: ", ")
                    switch result {
                    case .success(let image):
                        destinationVC.characterImageView.image = image
                    case .failure(let error):
                        destinationVC.characterImageView.image = UIImage(systemName: "photo.on.rectangle")
                        print(error)
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers Methods
    func seasonAppearanceAlertController() {
        let alertController = UIAlertController(title: "Filter Character", message: "Filter Characters By Season Appearance", preferredStyle: .actionSheet)
        let season1Action = UIAlertAction(title: "Season 1", style: .default) { (_) in
            self.fetchByTheSeason(season: 1)
        }
        let season2Action = UIAlertAction(title: "Season 2", style: .default) { (_) in
            self.fetchByTheSeason(season: 2)
        }
        let season3Action = UIAlertAction(title: "Season 3", style: .default) { (_) in
            self.fetchByTheSeason(season: 3)
        }
        let season4Action = UIAlertAction(title: "Season 4", style: .default) { (_) in
            self.fetchByTheSeason(season: 4)
        }
        let season5Action = UIAlertAction(title: "Season 5", style: .default) { (_) in
            self.fetchByTheSeason(season: 5)
        }
        let allSeasonsAction = UIAlertAction(title: "All Seasons", style: .default) { (_) in
            self.fetchAllCharacters()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(season1Action)
        alertController.addAction(season2Action)
        alertController.addAction(season3Action)
        alertController.addAction(season4Action)
        alertController.addAction(season5Action)
        alertController.addAction(allSeasonsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func fetchByTheSeason(season: Int) {
        PersonController.fetchCharactersBySeasonAppearance(season: season) { result in
            switch result {
            case .success(let seasonAppearance):
                DispatchQueue.main.async {
                    self.persons = seasonAppearance
                    self.listOfPersonsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions
extension ListOfCharactersTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == nil ?? "" {
            DispatchQueue.main.async {
                self.fetchAllCharacters()
                self.listOfPersonsTableView.reloadData()
                self.searchBar.text = ""
            }
        } else if let searchName = searchBar.text {
            PersonController.fetchPersonWithName(name: searchName) { result in
                switch result {
                case .success(let searchResultName):
                    DispatchQueue.main.async {
                        self.persons = searchResultName
                        self.listOfPersonsTableView.reloadData()
                        self.searchBar.text = ""
                    }
                case .failure(let error):
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
}


