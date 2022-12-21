//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidaysRoutingLogic {
	func routeToHolidayDetails(holiday: Holiday)
	func showError(_ message: String)
}

protocol HolidaysDataPassing {
    var dataStore: HolidaysDataStore? { get }
}

class HolidaysRouter: NSObject, HolidaysRoutingLogic, HolidaysDataPassing {
    weak var viewController: HolidaysViewController?
	
    var dataStore: HolidaysDataStore?
	
	func routeToHolidayDetails(holiday: Holiday) {
		let detailsViewController = HolidayDetailsViewController()
		if var dataStore = detailsViewController.router?.dataStore {
			passHolidayToDetails(holiday: holiday, destination: &dataStore)
		}
		viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
	}
	
	func showError(_ message: String) {
		let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default)
		alertController.addAction(okAction)
		viewController?.show(alertController, sender: nil)
	}
}

private extension HolidaysRouter {
	func passHolidayToDetails(holiday: Holiday, destination: inout HolidayDetailsDataStore) {
		destination.holiday = holiday
	}
}
