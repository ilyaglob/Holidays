//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidayDetailsRoutingLogic {}

protocol HolidayDetailsDataPassing {
    var dataStore: HolidayDetailsDataStore? { get }
}

class HolidayDetailsRouter: NSObject, HolidayDetailsRoutingLogic, HolidayDetailsDataPassing {
    weak var viewController: HolidayDetailsViewController?
    
	var dataStore: HolidayDetailsDataStore?
}
