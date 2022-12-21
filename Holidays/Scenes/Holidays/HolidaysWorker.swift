//  Created by Илья Разумов on 21.12.2022.

import UIKit

class HolidaysWorker {
	func obtainHolidays(year: String, countryCode: String, completion: @escaping (Result<[Holiday], Error>) -> Void) {
		HolidaysRequest(year: year, countryCode: countryCode)
			.dispatch { response in
				let holidays = response.map {
					Holiday(date: $0.date,
							localName: $0.localName,
							name: $0.name,
							fixed: $0.fixed,
							global: $0.global,
							countries: $0.countries ?? [],
							launchYear: $0.launchYear,
							types: $0.types)
				}
				completion(.success(holidays))
			} onFailure: { _, error in
				completion(.failure(error))
			}
	}
}
