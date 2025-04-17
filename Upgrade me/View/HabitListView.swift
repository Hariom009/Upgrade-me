
import SwiftUI

struct HabitListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showEditHabit = false
    @ObservedObject private var activityManager =  ActivityManager()
    @State private var type: String = ""
    @State private var date = Date()
    @State private var takeToaQuill = false
    
    
   
    
    var body: some View {
        NavigationStack{
            
            // Calendar View
            CalendarView()
                
            
            
            // Here is the List View
                List {
//                    Section(header: Text("Health Tracker")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//                        .textCase(nil)){
//                        //
//                        }
                    Section(header: Text("My Task")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .textCase(nil)) {
                            // your list items here
                            ForEach(activityManager.activities, id: \.id) { activity in
                                //             NavigationLink(destination: HabitViewWDescirption( activity: activity)){
                                //             }
                                
                                //
                                Text(activity.name)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(40)
                                    .background(activity.color.opacity(0.4))
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .padding(.horizontal)
                            }
                            // Here the streak is getting plus
                            //                    .onTapGesture {
                            //                        plusActivity(activityid: activity.id)
                            //                    }
                            .onDelete(perform: removeItems)
                        }
                }
            .scrollContentBackground(.hidden)
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    Spacer()
                }
                ToolbarItem(placement:.bottomBar){
                    Button{
                        showEditHabit =  true
                    }label:{
                        Image(systemName: "plus.rectangle.fill")
                            .font(.custom("", fixedSize: 49))
                                .foregroundColor(.indigo)
                                .fontWeight(.thin)
                    }
                }
            }
            .sheet(isPresented: $showEditHabit){
                EditNewHabit(activitymanager: activityManager)
            }
            
            
            
        }
        .onAppear {
            activityManager.loadActivities()
        }
    }

    
  //  Here is the function for streak add
    
//    func plusActivity(activityid: UUID) {
//        if let index = activityManager.activities.firstIndex(where: { $0.id == activityid }) {
//            let lastUpdated = activityManager.activities[index].lastUpdated
//            if !Calendar.current.isDateInToday(lastUpdated) {
//                activityManager.activities[index].duration += 1
//                activityManager.activities[index].lastUpdated = Date()
//            }
//        }
//    }
//
    func removeItems(at offsets: IndexSet) {
        activityManager.activities.remove(atOffsets: offsets)
    }
}

#Preview {
    HabitListView()
}

