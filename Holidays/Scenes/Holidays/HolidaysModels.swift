//  Created by Илья Разумов on 21.12.2022.

import UIKit

enum Holidays {
    enum Persistence {
        struct Request {}

        struct Response {
			let holidayNames: [String]
			let sentYear: String
        }

        struct ViewModel {
			struct Displayed {
				let year: String
				let holidays: [String]
			}
			
			let model: Displayed
        }
    }
}
