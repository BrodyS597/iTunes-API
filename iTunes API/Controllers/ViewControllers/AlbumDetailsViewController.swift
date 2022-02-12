//
//  AlbumDetailsViewController.swift
//  iTunes API
//
//  Created by Brody Sears on 2/12/22.
//

import UIKit

class AlbumDetailsViewController: UIViewController {

    // MARK: -IBOutlets
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTracksTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTracksTableView.delegate = self
        albumTracksTableView.dataSource = self
    }
    
    var tracks: [Track] = []
    var album: Album? {
        didSet {
            NetworkController.fetchAlbumImage(with: album?.albumImagePath ?? "") { result in
                switch result {
                case .success(let albumImage):
                    DispatchQueue.main.async {
                        self.loadViewIfNeeded()
                        self.albumImageView.image = albumImage
                    }
                case .failure(let error):
                    print("There was an error fetching the image, \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateViews() {
        guard let album = album else { return }

        NetworkController.fetchTracks(with: album.albumID) { result in
            switch result {
            case .success(let albumDetails):
                self.tracks = albumDetails.results
                DispatchQueue.main.async {
                    self.albumTracksTableView.reloadData()
                }
            case .failure(let error):
                print("There was an error fetching details, \(error.localizedDescription)")
            }
        }
    }
    
}//End of class

extension AlbumDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracks"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
        let track = tracks[indexPath.row]
        cell.updateViews(with: track)
        return cell
    }
}
