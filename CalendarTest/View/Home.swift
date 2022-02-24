//
//  CalendarView.swift
//  CalendarTest
//
//  Created by 김나연 on 2022/02/23.
//

import SwiftUI

struct Home: View {
    @State var currentDate: Date = Date()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomDatePicker(currentDate: $currentDate)
                    .navigationBarHidden(true)
            }
        }
//        View().onTapGesture(perform: {
//            ExampleModalView(date: date).presentation(ExampleModal())
//        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
