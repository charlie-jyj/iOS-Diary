## Diary
> 일기 앱 만들기

### 1) 기능
- 일기장 탭을 누르면 일기 리스트 표시
- 즐겨찾기 탭을 누르면 즐겨찾기 한 일기 리스트 표시
- 일기 crud, 즐겨찾기

### 2) 기본 개념
#### (1) UITabBarController

UITabBar?
앱에서 서로 다른 하위 작업, 뷰, 모드 사이의 선택을 할 수 있도록
탭바에 하나 혹은 하나 이상의 버튼을 보여주는 컨트롤

UITabBarItem
탭바를 구성하는 하나 이상의 아이템, 클릭 시 강조되고 액션 동작

UITabBarController
컨테이너 뷰 컨트롤러
다중 선택 인터페이스 관리, UIViewController 를 상속 받는다
선택에 따라 어떤 자식 뷰 컨트롤러를 보여줄 것인지 결정
버튼에 상응하는 뷰 컨트롤러의 루트 뷰 (custom contents + tab bar view)를 보여준다.

Tab bar view?
사용자를 위한 선택 컨트롤러 제공하고 하나 이상의 tab bar item을 가진다

#### (2) UICollectionView
데이터 항목의 정렬된 컬렉션을 관리하고 커스텀한 레이아웃을 사용해 표시하는 객체
Table view 처럼 scroll view 를 상속받고 있고 다양한 레이아웃을 보여줄 때 사용
 
Table view는 리스트만 보여줄 수 있지만
Collection view는 다양한 화면 구현 가능 

UICollectionViewLayout
- 레이아웃 객체 통해 아이템 배치, 시각적 스타일 결정
- cell, supplementary view, bound, decoratation view의 위치 결정
- 시각적 상태를 컬렉션 뷰에 전달

UICollectionViewFlowLayout
- 정렬


1. Flow 레이아웃 객체를 작성하고 컬렉션 뷰에 이를 할당한다 (컬렉션 레이아웃으로 지정한다)
2. 셀의 width, height 를 정한다
3. 필요한 경우 셀들의 좌우 최소 간격, 위아래 최소 간격 설정
4. 섹션에 header 와 footer 가 있다면 크기 지정
5. 레이아웃의 스크롤 방향 설정

2 지정 필수, 지정하지 않으면 0으로 설정되어 화면에 보이지 않게 된다.

-UICollectionViewDataSource
컬렉션 뷰로 보여지는 콘텐츠들을 관리하는 객체

-UICollectionViewDelegate
콘텐츠의 표현, 사용자와의 상호작용과 관련된 것들을 관리하는 객체 

#### (3) Notification Center
등록된 이벤트가 발생하면 이벤트에 대한 액션을 실행한다
애플리케이션 내부에서 발생한 이벤트 메세지가 어디에서 발생했든..
Event 는 post 메서드를 사용해 메세지를 보내고 
post에 대한 observer 를 등록한다.
Observer 를 등록하면 registered 된 상황이 발생하는지 계속 주시하게 되고 발생할 경우 액션을 취한다.

NotificationCenter.default.post
- name : NSNotification.Name(“rawValue”)
- object : the object posting the notification // 전달하고자 하는 객체를 담으면 됨
- userinfo: a user info dictionary with optional information about the notification

NotificationCenter.default.addObserver
- observer: An object to register as an observer //self
-  selector: specifies the message the receiver sends observer to alert it to the notification posting.
Selector specifies must have one and only one argument (an instance of NSNotification)
- name: the name of the notification
- object: the object that sends notifications to the observer. When nil, the Notification Center doesn’t use sender names as criteria for delivery  


### 3) 새롭게 배운 것들

- hugging 과 compression resistance 가 헷갈리는데 
각각 인내심과 자존심으로 이해하기로 했다.
인내심이 낮으면 팍 터져버리고 자존심이 강하면 찌그러지지 않는다.

-textview 의 border 값에 접근하기 위해선, textview.layer

-datetimepicker

datePicker.addTarget 
: associates target object and action method with the control
+ target: event.target object (viewcontroller)
+ action: #selector(method) => event listener 와 같다
+ for: event type

- Action 메서드는 3가지 form 중 하나를 선택해야 한다.
func doSomething (sender, forEvent)
1번째 param은 action method를 call 하는 UI Control

- UITextView 
Delegate 선언을 통해
Textviewdidchange method 구현
일반적인 textfield 는 addtarget으로 eventlistener를 달아준다.

