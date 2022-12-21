//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidayDetailsBusinessLogic {
	func obtainHolidayDetails()
}

protocol HolidayDetailsDataStore {
	var holiday: Holiday? { get set }
}

class HolidayDetailsInteractor: HolidayDetailsBusinessLogic, HolidayDetailsDataStore {
    var presenter: HolidayDetailsPresentationLogic?
    var worker: HolidayDetailsWorker?
	
	var holiday: Holiday?
	
	func obtainHolidayDetails() {
		guard let holiday = holiday else {
			return
		}
		presenter?.handleObtainedHoliday(response: .init(holiday: holiday))
	}
}
