//
//  AlbumTableViewCell.swift
//  iTunes API
//
//  Created by Brody Sears on 2/11/22.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    // MARK: -Properties
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func prepareForReuse() {
        self.image = nil
    }
    
    // MARK: -Cell Funcs
    
    func setConfiguration(with album: Albums) {
        fetchImage(for: album)
        var configuration = defaultContentConfiguration()
        configuration.text = "\(album.title)"
        configuration.secondaryText = "Tracks: \(album.trackCount)"
        configuration.imageProperties.maximumSize = CGSize(width: 200, height: 200)
        contentConfiguration = configuration
    }
    
    func fetchImage(for album: Albums) {
        guard let albumImagePath = album.albumImagePath else { return }
        
        NetworkController.fetchAlbumImage(with: albumImagePath) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure(let error):
                print("There was an error", error.localizedDescription)
            }
        }
    }//end of fetch function
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        guard var configuration = contentConfiguration as? UIListContentConfiguration else { return }
        configuration.image = self.image
        contentConfiguration = configuration
    }
    
}//End of class
