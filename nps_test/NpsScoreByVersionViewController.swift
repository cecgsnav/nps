//
//  ViewController.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/9/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class NpsScoreByVersionViewController: UIViewController {
    
    @IBOutlet weak var versionListXMSegmentedControl: XMSegmentedControl!
    
    @IBOutlet weak var npsScoreTitleLabel: UILabel!
    @IBOutlet weak var freemiumNumLabel: UILabel!
    @IBOutlet weak var premiumNumLabel: UILabel!
    @IBOutlet weak var freemiumProportionLabel: UILabel!
    @IBOutlet weak var premiumProportionLabel: UILabel!
    
    let viewModel = NpsScoresByVersionViewModel()

    let activityMonitor = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionListXMSegmentedControl.delegate = self
        versionListXMSegmentedControl.font = FontBuilder.getGothamMedium(size: 12)
        versionListXMSegmentedControl.layer.borderColor = UIColor.lightGray.cgColor
        
        npsScoreTitleLabel.setTextSpacingBy(value: 5)
        
        viewModel.versionList.producer.on(value: { (versionList) in
            self.versionListXMSegmentedControl.segmentTitle = versionList
        }).observe(on: UIScheduler()).start()
        
        viewModel.selectedVersionFreemiumScore.signal.observeValues { (freemiumScore) in
            self.freemiumNumLabel.text = freemiumScore.score.description
            self.freemiumNumLabel.textColor = freemiumScore.color
            self.freemiumProportionLabel.text = "Out of \(freemiumScore.usersInPlan) users"
        }
        
        viewModel.selectedVersionPremiumScore.signal.observeValues { (premiumScore) in
            self.premiumNumLabel.text = premiumScore.score.description
            self.premiumNumLabel.textColor = premiumScore.color
            self.premiumProportionLabel.text = "Out of \(premiumScore.usersInPlan) users"
        }
        
        viewModel.requestNpsList(completion: {
            DispatchQueue.main.async {
                self.activityMonitor.stopAnimating()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLoading()
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  20.0, height: 20.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
    }
    
    // - MARK: Loading
    
    func showLoading() {
        // Init UIActivityIndicatorView
        activityMonitor.frame = UIScreen.main.bounds//CGRect(x: 0, y: 0, width: 40, height: 40)
        activityMonitor.center = view.center
        activityMonitor.hidesWhenStopped = true
        activityMonitor.style = .whiteLarge
        activityMonitor.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(activityMonitor)
        activityMonitor.startAnimating()
    }

}

// - MARK: XM Segmented Control delegate

extension NpsScoreByVersionViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        viewModel.selectedVersion = xmSegmentedControl.segmentTitle[selectedSegment]
    }
}

