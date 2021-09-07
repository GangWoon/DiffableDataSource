# Refactoring
Custom Redux 패턴을 사용해서 DiffableDataSource를 리펙토링했습니다.
<br>
View와 Business Logic이 밀접한 관계를 느슨하게 개선했습니다.
<br>
또한 이곳저곳 분산되어있던 로직을 한곳에서 처리하도록 구현했습니다.
<br>
실시간 UITest를 통해서 View를 만드는 시간을 단축했습니다.
<br>
<br>

### Issue
- Memory Issue


[[issue](https://github.com/GangWoon/DiffableDataSource/issues/4)] closure injection 과정에서 발생하 해제되지 않는 문제를 발견해서 구조를 개선으로 해결했습니다. 

<br>

###  정리 글
[Custom Redux](https://gangwoon.tistory.com/23) , [Testable Reducer](https://gangwoon.tistory.com/25?category=787046), [UITest](https://gangwoon.tistory.com/24?category=787046)

<br>

### 화면
![KakaoTalk_Photo_2021-09-07-01-51-16](https://user-images.githubusercontent.com/48466830/132246766-8e41219f-37a2-40c8-a877-c292e5bc04ae.gif)

![KakaoTalk_Photo_2021-09-08-01-37-51](https://user-images.githubusercontent.com/48466830/132380713-eeccf918-b75e-4a15-8996-dd5e6af63f84.gif)

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

