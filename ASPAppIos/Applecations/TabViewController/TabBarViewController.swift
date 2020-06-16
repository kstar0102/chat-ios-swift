//
//  TabBarViewController.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController , UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        
        var bottomSafeHeight : CGFloat = 0.0

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSafeHeight = (window?.safeAreaInsets.bottom)!
        }
        let item1 = self.tabBar.items![0] as UITabBarItem;
        let item2 = self.tabBar.items![1] as UITabBarItem;
        let item3 = self.tabBar.items![2] as UITabBarItem;
        let item4 = self.tabBar.items![3] as UITabBarItem;
        let item5 = self.tabBar.items![4] as UITabBarItem;

        self.tabBar.tintColor = .red
        
        var topInset = 10
        var bottomInset = 10
        var verticalOffset = -5
        if bottomSafeHeight > 0 {
            topInset = 20
            bottomInset = 0
            verticalOffset = 20
        }

        item1.image = UIImage(named: "notice_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item1.imageInsets = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: CGFloat(bottomInset), right: 0);
        item2.image = UIImage(named: "profile_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item2.imageInsets = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: CGFloat(bottomInset), right: 0);
        item3.image = UIImage(named: "art_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item3.imageInsets = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: CGFloat(bottomInset), right: 0);
        item4.image = UIImage(named: "cart_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item4.imageInsets = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: CGFloat(bottomInset), right: 0);
        item5.image = UIImage(named: "like_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item5.imageInsets = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: CGFloat(bottomInset), right: 0);

        item1.title = "お知らせ";
        item1.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item2.title = "マイページ";
        item2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item3.title = "アートを投稿";
        item3.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item4.title = "カート";
        item4.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));
        item5.title = "お気に入り";
        item5.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(verticalOffset));

        item1.selectedImage = UIImage(named: "notice_bottom_s.png")?.withRenderingMode(.alwaysOriginal);
        item2.selectedImage = UIImage(named: "profile_bottom.png")?.withRenderingMode(.alwaysOriginal);
        item3.selectedImage = UIImage(named: "art_bottom_s.png")?.withRenderingMode(.alwaysOriginal);
        item4.selectedImage = UIImage(named: "cart_bottom_s.png")?.withRenderingMode(.alwaysOriginal);
        item5.selectedImage = UIImage(named: "like_bottom_s.png")?.withRenderingMode(.alwaysOriginal);

        setNeedsStatusBarAppearanceUpdate();
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabitem = tabBarController.selectedIndex;
        let currentNavView :UINavigationController = tabBarController.selectedViewController as! UINavigationController
        currentNavView.popToRootViewController(animated: true)
    }
    
}
