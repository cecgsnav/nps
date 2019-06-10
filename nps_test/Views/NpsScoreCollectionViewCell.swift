//
//  NpsScoreCollectionViewCell.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/10/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import UIKit

class NpsScoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scoreImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                scoreImageView.layer.borderWidth = 3
            } else {
                scoreImageView.layer.borderWidth = 0
            }
        }
    }
    
    func configure(with score: Int) {
        scoreImageView.image = UIImage(named: "baby_\(score)")
        scoreLabel.text = score.description
        
        scoreImageView.layer.borderColor = UIColor.white.cgColor
        scoreImageView.layer.masksToBounds = false
        scoreImageView.setRounded()
    }
    
}
