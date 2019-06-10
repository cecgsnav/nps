//
//  NpsDetailForVersionViewController.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/10/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import ReactiveCocoa
import ReactiveSwift

class NpsDetailForVersionViewController: UIViewController {
    
    @IBOutlet weak var scoresCollectionView: UICollectionView!
    
    @IBOutlet weak var freemiumUsersNumLabel: UILabel!
    @IBOutlet weak var premiumUsersNumLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    
    var viewModel: NpsDetailsViewModel!
    
    fileprivate var pageSize: CGSize {
        let layout = self.scoresCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        scoresCollectionView.backgroundColor = nil
        
        title = "NPS Detail \(viewModel.version)"
        self.navigationItem.backBarButtonItem?.title = ""
        
        viewModel.selectedScore.signal.observeValues { (selectedScore) in
            self.scoresCollectionView.selectItem(at: IndexPath(row: selectedScore, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            self.freemiumUsersNumLabel.text = self.viewModel.getUserPlanScoreCount(for: .Freemium)
            self.premiumUsersNumLabel.text = self.viewModel.getUserPlanScoreCount(for: .Premium)
            self.updateFlavorText()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.selectedScore.value = 0
    }
    
    private func setupLayout() {
        let layout = scoresCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 100)
    }
    
    private func updateFlavorText() {
        let flavor = viewModel.getFlavorData()
        
        let flavorAttributedText = NSMutableAttributedString(string: "\(flavor.percentage)%", attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.flavorTextPercentageColor,
             NSAttributedString.Key.font: FontBuilder.getGothamMediumBold(size: 18)])
        
        let extraText = NSAttributedString(string: " of users that answered \(viewModel.selectedScore.value) in their NPS score saw ", attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: FontBuilder.getGothamMedium(size: 14)])
        
        let activitiesText = NSAttributedString(string: "\(flavor.activities) activities", attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.flavorTextActivitiesColor,
            NSAttributedString.Key.font: FontBuilder.getGothamMediumBold(size: 18)])
        
        flavorAttributedText.append(extraText)
        flavorAttributedText.append(activitiesText)
        
        extraInfoLabel.attributedText = flavorAttributedText
    }
    
}

// - MARK: Collection View data source and delegate

extension NpsDetailForVersionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCell", for: indexPath) as? NpsScoreCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCell", for: indexPath)
        }
        
        cell.configure(with: indexPath.row)
        cell.backgroundColor = nil
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.scoresCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let currentIndex = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        viewModel.selectedScore.value = currentIndex
    }
    
}
