//
//  QuizTableViewCell.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 20/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import Kingfisher


struct QuizCellData {
    var imageUrl: String?
    var title: String
    var description: String?
    var level: Int
    
    init(imageUrl: String?, title: String, description: String?, level: Int) {
        self.imageUrl = imageUrl
        self.title = title
        self.description = description
        self.level = level
    }
    
}

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
    }
    
    func populate(with data: QuizCellData) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
        if let urlString = data.imageUrl {
            let url = URL(string: urlString)
            self.quizImage.kf.setImage(with: url)
        }
        switch data.level {
        case 1:
            levelLabel.text = "✭"
        case 2:
            levelLabel.text = "✭✭"
        default:
            levelLabel.text = "✭✭✭"
        }
    }
    
}
