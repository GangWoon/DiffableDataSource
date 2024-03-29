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
    var actionListener: AddMemberViewActionListener?
    let updateSubject: PassthroughSubject<String, Never>
    private let theme: Theme
    private var cancellable: AnyCancellable?
    
    //MARK: - Lifecycle
    init(_ theme: Theme = .default) {
        self.theme = theme
        updateSubject = .init()
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
    private func build() {
        buildVStack()
        listenViewState()
    }
    
    private func listenViewState() {
        cancellable = updateSubject
            .sink { [weak self] state in
                self?.selectedTeamLabel.text = state
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
            self?.actionListener?.send(.didChangeTextField(textField.text ?? ""))
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
                    self?.actionListener?.send(.didSelectTeam(index))
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
