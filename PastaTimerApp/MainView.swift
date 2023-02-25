//
//  ContentView.swift
//  PastaTimerApp
//
//  Created by 안윤진 on 2023/02/22.
//

import SwiftUI

/*
    어려웠던 점
    1. 타이머: 첫 사용이라 많이 어려웠다.
    2. ObservableObject: 멀티뷰에서 같은 데이터를 다뤄야함> 관성처럼 @AppCoreData를 사용하다가 문득 로컬에 저장할 필요가 없다는 것을 알고 바꿨다.
        이것도 첫 사용.
 EnvironmentViewModel: publisher -> MainView: 인자로 viewModel 전달 -> TimerView: 파스타를 선택했을 때에만 종류에 맞는 시간+타이머뷰 보여줌
    StateObject는 작동 중화면을 다시 그리지 않을 때, ObservedObject는 화면을 다시 그려야할 때 사용한다고 들어서 파스타를 클릭하는 화면(MainView)에는 StateObject를 사용, 클릭한 버튼 인덱스에 따라 타이머를 새로 그려야 하는 TimerView에는 ObservedObject를 사용.
 */
class EnvironmentViewModel : ObservableObject{
    @Published var title: [String] = []
    @Published var time: [Int] = [] //조리시간
    @Published var isClicked: [Bool] = [] //클릭여부
    @Published var backgroundColor: [Color] = []
    @Published var rightIndex: Int = 0
    //클릭여부에 따른 배경색상
    
    init() {
        getData()
    }
    
    func getData() {
        title.append(contentsOf: [" 토마토 \n 파스타"," 알리오 \n 올리오"," 상하이 \n 파스타"])
        time.append(contentsOf: [540,700,600])
        isClicked.append(contentsOf: [false, false, false])
        backgroundColor.append(contentsOf: [Color("greenbutton"), Color("greenbutton"), Color("greenbutton")])
    }
}

struct MainView: View {
    
    @StateObject var viewModel: EnvironmentViewModel = EnvironmentViewModel()
    
    
    var body: some View {
        ZStack {
            
            Color("background")
                .ignoresSafeArea()
            VStack(spacing:50) {
                HStack(spacing:20){
                    ForEach(viewModel.title.indices, id: \.self) { index in
                        Button(action: {
                            //다른 모든 버튼이 선택되지 않았을 때만 참이 되는 변수
                            let allOtherButtonsNotClicked = self.viewModel.isClicked.filter { $0 }.count == 0
                            if allOtherButtonsNotClicked || self.viewModel.isClicked[index] {
                                self.viewModel.isClicked[index].toggle()
                                if self.viewModel.isClicked[index] {
                                    self.viewModel.backgroundColor[index] = Color("pink")
                                    self.viewModel.rightIndex = index
                                } else {
                                    self.viewModel.backgroundColor[index] = Color("greenbutton")
                                }
                            }
                        }, label: {
                            Text("\(self.viewModel.title[index])")
                                .frame(width: 100, height: 100)
                                .background(self.viewModel.backgroundColor[index])
                                .foregroundColor(Color("outline"))
                                .clipShape(Circle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color("outline"), lineWidth: 2)
                                )
                        })
                    }
                }
                Spacer(minLength: 100)
                if !self.viewModel.isClicked[0] && !self.viewModel.isClicked[1] && !self.viewModel.isClicked[2]{
                    Text("파스타를\n선택하세요")
                        .font(.system(size: 50, weight: .regular))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("outline"))
                    Spacer(minLength: 280)
                }
                else{
                    TimerView(viewModel: viewModel)

                }
                
                
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
