//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidayDetailsDisplayLogic: AnyObject {
	func display(viewModel: HolidayDetails.Persistence.ViewModel)
}

class HolidayDetailsViewController: UIViewController {
	
	@IBOutlet private var detailsTextView: UITextView!
	
	var interactor: HolidayDetailsBusinessLogic?
	var router: (NSObjectProtocol & HolidayDetailsRoutingLogic & HolidayDetailsDataPassing)?

	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		interactor?.obtainHolidayDetails()
	}

	private func setup() {
		let viewController = self
		let interactor = HolidayDetailsInteractor()
		let presenter = HolidayDetailsPresenter()
		let router = HolidayDetailsRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
}

// MARK: - HolidayDetailsDisplayLogic

extension HolidayDetailsViewController: HolidayDetailsDisplayLogic {
	func display(viewModel: HolidayDetails.Persistence.ViewModel) {
		navigationItem.title = viewModel.name
		detailsTextView.text = viewModel.displayedInfo
	}
}
