//
//  AddMemberViewController.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/29.
//

import UIKit
import Combine

final class AddMemberViewController: UIViewController {
    
    // MARK: - Views
    private lazy var selectedTeamLabel: UILabel = {
        let label = UILabel()
        label.font = theme.labelFont
        label.textColor = theme.color.selectedTeam
        
        return label
    }()
    
    // MARK: - Properties
    var dispatch: ((Action) -> Void)?
    private let theme: Theme
    private let scheduler: DispatchQueue
    @Published private var memberName: String
    private var cancellable: AnyCancellable?
    
    //MARK: - Lifecycle
    init(_ theme: Theme = .default, scheduler: DispatchQueue) {
        self.theme = theme
        self.scheduler = scheduler
        memberName = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        
    }
    
    // MARK: - Methods
    func updateView(with state: String) {
        selectedTeamLabel.text = state
    }
    
    private func build() {
        buildVStack()
        cancellable = $memberName
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: scheduler)
            .sink { [weak self] name in
                self?.dispatch?(.didChangeTextField(name))
            }
    }
    
    private func buildVStack() {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillProportionally
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(makeNameHStack())
        vStack.addArrangedSubview(makeTeamHStack())
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
        ])
    }
    
    private func makeNameHStack() -> UIView {
        let hStack = UIStackView()
        hStack.spacing = 16
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = theme.text.name
        label.font = theme.labelFont
        let textField = UITextField()
        let action = UIAction { [weak self] action in
            guard let textField = action.sender as? UITextField else { return }
            self?.memberName = textField.text ?? ""
        }
        textField.delegate = self
        textField.addAction(action, for: .editingChanged)
        textField.placeholder = theme.text.placeholder
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(textField)
        
        return hStack
    }
    
    private func makeTeamHStack() -> UIView {
        let hStack = UIStackView()
        hStack.distribution = .equalCentering
        let teamLabel = UILabel()
        teamLabel.text = theme.text.team
        teamLabel.font = theme.labelFont
        hStack.addArrangedSubview(teamLabel)
        hStack.addArrangedSubview(selectedTeamLabel)
        hStack.addArrangedSubview(makeSelectTeamButton())
        
        return hStack
    }
    
    private func makeSelectTeamButton() -> UIButton {
        let button = UIButton()
        button.setTitle(theme.text.button, for: .normal)
        button.setTitleColor(theme.color.button, for: .normal)
        button.showsMenuAsPrimaryAction = true
        let actions = Team.allCases
            .enumerated()
            .map { index, team in
                UIAction(title: team.description) { [weak self] _ in
                    self?.dispatch?(.didSelectTeam(index))
                }
            }
        let menu = UIMenu(options: .displayInline, children: actions)
        button.menu = menu
        
        return button
    }
}

extension AddMemberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension AddMemberViewController {
    
    struct Theme {
        
        struct Text {
            static let `default` = Self(
                name: "Name",
                team: "Team",
                placeholder: "Input your name.",
                button: "Select"
            )
            let name: String
            let team: String
            let placeholder: String
            let button: String
        }
        
        struct Color {
            static let `default` = Self(
                selectedTeam: .systemOrange,
                button: .systemIndigo
            )
            let selectedTeam: UIColor
            let button: UIColor
        }
        
        static let `default` = Self(
            text: .default,
            color: .default,
            labelFont: .boldSystemFont(ofSize: 17)
        )
        let text: Text
        let color: Color
        let labelFont: UIFont
    }
    
    enum Action {
        case didChangeTextField(String)
        case didSelectTeam(Int)
        case addMember
    }
}

