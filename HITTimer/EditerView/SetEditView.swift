//
//  SetEditView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI

struct SetEditView: View {
    @Binding var sets:Int
    var body: some View {
        HStack(spacing: 0){
            Text("세트수:")
            .font(.system(size: 40))
            Text("\(sets)")
                .font(.system(size: 40))
                .frame(width: 60)
                .padding(.trailing, 60)
            HStack(spacing: 0){
                Button(action: incrementSet){
                    Image(systemName: "plus")
                }
                .frame(width: 40, height: 40)
                                .font(.system(size: 30))
                .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 1,height: 40)
                    .foregroundColor(.white)
                
                Button(action: decrementSet){
                    Image(systemName: "minus")
                }
                .frame(width: 40, height: 40)
                .font(.system(size: 30))
                .foregroundColor(.black)
            }
            .background(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 0.5))

            .cornerRadius(15)
        }
    }
}

extension SetEditView{
    func incrementSet(){
        sets += 1
    }
    func decrementSet(){
        if sets > 1 {
             sets -= 1
        }
    }
}

struct SetEditView_Previews: PreviewProvider {
    static var previews: some View {
        SetEditView(sets: .constant(10))
    }
}
