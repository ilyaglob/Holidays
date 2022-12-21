//  Created by Илья Разумов on 21.12.2022.

import UIKit

enum HolidayDetails {
    enum Persistence {
        struct Request {}

        struct Response {
			let holiday: Holiday
		}

        struct ViewModel {
			let displayedInfo: String
			let name: String
        }
    }
}
