//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidaysBusinessLogic {
	func getHolidays()
	func decrementeYearOffsetAndLoad()
	func obtainConcreteHoliday(with name: String, year: String)
}

protocol HolidaysDataStore {}

class HolidaysInteractor: HolidaysBusinessLogic, HolidaysDataStore {
	struct HolidayOfYear {
		let year: String
		let holidays: [Holiday]
	}
	
	private struct Constants {
		static let defaultCode: String = "AT"
		static let currentYear: String = "\(Calendar.current.component(.year, from: Date()))"
	}
	
    var presenter: HolidaysPresentationLogic?
    var worker: HolidaysWorker?
	
	private var yearOffset: Int = 0
	private var holidays: [HolidayOfYear] = []
	private var year: String = Constants.currentYear
	
	private var countryCode: String {
		(Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? Constants.defaultCode
	}
	
	func decrementeYearOffsetAndLoad() {
		yearOffset -= 1
		guard let newYearDate = Calendar.current.date(byAdding: .year, value: yearOffset, to: Date()) else {
			return
		}
		let newYear = "\(Calendar.current.component(.year, from: newYearDate))"
		year = newYear
		
		getHolidays()
	}

    func getHolidays() {
        worker = HolidaysWorker()
		worker?.obtainHolidays(year: year, countryCode: countryCode) { [weak self] result in
			switch result {
			case .success(let holidays):
				let sentYear = self?.year ?? Constants.currentYear
				self?.holidays.append(HolidayOfYear(year: sentYear, holidays: holidays))
				self?.presenter?.handleObtainedResponse(.init(holidayNames: holidays.map { $0.localName ?? "" }, sentYear: sentYear))
			case .failure(let error):
				self?.presenter?.handleError(error.localizedDescription)
			}
		}
    }
	
	func obtainConcreteHoliday(with name: String, year: String) {
		let holiday = holidays
			.first(where: { $0.year == year })?
			.holidays
			.first(where: { $0.name == name })
		presenter?.handleObtainedHoliday(holiday: holiday)
	}
}
