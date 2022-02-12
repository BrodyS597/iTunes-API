//
//  TrackTableViewCell.swift
//  iTunes API
//
//  Created by Brody Sears on 2/12/22.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    // MARK: -IBOutlets
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    
    func updateViews(with track: Track) {
        trackTitleLabel.text = track.title
        runTimeLabel.text = formatRunTime(with: track.trackTimeMillis)
    }

    // MARK: -Helper func
    func formatRunTime(with milliseconds: Int) -> String {
        let minutes = milliseconds / 60
        let seconds = milliseconds % 60
        if seconds < 10 {
            let secondsString = "0\(seconds)"
            return "\(minutes): \(secondsString)"
        }
        return "\(minutes): \(seconds)"
    }
}
