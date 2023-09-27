//
//  TimePickerView.swift
//  simpleHITClock
//
//  Created by 박준영 on 2023/08/09.
//

import UIKit
import SwiftUI


struct TimePickerView: UIViewRepresentable{
    
    
    typealias UIViewType = UIPickerView
    
    var array: Array<Int>
    
    @Binding var minSelected: Int
    
    @Binding var secSelected: Int
    

    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        
        let minLabel = UILabel()
        minLabel.text = "분"
        minLabel.font = UIFont.systemFont(ofSize: 20)
        minLabel.frame = CGRect(x: 120, y: 35.5, width: 30, height: 30)
        
        let secLabel = UILabel()
        secLabel.text = "초"
        secLabel.font = UIFont.systemFont(ofSize: 20)
        secLabel.frame = CGRect(x: 310, y: 35.5, width: 30, height: 30)
        
        picker.addSubview(minLabel)
        picker.addSubview(secLabel)
                
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
        
        var parent: TimePickerView
        
        init(_ parent: TimePickerView) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return parent.array.count
            }
            return parent.array.count
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                parent.minSelected = parent.array[row]
            }else if component == 1{
                parent.secSelected = parent.array[row]
            }
            
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "\(row)"
            }
            else if component == 1{
                return "\(row)"
            }
            return ""
        }
    }
}


extension UIPickerView{
    open override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}
