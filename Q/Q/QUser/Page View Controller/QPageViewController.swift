//
//  QPageViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 1/2/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import UIKit

protocol QPageViewControllerDelegate {
    /// Function that indicates the "START Q" button was pressed
    func didSelectStartQ()
}

class QPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, QStatusViewControllerDelegate {
    
    /// Delegate object to indicate to QUserView of actions in PageViewController view controllers
    /// i.e. selected "START Q" button
    var qPageViewControllerDelegate: QPageViewControllerDelegate?
    
    lazy var views: [UIViewController] = [
        self.fetchViewController(identifier: QPageViewController.viewControllerIdentifiers.startQVC),
        self.fetchViewController(identifier: QPageViewController.viewControllerIdentifiers.nearbyVC)
    ]
    
    private func fetchViewController(identifier: String) -> UIViewController {
        if identifier == QPageViewController.viewControllerIdentifiers.startQVC,
            let qStatusViewController = (storyboard?.instantiateViewController(withIdentifier: identifier) as? QStatusViewController) {
            qStatusViewController.delegate = self
            return qStatusViewController
        } else {
            return (storyboard?.instantiateViewController(withIdentifier: identifier))!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([self.views.first!], direction: .forward, animated: true) { (finished) in
            self.currentViewControllerIndex = 0
        }
    }
    
    var currentViewControllerIndex: Int!
    
    // MARK: UIPageViewControllerDataSource methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.views.firstIndex(of: viewController)! - 1
        
        guard index >= 0 else {
            return nil
        }
        return self.views[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.views.firstIndex(of: viewController)! + 1
        
        guard index < self.views.count else {
            return nil
        }
        return self.views[index]
    }
    
    // MARK: UIPageViewControllerDelegate methods
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.views.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    // MARK: QStatusViewControllerDelegate methods
    
    func didSelectStartQ() {
        qPageViewControllerDelegate?.didSelectStartQ() // delegate chaining
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension QPageViewController {
    
    struct viewControllerIdentifiers {
        static let startQVC: String = "StartQViewController"
        
        static let nearbyVC: String = "NearbyViewController"
    }
    
}
