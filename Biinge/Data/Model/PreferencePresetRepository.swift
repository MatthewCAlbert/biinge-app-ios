//
//  PreferencePresetRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

class PreferencePresetRepository {
    
    var coreDataStore: SeederCoreDataStore
    
    var preferencePresets: [PreferencePreset]?
    
    func getPreferencePresets() -> [PreferencePreset] {
        if self.preferencePresets == nil {
            // add data here
            self.preferencePresets = [PreferencePreset]()
        }
        
        return self.preferencePresets!
    }
    
    func add(_ preferencePreset: PreferencePreset) {
        preferencePresets?.append(preferencePreset)
    }

    func update(_ preferencePreset: PreferencePreset) {
        guard let index = preferencePresets?.firstIndex(where: { $0.id == preferencePreset.id }) else { return }
        preferencePresets?[index] = preferencePreset
    }
    
    static let shared = PreferencePresetRepository(SeederCoreDataStore())
    
    private init(_ coreDataStore: SeederCoreDataStore) {
        self.coreDataStore = coreDataStore
    }
    
}
