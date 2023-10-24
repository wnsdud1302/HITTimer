//
//  DataManager.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/21.
//

import Foundation
import SwiftData


class DataManager: ObservableObject{
    
    static let shared =  DataManager()
    
    var container: ModelContainer?
    
    var context: ModelContext?
    
    init(){
        do{
            container = try ModelContainer(for: TimerData.self)
            DispatchQueue.main.async {
                self.context = self.container?.mainContext
            }
        } catch {
            print(error.localizedDescription)
        }
        print("initialize datamanger")
    }
    
    func insertData(totaltime: Int, wotime: Int, rstime: Int, sets: Int){
        let new = TimerData(totaltime: totaltime, wotime: wotime, rstime: rstime, sets: sets)
        context?.insert(new)
    }
    
    func deleteData(which data: TimerData){
        context?.delete(data)
    }
}
