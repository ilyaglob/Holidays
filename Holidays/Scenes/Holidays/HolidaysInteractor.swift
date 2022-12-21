//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidaysBusinessLogic {
	func getHolidays()
	func decrementeYearOffsetAndLoad()
	func obtainConcreteHoliday(with name: String, date: String)
}

protocol HolidaysDataStore {}

class HolidaysInteractor: HolidaysBusinessLogic, HolidaysDataStore {
	private struct Constants {
		static let defaultCode: String = "AT"
		static let currentYear: String = "\(Calendar.current.component(.year, from: Date()))"
	}
	
    var presenter: HolidaysPresentationLogic?
    var worker: HolidaysWorker?
	
	private var yearOffset: Int = 0
	private var holidays: [Holiday] = []
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
				self?.holidays.append(contentsOf: holidays)
				
				let sentYear = self?.year ?? Constants.currentYear
				let response = Holidays.Persistence.Response(holidayNames: holidays.map { ($0.date, $0.localName ?? "") },
															 sentYear: sentYear)
				self?.presenter?.handleObtainedResponse(response)
			case .failure(let error):
				self?.presenter?.handleError(error.localizedDescription)
			}
		}
    }
	
	func obtainConcreteHoliday(with name: String, date: String) {
		let holiday = holidays
			.first(where: { $0.date == date && $0.localName == name })
		presenter?.handleObtainedHoliday(holiday: holiday)
	}
}
