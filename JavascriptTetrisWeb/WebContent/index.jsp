<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="domain.User" %>
<%@ page import="service.UserService" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
  <title>Javascript Tetris</title>
  
  <style>
    body      { font-family: Helvetica, sans-serif; }
    #container{ overflow: hidden; display: table; margin: 0 auto; }
    #rank     { float: left; display: table-cell; margin: 1em auto; margin-left: 50px; padding: 1em; background-color: #F8F8F8; }
    #tetris   { float: left; display: table-cell; margin: 1em auto; padding: 1em; border: 4px solid black; border-radius: 10px; background-color: #F8F8F8; }
    #stats    { display: inline-block; vertical-align: top; }
    #canvas   { display: inline-block; vertical-align: top; background: url(sky.jpg); box-shadow: 10px 10px 10px #999; border: 2px solid #333; }
    #menu     { display: inline-block; vertical-align: top; position: relative; }
    #menu p   { margin: 0.5em 0; text-align: center; }
    #menu p a { text-decoration: none; color: black; }
    #upcoming { display: block; margin: 0 auto; background-color: #E0E0E0; }
    #score    { color: red; font-weight: bold; vertical-align: middle; }
    #rows     { color: blue; font-weight: bold; vertical-align: middle; }
    #level    { color: green; font-weight: bold; vertical-align: middle; }
    #stats    { position: absolute; bottom: 0em; right: 1em; }
    @media screen and (min-width:   0px) and (min-height:   0px)  { #tetris { font-size: 0.75em; width: 250px; } #menu { width: 100px; height: 200px; } #upcoming { width:  50px; height:  50px; } #canvas { width: 100px; height: 200px; } } /* 10px chunks */
    @media screen and (min-width: 400px) and (min-height: 400px)  { #tetris { font-size: 1.00em; width: 350px; } #menu { width: 150px; height: 300px; } #upcoming { width:  75px; height:  75px; } #canvas { width: 150px; height: 300px; } } /* 15px chunks */
    @media screen and (min-width: 500px) and (min-height: 500px)  { #tetris { font-size: 1.25em; width: 450px; } #menu { width: 200px; height: 400px; } #upcoming { width: 100px; height: 100px; } #canvas { width: 200px; height: 400px; } } /* 20px chunks */
    @media screen and (min-width: 600px) and (min-height: 600px)  { #tetris { font-size: 1.50em; width: 550px; } #menu { width: 250px; height: 500px; } #upcoming { width: 125px; height: 125px; } #canvas { width: 250px; height: 500px; } } /* 25px chunks */
    @media screen and (min-width: 700px) and (min-height: 700px)  { #tetris { font-size: 1.75em; width: 650px; } #menu { width: 300px; height: 600px; } #upcoming { width: 150px; height: 150px; } #canvas { width: 300px; height: 600px; } } /* 30px chunks */
    @media screen and (min-width: 800px) and (min-height: 800px)  { #tetris { font-size: 2.00em; width: 750px; } #menu { width: 350px; height: 700px; } #upcoming { width: 175px; height: 175px; } #canvas { width: 350px; height: 700px; } } /* 35px chunks */
    @media screen and (min-width: 900px) and (min-height: 900px)  { #tetris { font-size: 2.25em; width: 850px; } #menu { width: 400px; height: 800px; } #upcoming { width: 200px; height: 200px; } #canvas { width: 400px; height: 800px; } } /* 40px chunks */
  	@media screen and (min-width:   0px) and (min-height:   0px)  { .title { font-size: 0.75em; width: 150px; } .contents { font-size: 0.25em; width: 250px; } } /* 10px chunks */
    @media screen and (min-width: 400px) and (min-height: 400px)  { .title { font-size: 1.00em; width: 250px; } .contents { font-size: 0.50em; width: 250px; } } /* 15px chunks */
    @media screen and (min-width: 500px) and (min-height: 500px)  { .title { font-size: 1.25em; width: 350px; } .contents { font-size: 0.75em; width: 250px; } } /* 20px chunks */
    @media screen and (min-width: 600px) and (min-height: 600px)  { .title { font-size: 1.50em; width: 450px; } .contents { font-size: 1.00em; width: 250px; } } /* 25px chunks */
    @media screen and (min-width: 700px) and (min-height: 700px)  { .title { font-size: 1.75em; width: 550px; } .contents { font-size: 1.25em; width: 250px; } } /* 30px chunks */
    @media screen and (min-width: 800px) and (min-height: 800px)  { .title { font-size: 2.00em; width: 650px; } .contents { font-size: 1.50em; width: 250px; } } /* 35px chunks */
    @media screen and (min-width: 900px) and (min-height: 900px)  { .title { font-size: 2.25em; width: 750px; } .contents { font-size: 1.75em; width: 250px; } } /* 40px chunks */
  
   </style>
</head>

<body>
<div id="container">

	<div id="tetris">
	<!--좌측 스테이터스 영역-->
    <div id="menu">
	  <!--space나 a 태그 링크를 누르면 play() 함수 실행과 함께 게임 시작-->
      <p id="start"><a href="javascript:play();">Press Space to Play.</a></p>
	  <!--다음에 나올 조각-->
      <p><canvas id="upcoming"></canvas></p>
	  <!--점수-->
      <p>score <span id="score">00000</span></p>
	  <!--제거한 라인 수-->
      <p>rows <span id="rows">0</span></p>
      <p>level <span id="level">0</span></p>
    </div>
	
	<!--우측 테트리스 코트 영역-->
	<canvas id="canvas">
      Sorry, this example cannot be run because your browser does not support the &lt;canvas&gt; element
    </canvas>
	</div> <!-- //tetris -->
	
	<div id="rank">
	  	<p class="title">My Record</p>
	  	<%
	  	// 세션으로부터 데이터 가져오기
	  		String myName;
	  		Integer myScore;
	  		
	  		if(session.isNew()) {
	  			// 기존 세션이 존재하지 않는 경우
		  		session.setAttribute("sName", "-");
		  		session.setAttribute("sScore", 0);
		  		
		  		myName = (String)session.getAttribute("sName");
		  		myScore = (Integer)session.getAttribute("sScore");
		  		
	  		} else {
	  			myName = (String)session.getAttribute("sName");
	  			myScore = (Integer)session.getAttribute("sScore");
	  		}
	  		
	  		request.setAttribute("myName", myName);
	  		request.setAttribute("myScore", myScore);
	  	%>
	  	<p class="contents">${myName } (${myScore }점)</p><br>
	  	<p class="title">Ranking</p>
		<%
		// DB로부터 데이터 가져오기
			UserService service = new UserService();
		
			List<User> userList = new ArrayList<>();
			userList = service.findAll();
			
			request.setAttribute("users", userList);
		%>
	  	<c:forEach items="${users }" var="user" varStatus="status">
	  		<p class="contents">${status.count }위: ${user.name } (${user.score }점)</p>
	  	</c:forEach>
	  </div> <!-- //rank -->
	
</div> <!-- //container -->
  
  <!--퍼포먼스 모니터-->
  <script src="stats.js"></script>
  
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  
  <script>
	//-------------------------------------------------------------------------
    // Ajax 사용을 위한 세팅 (XMLHttpRequest 객체 생성)
    //-------------------------------------------------------------------------
	
    var xmlhttp; 
    if (window.XMLHttpRequest) { 
        xmlhttp = new XMLHttpRequest();
    } 
    else { 
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
	
    //-------------------------------------------------------------------------
    // 함수 정의(게임 시스템 외)
    //-------------------------------------------------------------------------

    function get(id)        { return document.getElementById(id);  }
    function hide(id)       { get(id).style.visibility = 'hidden'; }
    function show(id)       { get(id).style.visibility = null;     }
    function html(id, html) { get(id).innerHTML = html;            }

    function timestamp()           { return new Date().getTime();                             }
    function random(min, max)      { return (min + (Math.random() * (max - min)));            }
    function randomChoice(choices) { return choices[Math.round(random(0, choices.length-1))]; }

	// requestAnimationFrame() - 애니메이션을 구현하기 위해 콜백함수(frame()) 호출(브라우저가 화면을 업데이트 해야하는 경우에만) 
    if (!window.requestAnimationFrame) { // http://paulirish.com/2011/requestanimationframe-for-smart-animating/
	      window.requestAnimationFrame = window.webkitRequestAnimationFrame ||
										 window.mozRequestAnimationFrame    ||
										 window.oRequestAnimationFrame      ||
										 window.msRequestAnimationFrame     ||
										 function(callback, element) {
											window.setTimeout(callback, 1000 / 60); // setTimeout() - 2번 인자의 시간(ms)이 경과하면 1번 인자의 함수 실행
										}
    }

    //-------------------------------------------------------------------------
    // 게임 상수 
    //-------------------------------------------------------------------------

	var KEY     = { ESC: 27, SPACE: 32, LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40 }, // 방향키로 조작
	//var KEY     = { ESC: 27, SPACE: 32, LEFT: 65, UP: 87, RIGHT: 68, DOWN: 83 },    // LEFT : a / UP : w / RIGHT : s: / DOWN  d
		DIR     = { UP: 0, RIGHT: 1, DOWN: 2, LEFT: 3, MIN: 0, MAX: 3 },
        stats   = new Stats(),
        canvas  = get('canvas'),								// 테트리스 코트
        ctx     = canvas.getContext('2d'),
        ucanvas = get('upcoming'),								// 미리보기 영역
        uctx    = ucanvas.getContext('2d'),
        speed   = { start: 0.6, decrement: 0.005, min: 0.1 },	// 한 칸 내려오는데 걸리는 시간에 관한 변수(단위: 초)
        nx      = 10, 											// 테트리스 코트 가로 길이(단위: 블럭)
        ny      = 20, 											// 테트리스 코트 세로 길이(단위: 블럭)
        nu      = 5;  											// 미리보기 영역 가로, 세로 길이(단위: 블럭)

    //-------------------------------------------------------------------------
    // 게임 변수 (reset() 호출시 초기화)
    //-------------------------------------------------------------------------

    var dx, dy,        // 테트리스 조각을 구성하는 블록(사각형 하나)의 픽셀 사이즈
        blocks,        // 테트리스 코트를 나타내는 2차원 배열(nx*ny)
        actions,       // 플레이어의 조작(입력)이 저장되는 큐
        playing,       // 게임 진행 여부(true|false)
        dt,            // time since starting this game
        current,       // 현재 조각
        next,          // 다음 조각
        score,         // 현재 점수
        vscore,        // 화면에 보여지는 점수(조금 지나면 현재 점수로 갱신)
        rows,          // 제거한 라인 수
        step;          // 조각이 한 칸 내려오는데 걸리는 시간
        level = 1;     // 게임 레벨
        audio = new Audio('Be Higher.mp3'); // 오디오 변수

	// 테트리스 조각 관련 변수 (size: 조각이 기본 방향일 때의 가로 사이즈 / shape: 회전 각도에 따른 조각의 형태를 16진수로 나타낸 것(0, 90, 180, 270))
    //var i = { size: 4, shape: [0x0F00, 0x2222, 0x00F0, 0x4444], color: 'cyan'   };
    //var j = { size: 3, shape: [0x44C0, 0x8E00, 0x6440, 0x0E20], color: 'blue'   };
    //var l = { size: 3, shape: [0x4460, 0x0E80, 0xC440, 0x2E00], color: 'orange' };
    //var o = { size: 2, shape: [0xCC00, 0xCC00, 0xCC00, 0xCC00], color: 'yellow' };
    //var s = { size: 3, shape: [0x06C0, 0x8C40, 0x6C00, 0x4620], color: 'green'  };
    //var t = { size: 3, shape: [0x0E40, 0x4C40, 0x4E00, 0x4640], color: 'purple' };
    //var z = { size: 3, shape: [0x0C60, 0x4C80, 0xC600, 0x2640], color: 'red'    };
    var i = { size: 4, shape: [0x0F00, 0x2222, 0x00F0, 0x4444], color: 'blue'   };
    var j = { size: 3, shape: [0x44C0, 0x8E00, 0x6440, 0x0E20], color: 'green'  };
    var l = { size: 3, shape: [0x4460, 0x0E80, 0xC440, 0x2E00], color: 'pink'	};
    var o = { size: 2, shape: [0xCC00, 0xCC00, 0xCC00, 0xCC00], color: 'green'	};
    var s = { size: 3, shape: [0x06C0, 0x8C40, 0x6C00, 0x4620], color: 'blue' 	};
    var t = { size: 3, shape: [0x0E40, 0x4C40, 0x4E00, 0x4640], color: 'pink'	};
    var z = { size: 3, shape: [0x0C60, 0x4C80, 0xC600, 0x2640], color: 'pink'	};
    var x = { size: 3, shape: [0x4E40, 0x4E40, 0x4E40, 0x4E40], color: 'red'    }; // 십자가 모양 블럭 추가

    //-------------------------------------------------------------------------
    // do the bit manipulation and iterate through each occupied block (x,y) for a given piece
    //-------------------------------------------------------------------------
    
	// eachblock() - 조각의 각 블록을 순회하며, 콜백함수(fn)를 수행하는 함수(type: 조각 타입 / dir: 방향)
    function eachblock(type, x, y, dir, fn) {
	  var bit, 
		  result, 
		  row = 0, 
		  col = 0, 
		  shape = type.shape[dir]; // 조각의 형태를 16비트 정수로 리턴 
	  
      for(bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {	// 4x4 공간에서 각 비트 순회
        if (shape & bit) { 								// 블록 비트와 4x4 공간 비트를 &(비트곱) 연산. 1&1. 즉, 현재 조각이 점유하고 있는 블록만 true
          fn(x + col, y + row); 						// 해당 블록 위치를 인자로 콜백함수 호출 (ex occupied() - 해당 블록 점유 여부 검사, setBlock() - 해당 블록 점유)
        }
        if (++col === 4) {	// 열 증가, 그리고 마지막 열까지 갔으면..
          col = 0; 			// 열 초기화
          ++row;			// 행 증가(다음 행으로)
        }
      }
    }
	
	// occupied(), unoccupied() - (x,y) 블록이 점유되어 있는지 확인하는 함수(ex 조각이 떨어질 때, 방향키를 눌렀을 때 호출)
    function occupied(type, x, y, dir) {
      var result = false;
      eachblock(type, x, y, dir, function(x, y) {
        if ((x < 0) || (x >= nx) || (y < 0) || (y >= ny) || getBlock(x,y)) // (x,y)가 코트 영역 밖이거나, 이미 점유된 블록인경우
          result = true; // 점유 되어있음을 리턴
      });
      return result;
    }
    function unoccupied(type, x, y, dir) {
      return !occupied(type, x, y, dir); // 점유 안 되어있음을 리턴
    }

	// raondomPiece() - 조각 타입(type)과 생성 위치(x)를 랜덤으로 결정하는 함수
    var pieces = [];
    function randomPiece() {
      if (pieces.length == 0)	// 만약 설정한 테트리스 조각이 모두 사용되는 경우에 다시 28개의 랜덤 블록 피스를 생성
        pieces = [i,i,i,i,j,j,j,j,l,l,l,l,o,o,o,o,s,s,s,s,t,t,t,t,z,z,z,z,x,x,x,x]; // 7개의 조각이 각 4개씩 생성
      var type = pieces.splice(random(0, pieces.length-1), 1)[0];  // piece의 타입 결정, splice() - 배열에서 요소를 삭제하면서 그 삭제한 요소를 반환
      return { type: type, dir: DIR.UP, x: Math.round(random(0, nx - type.size)), y: 0 };
    }

    //-------------------------------------------------------------------------
    // GAME LOOP
    //-------------------------------------------------------------------------
      
	// run() - 프로그램 실행 (게임 시작과는 다름)
    //--------------------------------------------------------------------------
    /* 기본적인 Game Loop(게임 동작)을 위한 함수 실행 부분. 안에는 HTML안에서 동적인 요소작동을
    위한 속성할당(showState())과 이벤트 액셜을 위한 함수(addEvents) 호출이 존재한다. */
    //-------------------------------------------------------------------------- 
    function run() {

      showStats(); // 퍼포먼스 모니터 초기화
      addEvents(); // 키보드 이벤트, 리사이즈 이벤트 적용

      var last = now = timestamp();
	  
      function frame() {
        
		now = timestamp(); // 현재 시간
        
		// 레벨에 따른 게임속도 조절기능 1레벨 기준으로 레벨업 할수록 단리 10퍼센트씩 빨라짐
		if (level == 1)			update(Math.min(1, (now - last) / 1000.0)); 
        else if (level == 2)	update(Math.min(1, (now - last) / 900.0));
        else if (level == 3)	update(Math.min(1, (now - last) / 800.0));
        else if (level == 4)	update(Math.min(1, (now - last) / 700.0));
        else if (level == 5)	update(Math.min(1, (now - last) / 600.0));
        else if (level == 6)	update(Math.min(1, (now - last) / 500.0));
        else if (level == 7)	update(Math.min(1, (now - last) / 400.0));
        else if (level == 8)	update(Math.min(1, (now - last) / 300.0));
        else if (level == 9)	update(Math.min(1, (now - last) / 200.0));
        else if (level == 10)	update(Math.min(1, (now - last) / 100.0));
		
		draw();	// 그리기
        stats.update();
        last = now;
        requestAnimationFrame(frame, canvas); // requestAnimationFrame() - 시간이 지나면 콜백함수인 frame()을 호출함으로써(재귀) 애니메이션 구현
        
		if (score > 4500)		level = 10;
        else if (score > 4000)	level = 9;
        else if (score > 3500)	level = 8;
        else if (score > 3000)	level = 7;
        else if (score > 2500)	level = 6;
        else if (score > 2000)	level = 5;
        else if (score > 1500)	level = 4;
        else if (score > 1000)	level = 3;
        else if (score > 500)	level = 2;
      }

      resize(); // 모든 Sizing information을 setup
      reset();	// per-game,게임당 변수를 초기화
      frame();  // start the first frame [ 첫번째 프래임 실행 ]

    }
	
    // HTML요소를 표현하고, 이를 통해 태그 이름이나 자식, 속성 같은 정보에 접근을 가능케 하기 위한 함수
	// showStats() - 퍼포먼스 모니터를 보여주는 함수
	function showStats() {
      stats.domElement.id = 'stats'; // 별도의 stats.js 자바스크립트 파일 존재
      get('menu').appendChild(stats.domElement); // stats 아이디를 가진 속성에 구성될 menu의 동적인 요소 추가
    }

	// addEvents() - 이벤트 리스너 등록
    function addEvents() {
      document.addEventListener('keydown', keydown, false); // 키보드를 눌렀을 때 블록이 내려가는 Keydown 이벤트 등록
      window.addEventListener('resize', resize, false); // 윈도우 resize 이벤트 등록
    }

	// resize() - 각종 크기 정보 갱신
    function resize(event) {
      canvas.width   = canvas.clientWidth;  
      canvas.height  = canvas.clientHeight; 
      // set canvas logical size equal to its physical size [ 테트리스 게임을 진행할 캔버스에 대한 높이,넓이 설정 ]
      
      ucanvas.width  = ucanvas.clientWidth;
      ucanvas.height = ucanvas.clientHeight;
      // 테트리스 게임에 이용 될 테트리스 블록에 대한 높이, 넓이 설정
        
      dx = canvas.width  / nx; // 테트리스 블럭 하나의 픽셀 크기
      dy = canvas.height / ny; // (ditto)
      invalidate();
      invalidateNext();
    }

	// keydown() - 키보드 입력 이벤트 콜백 함수, 각각의 키가 눌러질 때 생기는 액션 정의 ex)왼쪽키를 누르면 왼쪽으로 바뀐다.
    function keydown(ev) {
      var handled = false;
      if (playing) {
        switch(ev.keyCode) {
		// actions.push() - 사용자의 키 조작을 actions[] 배열에 넣어두고, update() 함수에서 하나씩 꺼내어 수행 (사용자의 조작 명령을 빠뜨리지 않고 수행하기 위함)
          case KEY.LEFT:   actions.push(DIR.LEFT);  handled = true; break;
          case KEY.RIGHT:  actions.push(DIR.RIGHT); handled = true; break;
          case KEY.UP:     actions.push(DIR.UP);    handled = true; break;
          case KEY.DOWN:   actions.push(DIR.DOWN);  handled = true; break;
          case KEY.ESC:    lose();                  handled = true; break;
        }
      } 
      else if (ev.keyCode == KEY.SPACE) {
        play();
        handled = true;
      }
      if (handled)
        ev.preventDefault(); // 방향키가 원래의 용도(페이지 스크롤)로 쓰이는 것 방지 (익스플로러는 9버전 이상에서 작동)
    }

    //-------------------------------------------------------------------------
    // GAME LOGIC
    //-------------------------------------------------------------------------
    function play() { hide('start'); reset();          playing = true;  level = 1; }
    function lose() { 
	// 점수 출력
    	if(confirm("당신의 점수는 " + vscore + "점 입니다. 등록하시겠습니까?")) {
    		var name = prompt("이름을 입력해주세요.", "noname");

    		xmlhttp.onreadystatechange = function() { 
    		    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
    		         //통신 성공시 구현부분
    		         //alert("통신 성공 - 등록되었습니다.");
    		    } else {
    		    	//통신 실패시 구현부분
    		        //alert("통신 실패\n" + "readyState: " + xmlhttp.readyState + "\n" + "status: " + xmlhttp.status);
    		    }
    		}
    		// 이름과 점수를 서버로 전송
    		var url = "dbInsert.jsp?name=" + name + "&score=" + vscore; 
    		xmlhttp.open("GET", url, true); 
    		xmlhttp.send(); 
    		
    		location.reload();
    		
    	} else {	
    		//
    		location.reload();
    	}
		show('start'); 
		setVisualScore(); 
		audio.pause(); 			// 오디오 종료
		audio.currentTime = 0;	// 오디오 재생위치를 처음으로 되돌린다.
		playing = false; 
	}
    function setVisualScore(n)      { vscore = n || score; invalidateScore(); }
    function setScore(n)            { score = n; setVisualScore(n);  }
    function addScore(n)            { score = score + n;   }
    function clearScore()           { setScore(0); }
    function clearRows()            { setRows(0); }
	// setRows(n) - 제거한 라인 수(rows)가 증가할수록 step이 감소하여 조각이 더 빠르게 낙하
    function setRows(n)             { rows = n; step = Math.max(speed.min, speed.start - (speed.decrement*rows)); invalidateRows(); }
    function addRows(n)             { setRows(rows + n); }
	// getBlock() - 블록 정보를 가져오는 함수. 움직일 때마다 호출. 
    function getBlock(x,y)          { 
		return (blocks && blocks[x] ? blocks[x][y] : null); // 블록을 점유한 조각의 타입을 반환 (해당 열이 비어있거나, 점유되지 않은 경우 null(=false) 반환)
	}
    // setBlock() - 블록 정보를 저장하는 함수. 착지시 호출.
	function setBlock(x,y,type)     { 
		blocks[x] = blocks[x] || [];						// if(blocks[x]) blocks[x] = blocks[x];		else blocks = [];
		blocks[x][y] = type;								// (x,y) 블록에 착지한 조각의 타입을 대입. 그리고 blocks[x]가 값을 갖게 됨
		invalidate(); 
	} 
	// clearBlocks() - blocks 배열을 비움(모든 블록 초기화)
    function clearBlocks()          { blocks = []; invalidate(); }
    function clearActions()         { actions = [];	}
    function setCurrentPiece(piece) { current = piece || randomPiece(); invalidate();     }
    function setNextPiece(piece)    { next    = piece || randomPiece(); invalidateNext(); }

	// reset() - 게임 변수 초기화
    function reset() {
      dt = 0;
      clearActions();
      clearBlocks();
      clearRows();
      clearScore();
      setCurrentPiece(next);
      setNextPiece();
    }

	// update() - 화면 갱신
    function update(idt) {
      if (playing) {
        if (vscore < score)
          setVisualScore(vscore + 1);	// 화면에 보이는 점수를 실제 점수로 갱신
		  
        handle(actions.shift());		// 키 조작 함수 호출 (shift() - 배열 첫 번째 요소를 제거하고 반환하는 함수)
		
        dt = dt + idt;		// 진행 시간을 갱신 (idt가 클수록 dt > step 의 시점이 빨리오고, dt도 점점 증가하므로 조각의 낙하가 빨라짐)
		if (dt > step) {	// 진행 시간이 피스의 낙하 주기를 넘으면..
		  dt = dt - step;	// 낙하 주기를 다시 빼주고..
          drop(); 			// 피스 낙하
        }
        audio.play(); // 게임이 실행중일시 오디오 플레이
      }
    }

	// handle() - 키 조작
    function handle(action) {
      switch(action) {
        case DIR.LEFT:  move(DIR.LEFT);  break;
        case DIR.RIGHT: move(DIR.RIGHT); break;
        case DIR.UP:    rotate();        break;
        case DIR.DOWN:  drop();          break;
      }
    }
	
	// move() - 이동
    function move(dir) {
      var x = current.x, y = current.y;
      switch(dir) {
        case DIR.RIGHT: x = x + 1; break;
        case DIR.LEFT:  x = x - 1; break;
        case DIR.DOWN:  y = y + 1; break;
      }
      if (unoccupied(current.type, x, y, current.dir)) { // unoccupied() 검사를 통과해야 이동 수행
        current.x = x;
        current.y = y;
        invalidate();
        return true;
      }
      else {
        return false;
      }
    }
	
	// rotate() - 회전
    function rotate() {
      var newdir = (current.dir == DIR.MAX ? DIR.MIN : current.dir + 1); // 1->2->3->4->1->2.. 돌아가면서 방향 전환
      if (unoccupied(current.type, current.x, current.y, newdir)) {
        current.dir = newdir;
        invalidate();
      }
    }
	
	// drop() - 낙하
    function drop() {
      if (!move(DIR.DOWN)) {	// 한 칸 아래로 이동(false는 착지한 경우로 아래 코드 수행)
        addScore(10);
        dropPiece();			// 조각 착지
        removeLines();			// 라인 제거 검사
        setCurrentPiece(next);	// 다음 조각으로 전환
        setNextPiece(randomPiece());
        clearActions();			// 사용자 입력 초기화
        if (occupied(current.type, current.x, current.y, current.dir)) { // 새로 생성될 조각의 위치가 이미 점유되어 있으면 게임 종료
          lose();
        }
      }
    }
	
	// dropPiece() - 착지
    function dropPiece() {
      eachblock(current.type, current.x, current.y, current.dir, function(x, y) {
        setBlock(x, y, current.type);	// 조각이 위치한 각 블록을 점유 상태로 변경
      });
    }

	// removeLine() - 라인 제거 여부를 결정하는 함수
    function removeLines() {
      var x, y, complete, n = 0;
      for(y = ny ; y > 0 ; --y) {		// 바닥(y = ny)에서부터 천장(y = 0)까지..
        complete = true;
        for(x = 0 ; x < nx ; ++x) {
          if (!getBlock(x, y))			// 빈 블록이 있는 경우 라인을 제거하지 않음
            complete = false;
        }
        if (complete) {					// 완성된 라인이면..
          removeLine(y);				// 라인 제거
          y = y + 1;					// 윗줄로 대체된 라인을 다시 검사해야 하므로 아래로 한 칸 이동
          n++;							// 몇줄을 지웠는지 n값에 할당
        }
      }
      if (n > 0) {						// 지워진 블록 라인이 있을경우
        addRows(n);
        addScore(100*Math.pow(2,n-1));	// 지워진 줄의 수(n)만큼 점수를 할당 (1: 100, 2: 200, 3: 400, 4: 800)
      }
    }

	// removeLine() - 라인 제거 함수 , 라인 제거 후 해당 블록라인 윗 블록을 한줄씩 내림
    function removeLine(n) {
      var x, y;
      for(y = n ; y >= 0 ; --y) {	// 게임창 세로 y와 가로 x를 for문으로 반복하여 블록 체크
        for(x = 0 ; x < nx ; ++x)
          setBlock(x, y, (y == 0) ? null : getBlock(x, y-1)); // n 위로는 모두 자신의 윗줄로 대체(한 줄 내려오는 효과)
      }
    }

    //-------------------------------------------------------------------------
    // RENDERING
    //-------------------------------------------------------------------------

    var invalid = {}; // 각각의 부분별 다시 그려줘야 할지 판단할 때 쓰이는 변수
	
    function invalidate()         { invalid.court  = true; }	// 게임판 내부를 다시 그려줘야 할 시
    function invalidateNext()     { invalid.next   = true; }	// 다음블록모양 다시 그려줘야 할 시 실행
    function invalidateScore()    { invalid.score  = true; }	// 점수 다시 그려줘야 할 시
    function invalidateRows()     { invalid.rows   = true; }	// 없앤 줄 수 다시 그려줘야 할 시
	
	// draw() - 그리기 작업을 해주는 함수 각각의 그리기 함수를 포함함
    function draw() { 
      ctx.save();				// 게임판 영역의 특성 저장
      ctx.lineWidth = 1;		// 게임판 영역의 외각선 두께 변경
      ctx.translate(0.5, 0.5);	// for crisp 1px black lines
      drawCourt();
      drawNext();
      drawScore();
      drawRows();
      drawLevels();
      ctx.restore();			// 게임판 영역의 특성 복원
    }
	
	// drawCourt() - 게임판 내부를 그리는 함수
    function drawCourt() {	
      if (invalid.court) {	// invalid.court변수의 값이 true일 경우 실행
        ctx.clearRect(0, 0, canvas.width, canvas.height);	// 게임판 내부 그림 클리어
        if (playing)		// 게임이 플레이(진행중)일때 진행중인 블록 그리기
          drawPiece(ctx, current.type, current.x, current.y, current.dir);
        var x, y, block;
        for(y = 0 ; y < ny ; y++) {
          for (x = 0 ; x < nx ; x++) {
            if (block = getBlock(x,y))	// 게임판 데이터 확인 후 쌓여있는 블럭이 있으면 그리기
              drawBlock(ctx, x, y, block.color);
          }
        }
        ctx.strokeRect(0, 0, nx*dx - 1, ny*dy - 1);	// 게임판 외각선 그리기
        invalid.court = false;						// 함수실행 확인 변수 false로 초기화
      }
    }
	
	// drawNext() - 다음 블록모양 그려주는 함수
    function drawNext() {
      if (invalid.next) {	// invalid.next변수의 값이 true일 경우 실행
        var padding = (nu - next.type.size) / 2;				// half-arsed attempt at centering next piece display
        uctx.save();											// 그려줄 영역의 특성 저장
        uctx.translate(0.5, 0.5);								// 그려줄 영역 이동
        uctx.clearRect(0, 0, nu*dx, nu*dy);						// 그려줄 영역 그림 클리어
        drawPiece(uctx, next.type, padding, padding, next.dir);	// 다음 블록 그리기
        uctx.strokeStyle = 'black';								// 그려줄 외각선 색상변경
        uctx.strokeRect(0, 0, nu*dx - 1, nu*dy - 1);			// 그려줄 영역 외각선 그리기
        uctx.restore();											// 그려줄 영역의 특성 복원
        invalid.next = false;									// 함수실행 확인 변수 false로 초기화
      }
    }
	
	// drawScore() - 점수를 그려주는 함수
    function drawScore() { 
      if (invalid.score) {	// invalid.score변수가 true일 경우 실행
        html('score', ("00000" + Math.floor(vscore)).slice(-5));	// 점수 그리기
        invalid.score = false;	// 함수실행 확인 변수 false로 초기화
      }
    }
	
	// drawRows() - 클리어시킨 줄 수 그려주는 함수
    function drawRows() {
      if (invalid.rows) {		// invalid.rows 변수가 true일 경우 실행
        html('rows', rows);		// 줄 수 그리기
        invalid.rows = false;	// 함수실행 확인 변수 false로 초기화
      }
    }
	
	// drawLevel() - 레벨 그려주는 함수
    function drawLevels() { 
      html('level', level);	// 레벨 그리기
    }
	
	// drawPiece() - 블록 그리는 함수
    function drawPiece(ctx, type, x, y, dir) { 
      eachblock(type, x, y, dir, function(x, y) {
        drawBlock(ctx, x, y, type.color);
      });
    }
	
	// drawBlock() - 블록의 각각의 조각 그리는 함수
    function drawBlock(ctx, x, y, color) {
      ctx.fillStyle = color;
      ctx.fillRect(x*dx, y*dy, dx, dy);
      ctx.strokeRect(x*dx, y*dy, dx, dy)
    }

    //-------------------------------------------------------------------------
    // FINALLY, lets run the game
    //-------------------------------------------------------------------------

    run();

  </script>

</body>
</html>
