//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidayDetailsPresentationLogic {
    func handleObtainedHoliday(response: HolidayDetails.Persistence.Response)
}

class HolidayDetailsPresenter: HolidayDetailsPresentationLogic {
	private struct Constants {
		static let separatorSymbols: String = "\n\n"
	}
	
    weak var viewController: HolidayDetailsDisplayLogic?

	func handleObtainedHoliday(response: HolidayDetails.Persistence.Response) {
		var displayedInfo = response.holiday.date + Constants.separatorSymbols
		displayedInfo += "\(response.holiday.name)\(Constants.separatorSymbols)"
		
		if let launchYear = response.holiday.launchYear, launchYear != .zero {
			displayedInfo += "STARTED AT: \(launchYear)\(Constants.separatorSymbols)"
		}
		
		if response.holiday.fixed || response.holiday.global {
			displayedInfo += "Tags: "
			displayedInfo += response.holiday.fixed ? "|FIXED|" : ""
			displayedInfo += response.holiday.global ? "|GLOBAL|" : ""
			displayedInfo += Constants.separatorSymbols
		}
		
		if !response.holiday.types.isEmpty {
			displayedInfo += "Types: \(response.holiday.types.map { $0.uppercased() }.joined(separator: "|"))"
		}
		
		let viewModel = HolidayDetails.Persistence.ViewModel(displayedInfo: displayedInfo,
															 name: response.holiday.localName ?? "")
		viewController?.display(viewModel: viewModel)
    }
}