- ui control의 종류에 따라 for 에 들어가는 touch event 의 동작이 달라지는데, 
Button : touchDown, touchUpInside
slider: valueChanged
textField: editingChanged

- editingChanged 이벤트는 키보드 입력으로 활성화되므로 
Date picker 값 변경을 잡아내지 못한다. 
따라서 diatepickervaluedidChange에서 datePicker.sendActions(for: .valueChanged)
하여 이벤트를 trigger 한다.

- 변수를 전달하는 delegate pattern 에서
Delegate protocol 규칙은 vc2 (data를 전달하는) 에서 정한다. (서류 form) => 그 서류를 prop으로 갖는다 (prop name: delegate)
protocol을 vc1 (데이터를 받는)가 채택한다. (Fill out the form)

- UICollectionViewFlowLayout
A layout object that organizes items into a grid with optional header and footer views
Is a subclass of UICollectionViewLayout

- UIScreen.main.bounds.width
Hardward 스크린의 너비 값

- 리스트 내림차순 정렬하기
``` self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })

.orderedAscending
.orderedSame
.orderedDescending
```

- required init?(coder: NSCoder)
커스텀 뷰를 만들 때 꼭 만나게 된다.
Uiview 를 상속받아서 생성자를 사용하려고 할 때 구현해야 하는 생성자 // 여기 까지만 알도록 하자
xib(Xcode interface builder). Storyboard 와 같은 인터페이스 파일은 UI 구성을 xml 형태로 저장,
이 저장 형태를 사용자 화면으로 그대로 가져오기 위해서 deserialization

https://medium.com/@b9d9/required-init-coder-nscoder-%EC%97%90-%EB%8C%80%ED%95%B4%EC%84%9C-b67ddfc628

NSCoder? An abstract class that serves as the basis for objects that enable archiving and distribution of other objects

https://developer.apple.com/documentation/foundation/nscoder

+ concrete subclasses to transfer objects and other values between memory and some other format
+ archiving : storing objects and data on diet
+ distribution: copying objects and data items between different processes or threads
+ concrete subclasses of NSCoder are “coder classes” and instances of these classes are “coder objects” (simply coders)
+ concrete subclass 한다는 것은 abstract 클래스를 extend 하는 것을 말한다.

- UICollectionViewDelegate vs UICollectionViewDelegateFlowLayout
ui collection view delegate : the methods adopted by the object you use to manage user interactions with items in a collection view
ui collection view delegate flow layout : the methods that let you coordinate with a flow layout object to implement “a grid-based layout”

- 열거형 enumeration

If an enumeration has raw values, those values are determined as part of the declaration,
Which means every instance of a particular enumeration case always has the same raw value
Another choice for enumeration cases is to have values associated with the case
These values are determined when you make the instance and they can be different for each instance
=> associated values as behaving like stored properties

- userdefaults
An interface to the users’ default database, where you store key-value pairs persistently across launches of your app

https://developer.apple.com/documentation/foundation/userdefaults

- 프로그램이 뷰 정보를 어떻게 읽을까?

https://dalgonakit.tistory.com/82

Xib (뷰 정보를 담고 있음) = 빌드 => NIB (바이너리) 파일로 컴파일 후
앱의 번들 ( 앱 실행에 사용되는 파일이 저장된 폴더) 에 복사된 후 실행 파일에서 사용

스토리보드: 뷰 정보와, 뷰와 뷰 사이의 관계에 대한 정보를 가지고 있는 파일


-notificationcenter  addobserver 가 된 뷰컨트롤러가 de init 될때
Remove observer 해주어야 함
(Ios9.0+, macOS 10.11 + 은 system cleans up)
https://developer.apple.com/documentation/foundation/notificationcenter/1413994-removeobserver

- notificationcenter는 registered 된 notification을 observe 할 수 있게 해주다보니
부모 자식 관계로 연결되어 있지 않더라도 
Observer 인 객체는 모두 그것을 알고 있으니 변화 상태를 관리하기가 편하다

- stored prop value가 변경 되었을 때에는 view의 reload 가 필요하지 않는지 검사하자
일기 수정후 컬렉션 뷰의 값이 바뀌지 않아서 열받았는데 
Collecitonview.reloadData 안 해서 그런 것이었네

- UIImage(systemname:)
시스템에 기본적으로 사용되는 이미지를 사용할 수 있다

+ userdefaults.standard
+ notificationCenter.default

- 수정하면서 즐겨찾기가 해제되는 문제 발생 => switch 문에서 처리한다. 

- index out of range 문제 해결하기
=> uuid 설정하기

self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }

UUID().uuidString







