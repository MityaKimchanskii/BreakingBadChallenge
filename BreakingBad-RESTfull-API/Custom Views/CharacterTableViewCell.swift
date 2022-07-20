//
//  CharacterTableViewCell.swift
//  BreakingBad-RESTfull-API
//
//  Created by Mitya Kim on 7/19/22.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var person: Person? {
        didSet {
            updateView()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Helper Methods
    func updateView() {
        guard let person = person else { return }
        nameLabel.text = person.name
        
        PersonController.fetchImageForPerson(person: person) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.characterImageView.image = image
                case .failure(let error):
                    self?.characterImageView.image = UIImage(systemName: "photo.on.rectangle")
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
