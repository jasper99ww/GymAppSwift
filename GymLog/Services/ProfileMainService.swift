//
//  ProfileService.swift
//  GymLog
//
//  Created by Kacper P on 04/08/2021.
//

import Foundation

struct ProfileMainService {
    func getProfileModel() -> [ProfileModel] {
        let model = [ProfileModel(icon: Icons.accountIcon, labelIcon: LabelsIcons.accountLabel), ProfileModel(icon: Icons.workoutIcon, labelIcon: LabelsIcons.workoutLabel), ProfileModel(icon: Icons.bodyWeightIcon, labelIcon: LabelsIcons.bodyWeightLabel), ProfileModel(icon: Icons.supportIcon, labelIcon: LabelsIcons.supportLabel), ProfileModel(icon: Icons.notificationIcon, labelIcon: LabelsIcons.notificationLabel)]
        return model
    }
}
