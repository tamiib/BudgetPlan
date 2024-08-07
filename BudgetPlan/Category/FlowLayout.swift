import SwiftUI

struct FlowLayout: View {
    var categories: [CategoryViewModel]
    @Binding var selectedCategory: CategoryViewModel?
    var spacing: CGFloat = 8

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(categories, id: \.id) { category in
                self.item(for: category)
                    .padding(.horizontal, self.spacing)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height + self.spacing
                        }
                        let result = width
                        if category.id == self.categories.last!.id {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if category.id == self.categories.last!.id {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func item(for category: CategoryViewModel) -> some View {
        VStack {
            Text(category.icon)
            Text(category.name)
        }
        .padding()
        .background(Color("CategoryBg"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.selectedCategory == category ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            self.selectedCategory = category
        }
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return Color.clear
        }
    }
}
