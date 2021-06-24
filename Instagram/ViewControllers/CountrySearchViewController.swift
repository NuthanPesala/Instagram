//
//  CountrySearchViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 14/05/21.
//

import UIKit

struct Country {
    var name: String
    var code: String
}

struct Language {
    var langName: [String]
    var name: String
}

protocol searchDelegate {
    func getCountryName(name: String, code: String)
}

protocol GetLangNameDelegate {
    func getLangName(langName: String, countryName: String)
}
class CountrySearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Select Your Country"
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var countries = [Country]()
    
    var languages = [Language]()
    
    var delegate : searchDelegate? = nil
    
    var isFromLogin: Bool = false
    
    var langdelegate : GetLangNameDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        view.addSubview(label)
        if isFromLogin == false {
        self.getAllCountries()
        }else {
            self.getAllLanguages()
            label.text = "Select Your Language"
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        label.frame = CGRect(x: 20, y: 40, width: view.frame.size.width - 40, height: 30)
        
        tableView.frame = CGRect(x: 20, y: label.frame.size.height + label.frame.origin.y, width: view.frame.size.width - 40, height: view.frame.size.height - 60)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if text == "" {
         self.getAllCountries()
        }else {
            print(countries)
            self.countries = countries.filter({
                $0.name == text.lowercased()
            })
            
            print(countries)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getAllCountries() {
        guard let file = Bundle.main.path(forResource: "country", ofType: "json") else {
            return
        }
        
        URLSession.shared.dataTask(with: URL(fileURLWithPath: file)) { (data, response, error) in
            guard let data = data else {
                return
            }
            do{
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    var country = Country(name: "", code: "")
                    var items = [Country]()
                    for data in jsonData {
                        if let name = data["country"] as? String {
                            country.name = name
                        }
                        if let code = data["callingCode"] as? String {
                            country.code = "(\(code))"
                        }
                        items.append(country)
                        items = items.filter({$0.name != ""})
                        items = items.filter({$0.code != ""})
                    }
                    DispatchQueue.main.async {
                        self.countries = items
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }.resume()
    }

    
    func getAllLanguages() {
        guard let url = URL(string: "https://restcountries.eu/rest/v2/lang/es") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    do {
                        var lang = Language(langName: [String](), name: "")
                        var langData = [Language]()
                        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                            for data in jsonData {
                                if let languages = data["languages"] as? [[String: Any]] {
                                    for language in languages {
                                        if let name = language["name"] as? String {
                                            lang.langName.append(name)
                                        }
                                    }
                                }
                                if let name = data["name"] as? String {
                                    lang.name = name
                                }
                                langData.append(lang)
                            }
                            self.languages = langData
                         
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    catch {
                        print("Failed to parse Json")
                    }
                }
            }
        }.resume()
    }
    

}

extension CountrySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromLogin == false {
            return self.countries.count
        }
        return self.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isFromLogin == false {
        cell.textLabel?.text = countries[indexPath.row].name + " " + countries[indexPath.row].code
        }else {
            cell.textLabel?.text = languages[indexPath.row].langName[0] + "" + "(\(languages[indexPath.row].name))"
        }
        return cell
    }
}

extension CountrySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        if isFromLogin == false {
        delegate?.getCountryName(name: countries[indexPath.row].name, code: countries[indexPath.row].code)
        }else {
            langdelegate?.getLangName(langName: self.languages[indexPath.row].langName[0], countryName: self.languages[indexPath.row].name)
        }
    }
}
