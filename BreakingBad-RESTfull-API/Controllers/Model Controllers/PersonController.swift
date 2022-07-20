//
//  PersonController.swift
//  BreakingBad-RESTfull-API
//
//  Created by Mitya Kim on 7/19/22.
//

import Foundation
import UIKit


class PersonController {
    
    static let baseURL = URL(string: "https://breakingbadapi.com/api/characters")
    
    static func fetchCharacters(completion: @escaping (Result<[Person], NetworkError>) -> ()) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let persons = try JSONDecoder().decode([Person].self, from: data)
            
                return completion(.success(persons))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchPersonWithName(name: String, completion: @escaping (Result<[Person], NetworkError>) -> ()) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let persons = try JSONDecoder().decode([Person].self, from: data)
                let searchName = persons.filter { person in
                    let firstName = person.name
                    return firstName.hasPrefix(name)
                }
                return completion(.success(searchName))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchCharactersBySeasonAppearance(season: Int, completion: @escaping (Result<[Person], NetworkError>) -> ()) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let persons = try JSONDecoder().decode([Person].self, from: data)
                let searchSeasonPersons = persons.filter { person in
                    guard let seasonsArray = person.appearance else { return false }
                    return seasonsArray.contains(season)
                }
                return completion(.success(searchSeasonPersons))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImageForPerson(person: Person, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        guard let baseURLForImage = URL(string: person.img) else { return completion(.failure(.invalidURL)) }
        URLSession.shared.dataTask(with: baseURLForImage) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Image status code: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            return completion(.success(image))
        }.resume()
    }
}
