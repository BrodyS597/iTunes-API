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
    
    //Using this function to avoid images from being reused if the resulting album image string value is null
    override func prepareForReuse() {
        self.image = nil
    }
    
    // MARK: -Cell Funcs
    
    func setConfiguration(with album: Album) {
        fetchImage(for: album)
        var configuration = defaultContentConfiguration()
        configuration.text = "\(album.title)"
        configuration.secondaryText = "Tracks: \(album.trackCount)"
        configuration.imageProperties.maximumSize = CGSize(width: 200, height: 200)
        
        contentConfiguration = configuration
    }
    
    func fetchImage(for album: Album) {
        guard let albumImagePath = album.albumImagePath else { return }
        
        // this capture list "[weak self]" prevents the reference count from being stronger than 1/weak
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
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        guard var configuration = contentConfiguration as? UIListContentConfiguration else { return }
        configuration.image = self.image
        contentConfiguration = configuration
    }
}//End of class
