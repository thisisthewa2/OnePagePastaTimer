# OnePagePastaTimer
파스타의 종류에 따라 익혀야할 시간을 알려주는 파스타 타이머
- 실행 화면

![Simulator Screen Recording - iPhone 14 Pro - 2023-04-06 at 15 58 53](https://user-images.githubusercontent.com/119280160/230296139-97db8f4a-3d78-4e25-b543-dc41d3185285.gif)

'''
import SwiftUI
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
'''
