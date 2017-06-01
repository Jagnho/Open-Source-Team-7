# 코드 참고사항

### canvas 태그		
- HTML5의 새로운 기능
- 스크립트를 사용하여 그림을 그리는 데에 사용 (그래프, 사진, 애니메이션)

-----------------------------------------------------------------------------------------------
### stats.js - 자바스크립트 퍼포먼스 모니터

보여주는 정보
- FPS: 초당 렌더링 된 프레임 수. 높을수록 좋음
- MS: 한 프레임을 렌더링하는데 걸리는 시간(ms). 낮을수록 좋음
- MEM: 할당된 메모리(MB). (Webkit 기반의 브라우저에서만 돌아감)
		
참고: https://github.com/mrdoob/stats.js/blob/master/README.md

-----------------------------------------------------------------------------------------------		
### HTML5 Canvas에서 애니메이션을 구현하고자 하는 경우

**setInterval() 함수**
- 매개변수로 받은 콜백함수를 주기적으로 호출하는 함수

**setInterval() 함수의 단점**
- 항상 콜백함수를 호출해서(브라우저 최소화, 다른 탭에서 작업 중일때도) 리소스 낭비 초래
- 디스플레이 갱신 전 캔버스를 여러번 고쳐도, 갱신 직전 캔버스를 기준으로 적용하여 프레임 손실 발생

**requestAnimationFrame() 함수**
- setInterval()을 대체하기 위해 W3C에서 만들고있는(2014년 기준) 새 기능
- Candidate Recommendation 상태(아직 표준이 정해지지 않음, 2014년 기준)라서 브라우저별 처리 필요(첫번째 인자)
- 브라우저가 화면을 업데이트 해야하는 경우에만 콜백함수 호출
-> 두번째 인자(element)가 있는 경우, 해당 요소가 화면에 보이지 않으면 애니메이션을 처리하지 않음.

참고: https://stackoverflow.com/questions/7487691/why-does-requestanimationframe-function-accept-an-element-as-an-argument

-----------------------------------------------------------------------------------------------
### 테트리스 조각

shape
- 각 요소는 회전 각도에 따른 조각의 형태를 나타냄 (0, 90, 180, 270)
- 각 요소는 16비트 정수로 4x4 블럭 셋을 나타냄 

예) j.shape[0] = 0x44C0

	1의 위치 = 조각의 형태를 나타냄
 	<<: 비트 쉬프트 연산자

	0100 = 0x4 << 3 = 0x4000
	0100 = 0x4 << 2 = 0x0400
	1100 = 0xC << 1 = 0x00C0
	0000 = 0x0 << 0 = 0x0000
			  ------
   			  0x44C0  <-- 이렇게 조각의 형태를 16비트 정수로 나타낼 수 있음.

-----------------------------------------------------------------------------------------------
### eachblock().. x8000인 이유

	0x8000
	------
	0x8000 = 0x8 << 3 = 1000
	0x0000 = 0x0 << 2 = 0000
	0x0000 = 0x0 << 1 = 0000
	0x0000 = 0x0 << 0 = 0000

	0x8000
	16^3 * 8
	2^(12+3)
	2^15
	1000000000000000

	>> 1 연산을 해보면..

	0x8000 >> 1
	0100000000000000
	2^14
	2^(12+2)
	16^3 * 4
	0x4000

	0x4000
	------
	0x4000 = 0x4 << 3 = 0100
	0x0000 = 0x0 << 2 = 0000
	0x0000 = 0x0 << 1 = 0000
	0x0000 = 0x0 << 0 = 0000

-----------------------------------------------------------------------------------------------
### occupied(), unoccupied()

(x,y) 블록이 점유되어 있는지 확인하는 함수(ex 조각이 떨어질 때, 방향키를 눌렀을 때 호출)

- 0 ~ nx, 0 ~ ny 범위는 테트리스 코트 자체를 의미. -> 경계 밖으로 나가선 안되니까 이동 제한
- getBlock(x,y)은 해당 블록이 점유되어 있는지 확인하고, 점유되어 있으면 해당 블럭을 포함한 조각의 타입을 반환, 아니면 null 반환.
- 따라서 occupied()가 true를 반환하면 공간이 이미 점유되어 해당 위치로 이동할 수 없다는 의미. 

-----------------------------------------------------------------------------------------------
### raondomPiece() - 조각 타입(type)과  생성 위치(x)를 랜덤으로 결정하는 함수
- bag is empty 이면 가방(배열)을 다시 채움
- 각 조각이 bag에 하나씩밖에 없으면 같은 타입의 조각이 연속으로 나오는 경우가 없게 되므로 4개씩 넣어줌

**splice(start, deleteCount, item1, item2, ...)**: 배열에서 요소를 제거, (선택사항 - 그 자리에 새 요소 삽입), 삭제 요소 반환
- start: 제거할 요소의 위치
- deleteCount: 제거할 요소의 수
- item1, item2, ...: 제거한 요소 대신 삽입할 요소 (선택사항)

-----------------------------------------------------------------------------------------------	
### invalidate
- set~ 과 clear~ 함수는 모두 invalidate~ 함수를 호출한다. 
- invalidate~ 는 각 요소의 invalid 값을 true로 만들어, 다시 그리기가 필요하다고 표시하는 것.
- 따라서 프로그램은 변화가 생겼을 때에만 렌더링을 다시 하게된다.	

-----------------------------------------------------------------------------------------------	
### 자바스크립트 논리합 활용

	function documentTitle(theTitle) {
	  theTitle  = theTitle || "Untitled Document";
	}

	위와 같이 처리하면 우선은 앞의 논리 연산을 한다. 
	그렇게 되면 theTitle 이라는 parameter가 있는지 우선 확인하고 있으면 그 값을 전역 변수인 theTitle에 넣는다. 
	만약 parameter가 유효하지 않다면(null 이거나 undefined) "Untitled Document"라는 값을 전역 변수에 넣는다.

참고: http://4urdev.tistory.com/13

-----------------------------------------------------------------------------------------------	
Hello
Create GitHub Pages.



## Welcome to GitHub Pages

You can use the [editor on GitHub](https://github.com/Jagnho/Open-Source-Team-7/edit/master/README.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/Jagnho/Open-Source-Team-7/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
