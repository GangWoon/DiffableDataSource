# Refactoring
Custom Redux 패턴을 사용해서 DiffableDataSource를 리펙토링했습니다.
<br>
View와 Business Logic이 밀접한 관계를 느슨하게 개선했습니다.
<br>
또한 이곳저곳 분산되어있던 로직을 한곳에서 처리하도록 구현했습니다.
<br>
실시간 UITest를 통해서 View를 만드는 시간을 단축했습니다..

[Custom Redux](https://gangwoon.tistory.com/23) , [Testable Reducer](https://gangwoon.tistory.com/25?category=787046), [UITest](https://gangwoon.tistory.com/24?category=787046)
### 화면
![KakaoTalk_Photo_2021-09-07-01-51-16](https://user-images.githubusercontent.com/48466830/132246766-8e41219f-37a2-40c8-a877-c292e5bc04ae.gif)

![KakaoTalk_Photo_2021-09-07-01-52-31 001](https://user-images.githubusercontent.com/48466830/132246775-89026824-9d56-4567-a731-f106f0f9ddb9.gif)

![KakaoTalk_Photo_2021-09-07-01-52-31 002](https://user-images.githubusercontent.com/48466830/132246782-684dc89a-8fcc-446c-8c28-5507607e26e6.gif)

<br>
<br>
<br>

--- 
<br>
<br>
<br>

# Origin 
UITableViewDiffableDataSource를 사용해서 TableView 애니메이션을 처리한 예제 코드입니다.

<br>

https://gangwoon.tistory.com/12

![diffable](https://user-images.githubusercontent.com/48466830/91635240-c0f80c00-ea31-11ea-90e6-04c89e4683fd.gif)

![diffableDatasource](https://user-images.githubusercontent.com/48466830/91635238-bdfd1b80-ea31-11ea-8139-7048b70d916d.gif)

