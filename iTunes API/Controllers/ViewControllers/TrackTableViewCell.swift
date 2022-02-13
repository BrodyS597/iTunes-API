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
        runTimeLabel.text = formatRunTime(with: track.trackTimeMillis ?? 0)
    }

    // MARK: -Helper func
    func formatRunTime(with milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        if seconds < 10 {
            let secondsString = "0\(seconds)"
            return "\(minutes): \(secondsString)"
        }
        return "\(minutes): \(seconds)"
    }
}
