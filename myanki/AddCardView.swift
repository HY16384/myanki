//
//  AddCardView.swift
//  myanki
//
//  Created by 劉明正 on 2024/06/11.
//

import SwiftUI

struct AddCardView: View {
    @ObservedObject var viewModel: FolderViewModel
    @State private var question = ""
    @State private var answer = ""
    @State private var importMethod = "Individual"
    @State private var csvText = ""
    @State private var lineSeparator = "\n"
    @State private var fieldSeparator = ","
    @State private var swapQA = false
    @State private var showingCSVConfirmation = false
    let folder: Folder
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                // Pickerを追加
                Section {
                    Picker("Import Method", selection: $importMethod) {
                        Text("Individual").tag("Individual")
                        Text("CSV").tag("CSV")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Pickerの選択に応じたフォームを表示
                if importMethod == "Individual" {
                    Section(header: Text("Add New Card")) {
                        TextField("Question", text: $question)
                        TextField("Answer", text: $answer)
                    }
                    .navigationBarItems(trailing: Button("Add Card") {
                        viewModel.addCard(to: folder, question: question, answer: answer)
                        presentationMode.wrappedValue.dismiss()
                    })
                } else if importMethod == "CSV" {
                    Section(header: Text("Paste CSV Data")) {
                        TextEditor(text: $csvText)
                            .frame(height: 150) // 高さを指定
                    }
                    Section(header: Text("Line Separator")) {
                        TextField("Line Separator", text: $lineSeparator)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical)
                    }
                    Section(header: Text("Field Separator")) {
                        TextField("Field Separator", text: $fieldSeparator)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical)
                    }
                    Section(header: Text("Swap Q and A")) {
                        Toggle("Swap Q and A", isOn: $swapQA)
                    }
                    .navigationBarItems(trailing: NavigationLink(destination: CSVConfirmationView(viewModel: viewModel, folder: folder, csvText: $csvText, lineSeparator: $lineSeparator, fieldSeparator: $fieldSeparator, swapQA: $swapQA)) {
                        Text("Next")
                            .foregroundColor(.blue)
                    })
                }
            }
            .navigationTitle("Add New Card")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
