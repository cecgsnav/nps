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
        versionListXMSegmentedControl.font = FontBuilder.getGothamMediumBold(size: 12)
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
        
        showLoading()
        
        viewModel.requestNpsList(completion: {
            DispatchQueue.main.async {
                self.activityMonitor.stopAnimating()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "NpsDetail":
            let toVC = segue.destination as? NpsDetailForVersionViewController
            toVC?.viewModel = self.viewModel.createNpsScoreDetails()
        default: break
        }
    }
    
    // - MARK: Loading
    
    func showLoading() {
        // Init UIActivityIndicatorView
        activityMonitor.frame = UIScreen.main.bounds
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

