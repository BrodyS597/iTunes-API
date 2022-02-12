//
//  AlbumListTableViewController.swift
//  iTunes API
//
//  Created by Brody Sears on 2/11/22.
//

import UIKit

class AlbumListTableViewController: UITableViewController {
    
    // MARK: -IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: -Properties
    var albums: [Albums] = []
    var albumDetails: [AlbumDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        let album = albums[indexPath.row]
        cell.setConfiguration(with: album)
        
        return cell
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         if segue.identifier == "toDetailVC" {
             if let destination = segue.destination as? AlbumDetailsViewController {
                 
                 guard let indexPath = tableView.indexPathForSelectedRow else { return }
                 
                 let albumToSend = albumDetails[indexPath.row]
                 NetworkController.fetchAlbumDetails(with: albumToSend.albumID) { result in
                     switch result {
                     case .success(let albumDetails):
                         DispatchQueue.main.async {
                             destination.albumData = albumDetails
                         }
                     case .failure(let error):
                         print("There was an error!, \(error.errorDescription!)")
                     }
                 }
             }
         }
     }
     
    
}

extension AlbumListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else {
            print("No text entered.")
            return
        }
        
        NetworkController.fetchAlbumWith(searchTerm: searchTerm) { result in
            switch result {
            case .success(let album):
                self.albums = album.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchBar.resignFirstResponder()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
}
