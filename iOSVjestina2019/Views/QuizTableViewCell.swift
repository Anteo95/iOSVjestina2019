//
//  QuizTableViewCell.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 20/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quizImage.layer.cornerRadius = self.quizImage.frame.width / 2
        self.quizImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
