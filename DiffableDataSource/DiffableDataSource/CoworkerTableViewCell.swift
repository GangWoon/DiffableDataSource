//
//  CoworkerCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by Cloud on 2020/08/24.
//  Copyright © 2020 Cloud. All rights reserved.
//

import UIKit
import SnapKit

final class CoworkerTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "CoworkerCollectionViewCell"
    private var nameLabel: UILabel!
    private var ageLabel: UILabel!
    private var teamLabel: UILabel!
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        configure()
        makeConstriants()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        makeConstriants()
    }
    
    // MARK: - Methods
    func apply(name: String, age: Int, team: String) {
        nameLabel.text = name
        ageLabel.text = String(age)
        teamLabel.text = team
    }
    
    private func configure() {
        configureNameLabel()
        configureAgeLabel()
        configureTeamLabel()
    }
    
    private func configureNameLabel() {
        nameLabel = .init()
        nameLabel.font = .boldSystemFont(ofSize: 20)
        addSubview(nameLabel)
    }
    
    private func configureAgeLabel() {
        ageLabel = .init()
        ageLabel.textColor = .systemGray
        addSubview(ageLabel)
    }
    
    private func configureTeamLabel() {
        teamLabel = .init()
        teamLabel.textColor = .systemGray
        teamLabel
            .setContentHuggingPriority(.defaultHigh,
                                       for: .horizontal)
        addSubview(teamLabel)
    }
    
    private func makeConstriants() {
        makeConstriantsNameLabel()
        makeConstriantsAgeLabel()
        makeConstriantsTeamLabel()
    }
    
    private func makeConstriantsNameLabel() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func makeConstriantsAgeLabel() {
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-12)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(teamLabel.snp.leading).inset(-12)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func makeConstriantsTeamLabel() {
        teamLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-12)
            make.trailing.equalTo(nameLabel.snp.trailing).inset(12)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
