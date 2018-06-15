//
//  DataModel.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/13/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import Foundation

class DataModel {

    // MARK: - properties

    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }

    // MARK: - lifecycle

    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }

    func registerDefaults() {
        let dictionary = ["ChecklistIndex:": -1, "FirstTime": true] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }

    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // MARK: - data manipulating methods
    func sortChecklists() {
        lists.sort { (firstList, secondList) -> Bool in
            return firstList.name.localizedStandardCompare(secondList.name) == .orderedAscending}
    }

    // MARK: - data loading / saving methods

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding item array")
        }
    }

    func loadChecklists() {
        let path = dataFilePath()
        print(path)
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
        sortChecklists()
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
}
