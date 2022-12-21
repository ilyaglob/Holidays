//
//  AppDelegate.swift
//  Holidays
//
//  Created by Илья Разумов on 21.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	private var rootViewController: UINavigationController!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		rootViewController = UINavigationController(nibName: nil, bundle: nil)
		window = UIWindow(frame: UIScreen.main.bounds)
		if #available(iOS 13.0, *) {
			window?.overrideUserInterfaceStyle = .light
		}
		window?.rootViewController = rootViewController
		window?.makeKeyAndVisible()
		
		let holidaysViewController = HolidaysViewController(nibName: nil, bundle: nil)
		rootViewController.setViewControllers([holidaysViewController], animated: false)
		
		return true
	}
}

