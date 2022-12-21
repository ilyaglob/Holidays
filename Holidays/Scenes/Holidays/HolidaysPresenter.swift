//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidaysPresentationLogic {
	func handleObtainedResponse(_ response: Holidays.Persistence.Response)
	func handleObtainedHoliday(holiday: Holiday?)
	func handleError(_ message: String)
}

class HolidaysPresenter: HolidaysPresentationLogic {
    weak var viewController: HolidaysDisplayLogic?

    func handleObtainedResponse(_ response: Holidays.Persistence.Response) {
		let viewModel = Holidays.Persistence.ViewModel(model: .init(year: response.sentYear, holidays: response.holidayNames))
        viewController?.displayHolidays(viewModel: viewModel)
    }
	
	func handleError(_ message: String) {
		viewController?.displayError(message)
	}
	
	func handleObtainedHoliday(holiday: Holiday?) {
		guard let holiday = holiday else {
			assertionFailure("Holiday should bet set for displaying")
			return
		}
		viewController?.displayConcreteHoliday(holiday)
	}
}
