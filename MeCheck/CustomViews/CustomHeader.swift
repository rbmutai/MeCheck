//
//  CustomHeader.swift
//  MeCheck
//
//  Created by Robert Mutai on 11/04/2024.
//

import SwiftUI

struct CustomHeader: View {
    @Binding var selectedPeriod: Frequency
    @Binding var date: Date
    @State private var showSheet: Bool = false
    
     var dateLabel: String {
        Calendar.current.isDateInToday(date) && selectedPeriod == .daily ? String(localized: "Today") : Calendar.current.isDateInYesterday(date) && selectedPeriod == .daily ? String(localized: "Yesterday") : Calendar.current.isDateInTomorrow(date) && selectedPeriod == .daily ? String(localized: "Tomorrow") : dateFormatter.string(from: date)
    }
    
    var dateFormatter: DateFormatter  {
        let formatter = DateFormatter()
        if selectedPeriod == .daily {
            formatter.dateFormat =  "MMM dd, YYYY"
        } else if selectedPeriod == .monthly {
            formatter.dateFormat =  "MMMM, YYYY"
        } else if selectedPeriod == .yearly {
            formatter.dateFormat =  "YYYY"
        }
        return formatter
    }
    var body: some View {
        HStack {
            Image("person", bundle: .none)
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(.secondary)
              .padding()
              .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
              .padding()
              .onTapGesture {
                  
              }
            
            Spacer()
            
            Image("first_page", bundle: .none)
              .resizable()
              .frame(width: 16, height: 16)
              .foregroundStyle(.gray)
              .onTapGesture {
                  if let newDate = Calendar.current.date(byAdding: selectedPeriod == .daily ? .day : selectedPeriod == .monthly ? .month : .year , value: -1, to: date) {
                      date = newDate
                  }
              }
            Text(dateLabel)
                .bold()
                .frame(width: 130).font(.IBMSemiBold(size: 16))
                
            Image("last_page", bundle: .none)
              .resizable()
              .frame(width: 16, height: 16)
              .foregroundStyle(.gray)
              .onTapGesture {
                  if let newDate = Calendar.current.date(byAdding: selectedPeriod == .daily ? .day : selectedPeriod == .monthly ? .month : .year , value: 1, to: date) {
                      date = newDate
                  }
            }
            
            Spacer()
            
            Image("calendar_month", bundle: .none)
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(.secondary)
              .padding()
              .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
              .padding()
              .onTapGesture {
                  showSheet = true
              }
            
        }
        .frame(height: 40)
        .sheet(isPresented: $showSheet, content: {
            calendarSection
        })
    }
}
private extension CustomHeader {
    var calendarSection: some View {
        VStack {
            HStack {
                Spacer()
                CloseImage()
                    .onTapGesture {
                        showSheet = false
                    }
            }
            .padding([.top], 16)
            
           
                if #available(iOS 17.0, *) {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .onChange(of: date) { oldValue, newValue in
                        showSheet = false
                    }
                } else {
                    // Fallback on earlier versions
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: date) { _ in
                            showSheet = false
                        }
                }
            }
            .padding()
            .presentationDetents([.medium])
        
        }
}
#Preview {
    CustomHeader(selectedPeriod: .constant(.daily), date: .constant(Date()))
}
