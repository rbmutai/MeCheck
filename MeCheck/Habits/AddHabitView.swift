//
//  AddHabitView.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import SwiftUI
import Combine
struct AddHabitView: View {
    @ObservedObject var viewModel: AddHabitViewModel
    @Binding  var showAddSheet: Bool
    @FocusState private var iconIsFocused: Bool
    let columns = [
            GridItem(.adaptive(minimum: 50))
        ]
    var body: some View {
        VStack {
            HStack {
                CloseImage()
                    .padding()
                    .onTapGesture {
                        showAddSheet = false
                }
                Spacer()
                Text(viewModel.pageTitle)
                    .font(.IBMMedium(size: 16))
                Spacer()
                Text(viewModel.addTitle)
                    .font(.IBMRegular(size: 15))
                    .padding(10)
                    .background(.shadowBackground)
                    .overlay(content: { RoundedRectangle(cornerRadius: 20, style: .circular)
                        .strokeBorder(.lightGrey, lineWidth: 1)}).shadow(color: .shadow, radius: 10)
                    .padding()
                    .onTapGesture {
                        viewModel.saveHabit()
                        
                        if  !viewModel.showAlert {
                            showAddSheet = false
                        }

                    }
                
            }
            
            HStack {
               
                VStack(alignment: .leading) {
                    Text("Icon").font(.IBMMedium(size: 15))
                    
                    EmojiTextField(text: $viewModel.icon, placeholder: "")
                        .focused($iconIsFocused)
                        .onReceive(Just(viewModel.icon), perform: { _ in
                            
                            if viewModel.icon != "" {
                                iconIsFocused = false
                            }
                        })
                        .padding()
                        .frame(width: 40, height: 40)
                        .background(Color(viewModel.backgoundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        
                        
                }.padding([.leading])
                
                VStack(alignment: .leading) {
                    Text("Habit Name")
                        .font(.IBMMedium(size: 15))
                    TextField(
                        "",
                        text: $viewModel.name
                    )
                    .padding()
                    .frame(height: 40)
                    .disableAutocorrection(true)
                    .border(.lightGrey)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                }.padding([.trailing])
                
            }
            
            LazyVGrid(columns: columns, spacing: 10)  {
                ForEach(viewModel.habitTheme) { item in
                    Button {
                        viewModel.updateTheme(selected: item.id)
                    } label: {
                        if item.id == viewModel.selectedIndex {
                            Image( "done", bundle: .none)
                                .font(.headline.weight(.semibold))
                                .frame(width: 35,height: 35)
                                
                        } else {
                            Text("")
                                .frame(width: 35,height: 35)
                        }
                         
                    }.background(Color(item.backgroundColor, bundle: .none))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(4)
                    
                }
                
            }.padding()
            
            VStack(alignment: .leading) {
                Text("Habit Type").font(.IBMMedium(size: 15))
                Picker("Habit Type", selection: $viewModel.isQuit) {
                                Text("Build").tag(false)
                                Text("Quit").tag(true)
                            }
                            .pickerStyle(.segmented)
               
            }.padding()
            
            VStack(alignment: .leading) {
                Text("Habit Goal").font(.IBMMedium(size: 15))
               
                Picker("Habit Goal?", selection: $viewModel.goal) {
                                Text("Daily").tag("Daily")
                                Text("Weekly").tag("Weekly")
                            }
                            .pickerStyle(.segmented)
               
            }.padding()
           
            Spacer()
            
        }.alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel, action: {})
        }
    }
}

#Preview {
    AddHabitView(viewModel: AddHabitViewModel(), showAddSheet: .constant(true))
}
class UIEmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
           return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
    
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.font = .systemFont(ofSize: 30)
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
                
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.text = ""
        }
        
        
    }
}
