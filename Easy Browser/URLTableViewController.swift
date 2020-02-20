//
//  FicheroPrueba.swift
//  Easy Browser
//
//  Created by Boris Nikolaev Borisov on 20/02/2020.
//  Copyright © 2020 Boris Nikolaev Borisov. All rights reserved.
//

import UIKit

class URLTableViewController: UITableViewController {
    
    var websites = ["apple.com", "hackingwithswift.com", "google.com", "github.com", "stackoverflow.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose website"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Web") as? ViewController {
            vc.selectedURL = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
