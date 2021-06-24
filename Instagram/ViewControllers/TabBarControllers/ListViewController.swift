//
//  ListViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 18/05/21.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UsersProfileTableViewCell.self, forCellReuseIdentifier: UsersProfileTableViewCell.identifier)
        return tv
    }()
    private var data: [UserRealtionship]?
    
    init(model: [UserRealtionship]) {
        super.init(nibName: nil, bundle: nil)
        self.data = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.frame = view.bounds
        tableView.backgroundColor = UIColor.systemBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersProfileTableViewCell.identifier, for: indexPath) as! UsersProfileTableViewCell
        guard let model = self.data?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(model: model)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
